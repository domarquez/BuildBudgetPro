import { useEffect, useRef, useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Hammer, Trophy, RotateCcw, Play, Pause, Volume2, VolumeX } from "lucide-react";

interface GameState {
  player: {
    x: number;
    y: number;
    width: number;
    height: number;
    speed: number;
    jumping: boolean;
    jumpPower: number;
    velocityY: number;
    hammer: boolean;
    hammerTimer: number;
    hammerAngle: number;
  };
  cubes: Array<{
    x: number;
    y: number;
    width: number;
    height: number;
    shade: string;
  }>;
  score: number;
  gameOver: boolean;
  isPaused: boolean;
  level: number;
  highScore: number;
}

export function ConstructorGame() {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const gameStateRef = useRef<GameState | null>(null);
  const animationFrameRef = useRef<number | null>(null);
  const [score, setScore] = useState(0);
  const [highScore, setHighScore] = useState(() => {
    return parseInt(localStorage.getItem('constructorGameHighScore') || '0');
  });
  const [level, setLevel] = useState(1);
  const [gameOver, setGameOver] = useState(false);
  const [isPaused, setIsPaused] = useState(false);
  const [soundEnabled, setSoundEnabled] = useState(true);
  const [isExpanded, setIsExpanded] = useState(false);

  // Sprites del juego - Constructor MICAA mejorado con piernas de caricatura
  const playerSprite = [
    [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0], // Casco MICAA superior
    [0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0], // Casco completo
    [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0], // Casco con visera
    [0,1,1,0,1,1,0,0,0,0,1,1,0,1,1,0], // Cara (ojos)
    [0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0], // Cara (boca sonriente)
    [0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0], // Cuello
    [0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0], // Camisa MICAA
    [0,0,1,1,0,0,1,1,1,1,0,0,1,1,0,0], // Camisa/brazos musculosos
    [0,0,1,1,0,0,1,1,1,1,0,0,1,1,0,0], // Brazos fuertes
    [0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0], // Cinturón de herramientas
    [0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0], // Pantalones de trabajo
    [0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0], // Pantalones
    [0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0], // Piernas cortas de caricatura
    [0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0], // Piernas cortas
    [0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0], // Botas de seguridad
    [0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0]  // Suela antideslizante
  ];

  // Martillo MICAA estilo Thor épico
  const hammerSprite = [
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2], // Cabeza del martillo épico
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,1,1,1,2,2], // Detalles metálicos
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,1,1,1,1,1,1,2], // Superficie del martillo
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,1,1,1,1,1,1,1,2], // Cabeza maciza
    [0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,1,1,1,1,1,1,1,1,2], // Martillo poderoso
    [0,0,0,0,0,0,0,0,0,0,0,0,2,2,1,1,1,1,1,1,1,1,1,2], // Diseño épico
    [0,0,0,0,0,0,0,0,0,0,0,2,2,1,1,1,1,1,1,1,1,1,1,2], // Martillo MICAA
    [0,0,0,0,0,0,0,0,0,0,2,2,1,1,1,1,1,1,1,1,1,1,1,2], // Poder de Thor
    [0,0,0,0,0,0,0,0,0,2,2,1,1,1,1,1,1,1,1,1,1,1,1,2], // Fuerza divina
    [0,0,0,0,0,0,0,0,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,2], // Martillo legendario
    [0,0,0,0,0,0,0,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2], // Constructor épico
    [0,0,0,0,0,0,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2], // Destructor de cubos
    [0,0,0,0,0,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2], // Herramienta divina
    [0,0,0,0,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2], // Mjolnir MICAA
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,0], // Mango de madera noble
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,0], // Empuñadura perfecta
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,0], // Mango resistente
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,0], // Madera sagrada
    [0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,3,3,0,0,0,0], // Transición del mango
    [0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,3,3,0,0,0,0,0], // Extremo del mango
    [0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,3,3,0,0,0,0,0,0], // Punta del mango
    [0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,3,3,0,0,0,0,0,0,0], // Final épico
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0], // Remate del martillo
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]  // Espacio final
  ];

  // Función para reproducir sonidos (simplificada)
  const playSound = (type: 'hit' | 'jump' | 'gameOver') => {
    if (!soundEnabled) return;
    
    const audioContext = new (window.AudioContext || (window as any).webkitAudioContext)();
    const oscillator = audioContext.createOscillator();
    const gainNode = audioContext.createGain();
    
    oscillator.connect(gainNode);
    gainNode.connect(audioContext.destination);
    
    switch (type) {
      case 'hit':
        oscillator.frequency.setValueAtTime(440, audioContext.currentTime);
        oscillator.frequency.exponentialRampToValueAtTime(220, audioContext.currentTime + 0.1);
        break;
      case 'jump':
        oscillator.frequency.setValueAtTime(330, audioContext.currentTime);
        oscillator.frequency.exponentialRampToValueAtTime(550, audioContext.currentTime + 0.15);
        break;
      case 'gameOver':
        oscillator.frequency.setValueAtTime(220, audioContext.currentTime);
        oscillator.frequency.exponentialRampToValueAtTime(110, audioContext.currentTime + 0.5);
        break;
    }
    
    gainNode.gain.setValueAtTime(0.1, audioContext.currentTime);
    gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.2);
    
    oscillator.start(audioContext.currentTime);
    oscillator.stop(audioContext.currentTime + 0.2);
  };

  // Inicializar el juego
  const initializeGame = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const gameState: GameState = {
      player: {
        x: 50,
        y: canvas.height - 50,
        width: 32,
        height: 32,
        speed: 5,
        jumping: false,
        jumpPower: 15,
        velocityY: 0,
        hammer: false,
        hammerTimer: 0,
        hammerAngle: 0
      },
      cubes: [],
      score: 0,
      gameOver: false,
      isPaused: false,
      level: 1,
      highScore: highScore
    };

    // Crear cubos iniciales
    const cubeSize = 32;
    const rows = Math.ceil(canvas.height / cubeSize);
    const shades = ['#8B4513', '#A0522D', '#CD853F', '#DEB887', '#F4A460'];
    
    for (let x = canvas.width; x >= canvas.width - 32 * 5; x -= 32) {
      for (let row = 0; row < rows; row++) {
        gameState.cubes.push({
          x: x,
          y: row * cubeSize,
          width: cubeSize,
          height: cubeSize,
          shade: shades[Math.floor(Math.random() * shades.length)]
        });
      }
    }

    gameStateRef.current = gameState;
    setScore(0);
    setLevel(1);
    setGameOver(false);
    setIsPaused(false);
  };

  // Dibujar sprite pixelado con soporte para múltiples colores
  const drawSprite = (ctx: CanvasRenderingContext2D, sprite: number[][], x: number, y: number, width: number, height: number, colors: string[] = ['#2C5530']) => {
    const pixelSize = width / sprite[0].length;
    for (let i = 0; i < sprite.length; i++) {
      for (let j = 0; j < sprite[0].length; j++) {
        const pixel = sprite[i][j];
        if (pixel > 0) {
          // Mapeo de colores para el martillo épico y constructor MICAA
          if (colors.length === 1) {
            ctx.fillStyle = colors[0];
          } else {
            switch (pixel) {
              case 1: ctx.fillStyle = colors[0] || '#C0C0C0'; break; // Plateado metálico
              case 2: ctx.fillStyle = colors[1] || '#4A4A4A'; break; // Acero oscuro
              case 3: ctx.fillStyle = colors[2] || '#8B4513'; break; // Madera
              default: ctx.fillStyle = colors[0] || '#2C5530'; break;
            }
          }
          ctx.fillRect(x + j * pixelSize, y + i * pixelSize, pixelSize, pixelSize);
        }
      }
    }
  };

  // Crear nueva columna de cubos
  const createColumn = (x: number, canvas: HTMLCanvasElement) => {
    const cubeSize = 32;
    const rows = Math.ceil(canvas.height / cubeSize);
    const shades = ['#8B4513', '#A0522D', '#CD853F', '#DEB887', '#F4A460'];
    const column = [];
    
    for (let row = 0; row < rows; row++) {
      column.push({
        x: x,
        y: row * cubeSize,
        width: cubeSize,
        height: cubeSize,
        shade: shades[Math.floor(Math.random() * shades.length)]
      });
    }
    return column;
  };

  // Actualizar el juego
  const updateGame = () => {
    const canvas = canvasRef.current;
    const gameState = gameStateRef.current;
    if (!canvas || !gameState || gameState.gameOver || gameState.isPaused) return;

    const { player } = gameState;

    // Física del jugador
    player.velocityY += 0.8; // Gravedad
    player.y += player.velocityY;
    
    if (player.y > canvas.height - player.height) {
      player.y = canvas.height - player.height;
      player.jumping = false;
      player.velocityY = 0;
    }

    // Actualizar martillo
    if (player.hammer) {
      player.hammerTimer--;
      player.hammerAngle += 0.3;
      if (player.hammerTimer <= 0) {
        player.hammer = false;
      }
    }

    // Colisión del martillo con cubos
    if (player.hammer) {
      const hammerWidth = 48;
      const hammerHeight = 48;
      const hammerX = player.x + player.width;
      const hammerY = player.y - 16;

      gameState.cubes = gameState.cubes.filter(cube => {
        if (hammerX + hammerWidth > cube.x &&
            hammerX < cube.x + cube.width &&
            hammerY + hammerHeight > cube.y &&
            hammerY < cube.y + cube.height) {
          gameState.score += 10 + (gameState.level * 2);
          playSound('hit');
          return false;
        }
        return true;
      });
    }

    // Mover cubos
    const speed = 0.5 + (gameState.level * 0.1);
    gameState.cubes.forEach(cube => {
      cube.x -= speed;
    });

    // Añadir nuevas columnas
    const rightmostCube = gameState.cubes.length > 0 
      ? gameState.cubes.reduce((max, cube) => Math.max(max, cube.x), -Infinity) 
      : -Infinity;
      
    if (rightmostCube < canvas.width - 32) {
      const newColumn = createColumn(canvas.width, canvas);
      gameState.cubes.push(...newColumn);
    }

    // Eliminar cubos fuera del canvas
    gameState.cubes = gameState.cubes.filter(cube => cube.x + cube.width > 0);

    // Verificar Game Over
    const playerEdge = player.x + player.width;
    const leftmostCube = gameState.cubes.length > 0 
      ? gameState.cubes.reduce((min, cube) => Math.min(min, cube.x), canvas.width) 
      : canvas.width;

    if (leftmostCube <= playerEdge + 5) {
      gameState.gameOver = true;
      setGameOver(true);
      playSound('gameOver');
      
      if (gameState.score > gameState.highScore) {
        gameState.highScore = gameState.score;
        setHighScore(gameState.score);
        localStorage.setItem('constructorGameHighScore', gameState.score.toString());
      }
    }

    // Actualizar nivel
    const newLevel = Math.floor(gameState.score / 200) + 1;
    if (newLevel > gameState.level) {
      gameState.level = newLevel;
      setLevel(newLevel);
    }

    setScore(gameState.score);
  };

  // Dibujar el juego
  const drawGame = () => {
    const canvas = canvasRef.current;
    const ctx = canvas?.getContext('2d');
    const gameState = gameStateRef.current;
    if (!canvas || !ctx || !gameState) return;

    // Limpiar canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Fondo con gradiente
    const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
    gradient.addColorStop(0, '#87CEEB');
    gradient.addColorStop(1, '#98FB98');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    // Dibujar jugador - Constructor MICAA con colores profesionales
    drawSprite(ctx, playerSprite, gameState.player.x, gameState.player.y, 
               gameState.player.width, gameState.player.height, ['#2C5530']); // Verde constructor

    // Dibujar martillo épico estilo Thor
    if (gameState.player.hammer) {
      ctx.save();
      ctx.translate(gameState.player.x + gameState.player.width + 24, gameState.player.y + 16);
      ctx.rotate(gameState.player.hammerAngle);
      
      // Efecto de brillo divino del martillo
      ctx.shadowColor = '#FFD700';
      ctx.shadowBlur = 10;
      
      // Colores del martillo épico: [metal plateado, acero oscuro, madera noble]
      drawSprite(ctx, hammerSprite, -24, -24, 48, 48, ['#E6E6E6', '#2F2F2F', '#8B4513']);
      
      ctx.shadowBlur = 0;
      ctx.restore();
    }

    // Dibujar cubos con sombra
    gameState.cubes.forEach(cube => {
      // Sombra
      ctx.fillStyle = 'rgba(0, 0, 0, 0.2)';
      ctx.fillRect(cube.x + 2, cube.y + 2, cube.width, cube.height);
      
      // Cubo
      ctx.fillStyle = cube.shade;
      ctx.fillRect(cube.x, cube.y, cube.width, cube.height);
      
      // Borde del cubo
      ctx.strokeStyle = '#654321';
      ctx.lineWidth = 1;
      ctx.strokeRect(cube.x, cube.y, cube.width, cube.height);
    });

    // UI del juego
    ctx.fillStyle = 'rgba(0, 0, 0, 0.7)';
    ctx.fillRect(5, 5, 200, 80);
    
    ctx.fillStyle = '#FFFFFF';
    ctx.font = 'bold 14px Arial';
    ctx.fillText(`Puntos: ${gameState.score}`, 10, 25);
    ctx.fillText(`Nivel: ${gameState.level}`, 10, 45);
    ctx.fillText(`Récord: ${gameState.highScore}`, 10, 65);

    // Mostrar Game Over
    if (gameState.gameOver) {
      ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
      ctx.fillRect(0, 0, canvas.width, canvas.height);
      
      ctx.fillStyle = '#FFFFFF';
      ctx.font = 'bold 24px Arial';
      ctx.textAlign = 'center';
      ctx.fillText('¡GAME OVER!', canvas.width / 2, canvas.height / 2 - 20);
      ctx.font = '16px Arial';
      ctx.fillText(`Puntuación Final: ${gameState.score}`, canvas.width / 2, canvas.height / 2 + 10);
      ctx.fillText('Presiona R para reiniciar', canvas.width / 2, canvas.height / 2 + 40);
      ctx.textAlign = 'left';
    }

    // Mostrar pausa
    if (gameState.isPaused && !gameState.gameOver) {
      ctx.fillStyle = 'rgba(0, 0, 0, 0.6)';
      ctx.fillRect(0, 0, canvas.width, canvas.height);
      
      ctx.fillStyle = '#FFFFFF';
      ctx.font = 'bold 24px Arial';
      ctx.textAlign = 'center';
      ctx.fillText('PAUSADO', canvas.width / 2, canvas.height / 2);
      ctx.textAlign = 'left';
    }
  };

  // Bucle del juego
  const gameLoop = () => {
    updateGame();
    drawGame();
    animationFrameRef.current = requestAnimationFrame(gameLoop);
  };

  // Manejar controles del teclado
  const handleKeyPress = (e: KeyboardEvent) => {
    const gameState = gameStateRef.current;
    if (!gameState) return;

    switch (e.code) {
      case 'ArrowRight':
      case 'KeyD':
        if (!gameState.gameOver && !gameState.isPaused) {
          gameState.player.x += gameState.player.speed;
        }
        break;
      case 'ArrowUp':
      case 'KeyW':
      case 'Space':
        if (!gameState.gameOver && !gameState.isPaused && !gameState.player.jumping) {
          gameState.player.velocityY = -gameState.player.jumpPower;
          gameState.player.jumping = true;
          playSound('jump');
        }
        e.preventDefault();
        break;
      case 'KeyX':
      case 'Enter':
        if (!gameState.gameOver && !gameState.isPaused && !gameState.player.hammer) {
          gameState.player.hammer = true;
          gameState.player.hammerTimer = 30;
          gameState.player.hammerAngle = 0;
        }
        break;
      case 'KeyR':
        if (gameState.gameOver) {
          initializeGame();
        }
        break;
      case 'KeyP':
        if (!gameState.gameOver) {
          gameState.isPaused = !gameState.isPaused;
          setIsPaused(gameState.isPaused);
        }
        break;
    }
  };

  // Efectos
  useEffect(() => {
    initializeGame();
    
    document.addEventListener('keydown', handleKeyPress);
    animationFrameRef.current = requestAnimationFrame(gameLoop);

    return () => {
      document.removeEventListener('keydown', handleKeyPress);
      if (animationFrameRef.current) {
        cancelAnimationFrame(animationFrameRef.current);
      }
    };
  }, []);

  const togglePause = () => {
    const gameState = gameStateRef.current;
    if (gameState && !gameState.gameOver) {
      gameState.isPaused = !gameState.isPaused;
      setIsPaused(gameState.isPaused);
    }
  };

  const resetGame = () => {
    initializeGame();
  };

  if (!isExpanded) {
    return (
      <Card className="shadow-material mb-8">
        <CardHeader className="pb-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-br from-orange-400 to-red-500 rounded-lg flex items-center justify-center">
                <Hammer className="w-5 h-5 text-white" />
              </div>
              <div>
                <CardTitle className="text-lg">Juego del Constructor</CardTitle>
                <p className="text-sm text-gray-600">¡Destruye los cubos con tu martillo!</p>
              </div>
            </div>
            <div className="flex items-center space-x-2">
              <Badge variant="secondary" className="flex items-center space-x-1">
                <Trophy className="w-3 h-3" />
                <span>{highScore}</span>
              </Badge>
              <Button onClick={() => setIsExpanded(true)} size="sm">
                <Play className="w-4 h-4 mr-2" />
                Jugar
              </Button>
            </div>
          </div>
        </CardHeader>
      </Card>
    );
  }

  return (
    <Card className="shadow-material mb-8">
      <CardHeader className="pb-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-gradient-to-br from-orange-400 to-red-500 rounded-lg flex items-center justify-center">
              <Hammer className="w-5 h-5 text-white" />
            </div>
            <div>
              <CardTitle className="text-lg">Juego del Constructor MICAA</CardTitle>
              <p className="text-sm text-gray-600">Usa las flechas o WASD para moverte • X o Enter para martillo • P para pausa</p>
            </div>
          </div>
          <div className="flex items-center space-x-2">
            <Badge variant="outline">Nivel {level}</Badge>
            <Badge variant="secondary" className="flex items-center space-x-1">
              <Trophy className="w-3 h-3" />
              <span>{score}</span>
            </Badge>
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setSoundEnabled(!soundEnabled)}
            >
              {soundEnabled ? <Volume2 className="w-4 h-4" /> : <VolumeX className="w-4 h-4" />}
            </Button>
            <Button
              variant="outline"
              size="sm"
              onClick={togglePause}
              disabled={gameOver}
            >
              {isPaused ? <Play className="w-4 h-4" /> : <Pause className="w-4 h-4" />}
            </Button>
            <Button variant="outline" size="sm" onClick={resetGame}>
              <RotateCcw className="w-4 h-4" />
            </Button>
            <Button variant="ghost" size="sm" onClick={() => setIsExpanded(false)}>
              ✕
            </Button>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        <div className="flex justify-center">
          <canvas
            ref={canvasRef}
            width={800}
            height={200}
            className="border-2 border-gray-300 rounded-lg shadow-inner bg-gradient-to-b from-blue-100 to-green-100"
            style={{ imageRendering: 'pixelated' }}
          />
        </div>
        <div className="mt-4 text-center text-sm text-gray-600">
          <p>Récord Personal: <span className="font-semibold text-orange-600">{highScore} puntos</span></p>
          {gameOver && (
            <p className="mt-2 text-red-600 font-medium">
              ¡Game Over! Presiona el botón de reinicio o la tecla R para volver a jugar
            </p>
          )}
        </div>
      </CardContent>
    </Card>
  );
}