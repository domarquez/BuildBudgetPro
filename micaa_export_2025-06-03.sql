--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9
-- Dumped by pg_dump version 16.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.activities (
    id integer NOT NULL,
    phase_id integer NOT NULL,
    name text NOT NULL,
    unit text NOT NULL,
    description text,
    unit_price numeric(10,2) DEFAULT '0'::numeric
);


ALTER TABLE public.activities OWNER TO neondb_owner;

--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.activities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.activities_id_seq OWNER TO neondb_owner;

--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: activity_compositions; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.activity_compositions (
    id integer NOT NULL,
    activity_id integer NOT NULL,
    material_id integer,
    description text NOT NULL,
    unit text NOT NULL,
    quantity numeric(10,4) NOT NULL,
    unit_cost numeric(10,2) NOT NULL,
    type text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    labor_id integer,
    tool_id integer
);


ALTER TABLE public.activity_compositions OWNER TO neondb_owner;

--
-- Name: activity_compositions_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.activity_compositions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.activity_compositions_id_seq OWNER TO neondb_owner;

--
-- Name: activity_compositions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.activity_compositions_id_seq OWNED BY public.activity_compositions.id;


--
-- Name: budget_items; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.budget_items (
    id integer NOT NULL,
    budget_id integer NOT NULL,
    activity_id integer NOT NULL,
    quantity numeric(10,3) NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    phase_id integer
);


ALTER TABLE public.budget_items OWNER TO neondb_owner;

--
-- Name: budget_items_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.budget_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.budget_items_id_seq OWNER TO neondb_owner;

--
-- Name: budget_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.budget_items_id_seq OWNED BY public.budget_items.id;


--
-- Name: budgets; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.budgets (
    id integer NOT NULL,
    project_id integer NOT NULL,
    phase_id integer,
    total numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.budgets OWNER TO neondb_owner;

--
-- Name: budgets_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.budgets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.budgets_id_seq OWNER TO neondb_owner;

--
-- Name: budgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.budgets_id_seq OWNED BY public.budgets.id;


--
-- Name: city_price_factors; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.city_price_factors (
    id integer NOT NULL,
    city text NOT NULL,
    country text DEFAULT 'Bolivia'::text NOT NULL,
    materials_factor numeric(10,4) DEFAULT 1.0000 NOT NULL,
    labor_factor numeric(10,4) DEFAULT 1.0000 NOT NULL,
    equipment_factor numeric(10,4) DEFAULT 1.0000 NOT NULL,
    transport_factor numeric(10,4) DEFAULT 1.0000 NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.city_price_factors OWNER TO neondb_owner;

--
-- Name: city_price_factors_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.city_price_factors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.city_price_factors_id_seq OWNER TO neondb_owner;

--
-- Name: city_price_factors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.city_price_factors_id_seq OWNED BY public.city_price_factors.id;


--
-- Name: company_advertisements; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.company_advertisements (
    id integer NOT NULL,
    supplier_id integer NOT NULL,
    title text NOT NULL,
    description text,
    image_url text NOT NULL,
    link_url text,
    ad_type text DEFAULT 'banner'::text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    start_date timestamp without time zone DEFAULT now(),
    end_date timestamp without time zone,
    view_count integer DEFAULT 0 NOT NULL,
    click_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.company_advertisements OWNER TO neondb_owner;

--
-- Name: company_advertisements_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.company_advertisements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.company_advertisements_id_seq OWNER TO neondb_owner;

--
-- Name: company_advertisements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.company_advertisements_id_seq OWNED BY public.company_advertisements.id;


--
-- Name: construction_phases; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.construction_phases (
    id integer NOT NULL,
    name text NOT NULL,
    description text
);


ALTER TABLE public.construction_phases OWNER TO neondb_owner;

--
-- Name: construction_phases_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.construction_phases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.construction_phases_id_seq OWNER TO neondb_owner;

--
-- Name: construction_phases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.construction_phases_id_seq OWNED BY public.construction_phases.id;


--
-- Name: consultation_messages; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.consultation_messages (
    id integer NOT NULL,
    user_id integer,
    name text NOT NULL,
    email text NOT NULL,
    message_type text DEFAULT 'consulta'::text NOT NULL,
    subject text NOT NULL,
    message text NOT NULL,
    status text DEFAULT 'pendiente'::text NOT NULL,
    admin_response text,
    is_public boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    responded_at timestamp without time zone
);


ALTER TABLE public.consultation_messages OWNER TO neondb_owner;

--
-- Name: consultation_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.consultation_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.consultation_messages_id_seq OWNER TO neondb_owner;

--
-- Name: consultation_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.consultation_messages_id_seq OWNED BY public.consultation_messages.id;


--
-- Name: labor_categories; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.labor_categories (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    unit text NOT NULL,
    hourly_rate numeric(10,2) NOT NULL,
    skill_level text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.labor_categories OWNER TO neondb_owner;

--
-- Name: labor_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.labor_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.labor_categories_id_seq OWNER TO neondb_owner;

--
-- Name: labor_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.labor_categories_id_seq OWNED BY public.labor_categories.id;


--
-- Name: material_categories; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.material_categories (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.material_categories OWNER TO neondb_owner;

--
-- Name: material_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.material_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.material_categories_id_seq OWNER TO neondb_owner;

--
-- Name: material_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.material_categories_id_seq OWNED BY public.material_categories.id;


--
-- Name: material_supplier_prices; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.material_supplier_prices (
    id integer NOT NULL,
    material_id integer NOT NULL,
    supplier_id integer NOT NULL,
    price numeric(12,4) NOT NULL,
    currency text DEFAULT 'BOB'::text NOT NULL,
    minimum_quantity numeric(10,2) DEFAULT 1.00,
    lead_time_days integer DEFAULT 0,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    last_updated timestamp without time zone DEFAULT now(),
    valid_until timestamp without time zone,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.material_supplier_prices OWNER TO neondb_owner;

--
-- Name: material_supplier_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.material_supplier_prices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.material_supplier_prices_id_seq OWNER TO neondb_owner;

--
-- Name: material_supplier_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.material_supplier_prices_id_seq OWNED BY public.material_supplier_prices.id;


--
-- Name: materials; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.materials (
    id integer NOT NULL,
    category_id integer NOT NULL,
    name text NOT NULL,
    unit text NOT NULL,
    price numeric(10,2) NOT NULL,
    description text,
    last_updated timestamp without time zone DEFAULT now()
);


ALTER TABLE public.materials OWNER TO neondb_owner;

--
-- Name: materials_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.materials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.materials_id_seq OWNER TO neondb_owner;

--
-- Name: materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.materials_id_seq OWNED BY public.materials.id;


--
-- Name: price_settings; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.price_settings (
    id integer NOT NULL,
    usd_exchange_rate numeric(10,4) DEFAULT 6.96 NOT NULL,
    inflation_factor numeric(10,4) DEFAULT 1.0000 NOT NULL,
    global_adjustment_factor numeric(10,4) DEFAULT 1.0000 NOT NULL,
    last_updated timestamp without time zone DEFAULT now() NOT NULL,
    updated_by text
);


ALTER TABLE public.price_settings OWNER TO neondb_owner;

--
-- Name: price_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.price_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.price_settings_id_seq OWNER TO neondb_owner;

--
-- Name: price_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.price_settings_id_seq OWNED BY public.price_settings.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    name text NOT NULL,
    client text,
    location text,
    start_date timestamp without time zone,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    user_id integer,
    status text DEFAULT 'planning'::text NOT NULL,
    city text,
    country text DEFAULT 'Bolivia'::text,
    equipment_percentage numeric(5,2) DEFAULT 5.00 NOT NULL,
    administrative_percentage numeric(5,2) DEFAULT 8.00 NOT NULL,
    utility_percentage numeric(5,2) DEFAULT 15.00 NOT NULL,
    tax_percentage numeric(5,2) DEFAULT 3.09 NOT NULL,
    social_charges_percentage numeric(5,2) DEFAULT 71.18 NOT NULL
);


ALTER TABLE public.projects OWNER TO neondb_owner;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.projects_id_seq OWNER TO neondb_owner;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: supplier_companies; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.supplier_companies (
    id integer NOT NULL,
    user_id integer NOT NULL,
    company_name text NOT NULL,
    business_type text,
    description text,
    address text,
    city text,
    country text DEFAULT 'Bolivia'::text,
    phone text,
    whatsapp text,
    website text,
    facebook text,
    logo_url text,
    image_urls text[],
    membership_type text DEFAULT 'free'::text NOT NULL,
    membership_expires_at timestamp without time zone,
    is_active boolean DEFAULT true NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    rating numeric(3,2) DEFAULT 0.00,
    review_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    speciality text
);


ALTER TABLE public.supplier_companies OWNER TO neondb_owner;

--
-- Name: supplier_companies_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.supplier_companies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.supplier_companies_id_seq OWNER TO neondb_owner;

--
-- Name: supplier_companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.supplier_companies_id_seq OWNED BY public.supplier_companies.id;


--
-- Name: system_settings; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.system_settings (
    id integer NOT NULL,
    setting_key text NOT NULL,
    setting_value text NOT NULL,
    description text,
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.system_settings OWNER TO neondb_owner;

--
-- Name: system_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.system_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_settings_id_seq OWNER TO neondb_owner;

--
-- Name: system_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.system_settings_id_seq OWNED BY public.system_settings.id;


--
-- Name: tools; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.tools (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    unit text NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.tools OWNER TO neondb_owner;

--
-- Name: tools_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.tools_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tools_id_seq OWNER TO neondb_owner;

--
-- Name: tools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.tools_id_seq OWNED BY public.tools.id;


--
-- Name: user_material_prices; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.user_material_prices (
    id integer NOT NULL,
    user_id integer NOT NULL,
    material_id integer NOT NULL,
    custom_price numeric(10,2) NOT NULL,
    reason text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.user_material_prices OWNER TO neondb_owner;

--
-- Name: user_material_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.user_material_prices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_material_prices_id_seq OWNER TO neondb_owner;

--
-- Name: user_material_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.user_material_prices_id_seq OWNED BY public.user_material_prices.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    email text NOT NULL,
    first_name text,
    last_name text,
    role text DEFAULT 'user'::text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    last_login timestamp without time zone,
    city text,
    country text DEFAULT 'Bolivia'::text,
    user_type text DEFAULT 'architect'::text NOT NULL
);


ALTER TABLE public.users OWNER TO neondb_owner;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO neondb_owner;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: activity_compositions id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.activity_compositions ALTER COLUMN id SET DEFAULT nextval('public.activity_compositions_id_seq'::regclass);


--
-- Name: budget_items id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.budget_items ALTER COLUMN id SET DEFAULT nextval('public.budget_items_id_seq'::regclass);


--
-- Name: budgets id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.budgets ALTER COLUMN id SET DEFAULT nextval('public.budgets_id_seq'::regclass);


--
-- Name: city_price_factors id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.city_price_factors ALTER COLUMN id SET DEFAULT nextval('public.city_price_factors_id_seq'::regclass);


--
-- Name: company_advertisements id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_advertisements ALTER COLUMN id SET DEFAULT nextval('public.company_advertisements_id_seq'::regclass);


--
-- Name: construction_phases id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.construction_phases ALTER COLUMN id SET DEFAULT nextval('public.construction_phases_id_seq'::regclass);


--
-- Name: consultation_messages id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.consultation_messages ALTER COLUMN id SET DEFAULT nextval('public.consultation_messages_id_seq'::regclass);


--
-- Name: labor_categories id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.labor_categories ALTER COLUMN id SET DEFAULT nextval('public.labor_categories_id_seq'::regclass);


--
-- Name: material_categories id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.material_categories ALTER COLUMN id SET DEFAULT nextval('public.material_categories_id_seq'::regclass);


--
-- Name: material_supplier_prices id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.material_supplier_prices ALTER COLUMN id SET DEFAULT nextval('public.material_supplier_prices_id_seq'::regclass);


--
-- Name: materials id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.materials ALTER COLUMN id SET DEFAULT nextval('public.materials_id_seq'::regclass);


--
-- Name: price_settings id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.price_settings ALTER COLUMN id SET DEFAULT nextval('public.price_settings_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: supplier_companies id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.supplier_companies ALTER COLUMN id SET DEFAULT nextval('public.supplier_companies_id_seq'::regclass);


--
-- Name: system_settings id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.system_settings ALTER COLUMN id SET DEFAULT nextval('public.system_settings_id_seq'::regclass);


--
-- Name: tools id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.tools ALTER COLUMN id SET DEFAULT nextval('public.tools_id_seq'::regclass);


--
-- Name: user_material_prices id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.user_material_prices ALTER COLUMN id SET DEFAULT nextval('public.user_material_prices_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.activities (id, phase_id, name, unit, description, unit_price) FROM stdin;
261	6	INSTALACIÓN ELÉCTRICA (CABLEADO)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Instalación Eléctrica (cableado)	120.25
273	6	PUNTO DE TOMACORRIENTE DOBLE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto de tomacorriente doble	136.65
271	6	PUNTO DE TOMA DE FUERZA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto de toma de fuerza	196.25
272	6	PUNTO DE TOMACORRIENTE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto de tomacorriente	77.96
265	6	PORTERO ELÉCTRICO EN VIVIENDA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Portero eléctrico en vivienda	696.83
269	6	PUNTO DE ILUMINACION CON TUBO FLUORESCENTES DE 20W	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto de iluminacion con tubo fluorescentes de 20W	269.21
244	6	CABLEADO Nº 10 INC. TUBO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cableado Nº 10 inc. tubo	24.66
246	6	CABLEADO Nº14	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cableado Nº14	18.88
267	6	PUNTO DE ILUMINACION CON FOCO INCANDESCENTE DE 60W	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto de iluminacion con foco incandescente de 60W	122.73
268	6	PUNTO DE ILUMINACION CON TUBO FLUORESCENTE DE 40W	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto de iluminacion con tubo fluorescente de 40W	243.01
245	6	CABLEADO Nº 12 INC. TUBO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cableado Nº 12 inc. tubo	20.46
260	6	INSTALACIÓN DE MEDIDOR ELÉCTRICO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Instalación de medidor eléctrico	86.00
248	6	COLOCACIÓN DE SPOT EN PUNTO DE LUZ	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Colocación de spot en punto de luz	181.54
281	6	PUNTO PARA TIMBRE ELECTRICO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto para timbre electrico	392.95
276	6	PUNTO PARA DUCHA ELECTRICA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto para ducha electrica	100.50
286	6	TOMACORRIENTE DOBLE CON TIERRA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tomacorriente doble con tierra	142.65
288	6	TOMACORRIENTE DOBLE DE PISO CON TIERRA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tomacorriente doble de piso con tierra	152.65
287	6	TOMACORRIENTE DOBLE DE PISO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tomacorriente doble de piso	145.65
241	6	ACOMETIDA DE INSTALACIÓN ELECTRICA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Acometida de instalación electrica	480.00
43	5	GRIFERÍA DE LAVAMANOS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Grifería de lavamanos	364.10
46	5	GRIFERÍA DE LAVARROPA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Grifería de lavarropa	119.13
47	5	GRIFERÍA PARA DUCHA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Grifería para ducha	387.77
55	5	JUEGO DE BAÑO DE VISITA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Juego de baño de visita	981.00
51	5	INODORO BLANCO TANQUE BAJO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Inodoro blanco tanque bajo	127.30
42	5	GRIFERÍA DE BIDÉ	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Grifería de bidé	284.30
48	5	GRIFERÍA PARA TINA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Grifería para tina	766.80
50	5	GRIFO MÓVIL NIQUELADO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Grifo móvil niquelado	317.30
54	4	JABONERO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Jabonero	90.02
45	5	GRIFERÍA DE LAVAPLATOS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Grifería de lavaplatos	344.30
6	1	ENTIBADO Y APUNTALADO	M2	Trabajos de entibado y apuntalamiento	5.13
40	5	DUCHA SANITARIA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Ducha sanitaria	368.30
38	4	BOX DE BAÑO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Box de baño	418.00
37	4	BOTIQUIN 1 CUERPO C/ESPEJO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Botiquin 1 cuerpo c/espejo	140.53
36	3	BIDE DE COLOR	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Bide de color	566.00
68	5	PAPELERO PARA BAÑO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Papelero para baño	99.88
77	4	BOX DE BAÑO CON ACRÍLICO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Box de baño con acrílico	418.00
56	5	LAVAMANOS BLANCO (CON PEDESTAL)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Lavamanos blanco (con pedestal)	533.30
87	4	HOJAS DE VENTANA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Hojas de ventana	317.54
129	4	ESCALERA MARINERA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Escalera marinera	1030.88
153	4	CIELO RASO ESTUCADO BAJO CERCHAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cielo raso estucado bajo cerchas	166.59
180	4	REMOCION DE CUBIERTA CALAMINA Y MADERAMEN	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Remocion de cubierta calamina y maderamen	5.31
182	4	REMOCION DE PISO DE CEMENTO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Remocion de piso de cemento	4.69
213	3	PARAPETO DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Parapeto de Ho Ao	6291.43
203	3	JUNTAS DE DILATACIÓN TÉRMICA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Juntas de dilatación térmica	627.19
274	6	PUNTO DE TOMACORRIENTE PARA COMPUTADORA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto de tomacorriente para computadora	89.44
242	6	ACOMETIDA TELEFÓNICA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Acometida telefónica	355.80
289	5	ACOMETIDA DE AGUA POTABLE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Acometida de agua potable	675.18
340	3	TUBO DE VENTILACIÓN DE PVC DE 3 PLG	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tubo de ventilación de PVC de 3 plg	42.52
335	3	TENDIDO TUBO DE PVC DE 4"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido tubo de PVC de 4"	47.01
358	3	MURO DE BLOQUE PREFABRICADO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro de bloque prefabricado	111.97
413	4	CONTRAPISO DE MORTERO ESP=7CM DOSIF 1:6	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Contrapiso de mortero esp=7cm dosif 1:6	133.13
442	7	ZÓCALO DE CERÁMICO ESMALTADO ANTIDESLIZANTE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Zócalo de cerámico esmaltado antideslizante	44.56
453	4	PICAPORTE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Picaporte	13.51
469	3	REVOQUE DE CEMENTO PLANCHADO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Revoque de cemento planchado	55.85
463	3	REVESTIMIENTO CON PIEDRA PIRKA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Revestimiento con piedra pirka	264.63
270	6	PUNTO DE ILUMINACION DOS TUBOS FLUORESCENTES DE 40W	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto de iluminacion dos tubos fluorescentes de 40W	364.06
53	5	INODORO DE TANQUE ALTO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Inodoro de tanque alto	1106.30
32	5	ACCESORIOS DE BAÑO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Accesorios de baño	354.13
49	5	GRIFERÍA PARA URINARIO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Grifería para urinario	259.16
33	5	BACHA PARA DUCHA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Bacha para ducha	590.25
58	5	LAVAMANOS DE COLOR (CON PEDESTAL)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Lavamanos de color (con pedestal)	546.30
62	5	LAVAPLATOS DE 2 BACHAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Lavaplatos de 2 bachas	566.80
73	5	TINA DE HIDROMASAJE D=2.30	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tina de hidromasaje D=2.30	313.25
86	4	ESCALERA DE MADERA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Escalera de madera	1108.00
92	3	MADERAMEM PARA ENTREPISO DE MACHIMBRE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Maderamem para entrepiso de machimbre	120.00
41	4	ESPEJO SOBRE PARED (BAÑOS)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Espejo sobre pared (baños)	200.00
76	4	URINARIO DE MAMPOSTERÍA REVESTIDO CON AZULEJO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Urinario de mampostería revestido con azulejo	133.60
85	3	DIVISIONES Y CAJONERÍA DE MELAMÍNICO EN VESTIDORES	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Divisiones y cajonería de melamínico en vestidores	240.00
88	3	HORCÓN DE CUCHI 7X7	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Horcón de cuchi 7x7	937.50
91	4	MACHIMBRE DE TAJIBO PARA PISO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Machimbre de tajibo para piso	240.80
66	3	LAVARROPA DE PORCELANA BLANCA CON PEDESTAL	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Lavarropa de porcelana blanca con pedestal	715.95
78	4	VENTANA DE CARPINTERIA DE ALUMINIO CON VIDRIO DE 4MM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Ventana de carpinteria de aluminio con vidrio de 4mm	450.63
71	4	RECEPTÁCULO PARA DUCHA 90X90 DE FIBRA DE VIDRIO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Receptáculo para ducha 90x90 de fibra de vidrio	148.40
69	3	PERCHERO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Perchero	91.23
65	3	LAVARROPA DE CEMENTO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Lavarropa de cemento	593.65
79	4	VENTANAS BASCULANTE DE ALUMINIO CON VIDRIO DOBLE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Ventanas basculante de aluminio con vidrio doble	451.20
72	4	TINA DE FIBRA DE VIDRIO 1.60X0.95	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tina de fibra de vidrio 1.60x0.95	307.25
74	3	TOALLERO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Toallero	91.23
107	4	PUERTA VITRAL	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Puerta vitral	286.04
110	4	PUERTAS INTERIORES TIPO PLACA EN MADERA 0.90 M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Puertas interiores tipo placa en madera 0.90 m	1135.00
127	3	CHURRASQUERA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Churrasquera	949.90
106	4	PUERTA TABLERO MARCO SENCILLO, QUINCALLERÍA Y BARNIZADO 0.90X2.10	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Puerta tablero marco sencillo, quincallería y barnizado 0.90x2.10	1864.01
97	3	MUEBLE BAJO MESÓN DE COCINA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Mueble bajo mesón de cocina	714.25
114	4	TAPAJUNTA DE MADERA EN PUERTAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tapajunta de madera en puertas	20.95
111	4	PUERTAS PLEGABLES DE MELAMÍNICO PARA ROPERO EMPOTRADO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Puertas plegables de melamínico para ropero empotrado	335.75
116	4	VENTANA SENCILLA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Ventana sencilla	89.00
117	4	VENTANA SENCILLA MADERA CON QUINCALLERÍA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Ventana sencilla madera con quincallería	123.25
105	4	PUERTA DE INGRESO PRINCIPAL DE MADERA MACIZA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Puerta de ingreso principal de madera maciza	196.00
109	4	PUERTAS INTERIORES TIPO PLACA EN MADERA 0.80 M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Puertas interiores tipo placa en madera 0.80 m	1095.00
81	4	COLUMNA CIRCULAR DE MADERA LABRADA (8" 3.00M)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Columna circular de madera labrada (8" 3.00m)	63.50
89	4	HUMBRAL DE MADERA TAJIBO DE 3X12	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Humbral de madera tajibo de 3x12	92.94
80	4	BARANDA DE MADERA PARA BALCON H=0.90M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Baranda de madera para balcon h=0.90m	292.40
84	4	COLUMNA DE MADERA 8X8 PLG. 3.00 M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Columna de madera 8x8 plg. 3.00 m	84.50
82	4	COLUMNA DE MADERA 10X10 PLG. 3.00	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Columna de madera 10x10 plg. 3.00	84.50
83	4	COLUMNA DE MADERA 6X6 PULG. 3.00 M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Columna de madera 6x6 pulg. 3.00 m	636.00
115	4	VENTANA MARCO SENCILLO, QUINCALLERÍA, BARNIZADO Y VIDRIO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Ventana marco sencillo, quincallería, barnizado y vidrio	677.52
108	4	PUERTAS INTERIORES TIPO PLACA EN MADERA 0.70 M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Puertas interiores tipo placa en madera 0.70 m	1035.00
98	3	MUEBLE DE ESTANTERIA PARA COCINA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Mueble de estanteria para cocina	714.25
118	4	VENTANA SENCILLA PARA BAÑO CON QUINCALLERÍA Y VIDRIO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Ventana sencilla para baño con quincallería y vidrio	167.04
126	3	BARROTES DE PROTECCIÓN DE FE 3/4	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Barrotes de protección de Fe 3/4	52.43
162	3	CUBIERTA DE TEJA  FBC	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de teja  FBC	163.25
140	3	POSTE DE HORMIGÓN PREFABRICADO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Poste de hormigón prefabricado	130.72
159	3	CUBIERTA DE JATATA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de Jatata	254.10
147	3	VERJA SENCILLA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Verja sencilla	450.00
130	3	PARRILLA PARA CHURRASQUERA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Parrilla para churrasquera	949.90
135	3	REJA DE PROTECCIÓN METÁLICA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Reja de protección metálica	389.38
161	3	CUBIERTA DE TEJA  DURALIT CANALIT	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de teja  Duralit Canalit	110.60
155	4	CIELO RASO ESTUCADO BAJO TIJERAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cielo raso estucado bajo tijeras	90.06
152	4	CIELO FALSO PLASTOFORM CON PERFILES DE ALUMNIO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cielo falso plastoform con perfiles de alumnio	195.00
145	4	VERJA DE TUBÍN CUADRADO 20MM Y 20MM C/PINTURA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Verja de tubín cuadrado 20mm y 20mm c/pintura	298.75
146	4	VERJA DE TUBIN CUADRADO 50MM Y 30MM C/PINTURA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Verja de tubin cuadrado 50mm y 30mm c/pintura	388.75
132	4	PUERTA METALICA ARROLLABLE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Puerta metalica arrollable	538.75
151	4	CIELO FALSO DE YESO APRENSADO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cielo falso de yeso aprensado	168.00
134	3	REJA DE PROTECCIÓN DE FIERRO Ø1/2	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Reja de protección de fierro ø1/2	79.98
158	3	CUBIERTA DE FIBROCEMENTO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de fibrocemento	75.63
157	3	CUBIERTA DE CALAMINA N28	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de calamina N28	124.06
136	3	VERJA METALICA C/TUBOS CUADRADOS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Verja metalica c/tubos cuadrados	663.00
150	4	CIELO FALSO DE ESTUCO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cielo falso de estuco	166.59
112	4	ROPERO EMPOTRADO DE MADERA (CON CAJONERÍA)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Ropero empotrado de madera (con cajonería)	885.00
124	4	VIGA DE MADERA TAJIBO 8X8 CEPILLADA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Viga de madera tajibo 8x8 cepillada	542.50
95	4	MARCO 2X4 TAJIBO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Marco 2x4 tajibo	81.79
154	4	CIELO RASO ESTUCADO BAJO LOSA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cielo raso estucado bajo losa	75.34
178	1	DESMONTAJE DE CUBIERTA TEJA PLANA FBC	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Desmontaje de cubierta teja plana FBC	12.50
184	1	RETIRO DE PUERTAS Y VENTANAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Retiro de puertas y ventanas	1.25
190	3	CARPETA DE HO PO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Carpeta de Ho Po	1668.25
176	1	DEMOLICION MURO DE LADRILLO E=15CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Demolicion muro de ladrillo e=15cm	5.94
197	3	CORDÓN DE ACERA PREFABRICADO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cordón de acera prefabricado	100.47
189	3	CABEZAL DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cabezal de Ho Ao	6509.75
196	4	CONTRAPISO DE HO SO DOSIF. 1:3:4	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Contrapiso de Ho So Dosif. 1:3:4	2142.75
171	3	CUMBRERA DE TEJA  FIBROCEMENTO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cumbrera de teja  fibrocemento	67.05
179	4	REMOCIÓN DE CONTRAPISO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Remoción de contrapiso	4.69
175	1	DEMOLICIÓN MURO DE CORDÓN	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Demolición muro de cordón	5.94
199	3	DINTEL DE HOAO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Dintel de HoAo	4119.50
166	3	CUBIERTA DE TEJA COLONIAL	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de teja colonial	142.33
193	3	CIMIENTO DE HO CO DOSIF. 1:2:3 50% PIEDRA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cimiento de Ho Co Dosif. 1:2:3 50% piedra	1483.90
192	3	CIMIENTO DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cimiento de Ho Ao	5038.45
198	3	CORDON DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cordon de Ho Ao	4910.95
165	3	CUBIERTA DE TEJA  FIBROCEMENTO SOBRE CERCHA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de teja  fibrocemento sobre cercha	229.27
167	3	CUBIERTA DE TEJA COLONIAL CON CERCHA METÁLICA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de teja colonial con cercha metálica	276.90
194	3	CIMIENTO DE HO CO DOSIF. 1:2:4 40% PIEDRA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cimiento de Ho Co Dosif. 1:2:4 40% piedra	1417.88
191	3	CARPETA DE HO PO E=4 CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Carpeta de Ho Po e=4 cm	70.80
185	1	RETIRO DE VERJA METÁLICA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Retiro de verja metálica	6.25
234	3	ZAPATA DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Zapata de Ho Ao	5038.45
236	3	IMPERMEABILIZACIÓN DE CIMIENTO  B=0.15M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Impermeabilización de cimiento  b=0.15m	18.40
226	3	TANQUE ELEVADO DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tanque elevado de Ho Ao	8310.83
210	3	LOSA DE VIGUETA PRETENSADA COMPL. #16 (PREMEZCLADO)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Losa de vigueta pretensada compl. #16 (premezclado)	1267.61
204	3	LOSA CASETONADA 50X50X30X10X5	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Losa casetonada 50x50x30x10x5	2289.62
220	3	RAMPA DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Rampa de Ho Ao	6486.95
219	4	PISO DE HORMIGÓN	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de Hormigón	1955.48
141	4	POSTE DE MADERA CUCHI 4X4  3M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Poste de madera cuchi 4x4  3m	210.00
170	4	CUBIERTA DE TEJA COLONIAL SOBRE CERCHAS DE MADERA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de teja colonial sobre cerchas de madera	295.88
187	5	CANALETA DE CALAMINA PLANA NO28 DE 12X14CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Canaleta de calamina plana No28 de 12x14cm	85.00
188	5	CANALETA MEDIA LUNA DE CALAMINA PLANA NO28	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Canaleta media luna de calamina plana No28	94.00
186	5	BAJANTE DE CALAMINA PLANA NO28 DE 10X15CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Bajante de calamina plana No28 de 10x15cm	105.00
177	3	DESCASCARADO REVOQUE INTERIOR Y EXTERIOR	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Descascarado revoque interior y exterior	4.69
222	3	SOBRECIMIENTO DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Sobrecimiento de Ho Ao	4238.20
237	3	IMPERMEABILIZACIÓN DE CIMIENTO  B=0.30M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Impermeabilización de cimiento  b=0.30m	33.56
235	3	CAPA AISLADORA VERTICAL	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Capa aisladora vertical	83.70
214	3	PARAPETO DE HO AO (PREMEZCLADO)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Parapeto de Ho Ao (premezclado)	7319.03
202	3	JARDINERA DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Jardinera de Ho Ao	6869.03
212	3	MURO DE CONTENCIÓN DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro de contención de Ho Ao	10201.55
209	3	LOSA DE VIGUETA PRETENSADA COMPL. #16	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Losa de vigueta pretensada compl. #16	1373.77
225	3	TANQUE CISTERNA DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tanque cisterna de Ho Ao	8310.83
205	3	LOSA DE FUNDACIÓN DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Losa de fundación de Ho Ao	5148.95
216	4	PISO DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de Ho Ao	6199.03
223	3	SOBRECIMIENTO DE HO CO 1:2:3 60% PIEDRA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Sobrecimiento de Ho Co 1:2:3 60% piedra	4312.35
221	3	RAMPA DE HO AO (PREMEZCLADO)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Rampa de Ho Ao (premezclado)	5503.35
207	3	LOSA DE VIGUETA PRETENSADA COMPL. #12	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Losa de vigueta pretensada compl. #12	1059.13
206	3	LOSA DE VIGUETA PRETENSADA COMPL. #10	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Losa de vigueta pretensada compl. #10	1348.77
224	3	SOBRECIMIENTO DE HO CO 1:3:5 50% PIEDRA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Sobrecimiento de Ho Co 1:3:5 50% piedra	4291.35
218	4	PISO DE HO AO ESP=7 CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de Ho Ao esp=7 cm	102.85
211	3	LOSA MACIZA DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Losa maciza de Ho Ao	5148.95
215	3	PISCINA DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piscina de Ho Ao	10201.55
239	3	IMPERMEABILIZACION DE LOSA CON MEMBRANA ASFÁLTICA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Impermeabilizacion de losa con membrana asfáltica	64.94
258	3	DISYUNTOR TRIFÁSICO DE 30 A.	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Disyuntor trifásico de 30 A.	194.50
257	3	DISYUNTOR TRIFÁSICO DE 150 A.	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Disyuntor trifásico de 150 A.	407.30
240	3	IMPERMEABILIZACION DE LOSAS CON RECUPLAST	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Impermeabilizacion de losas con Recuplast	78.97
266	2	PUESTA A TIERRA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Puesta a tierra	272.00
250	3	CONMUTADOR SIMPLE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Conmutador simple	336.13
230	4	VIGA DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Viga de Ho Ao	7634.20
228	4	VIGA DE ENCADENADO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Viga de encadenado	5834.00
229	4	VIGA DE EQUILIBRIO DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Viga de equilibrio de Ho Ao	7677.20
232	4	VIGA PORTAMURO DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Viga portamuro de Ho Ao	4341.95
243	6	APLIQUE 100 W	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Aplique 100 W	314.70
263	6	PILASTRA HOAO PARA MEDIDOR MONOFÁSICO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pilastra HoAo para medidor monofásico	819.54
251	6	DISYUNTOR DE 10A	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Disyuntor de 10A	22.00
252	6	DISYUNTOR DE 15A	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Disyuntor de 15A	22.00
253	6	DISYUNTOR DE 20A	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Disyuntor de 20A	27.00
254	6	DISYUNTOR DE 25A	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Disyuntor de 25A	48.00
256	6	DISYUNTOR DE 40A	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Disyuntor de 40A	32.00
259	6	DISYUNTOR TRIFÁSICO DE 60 A.	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Disyuntor trifásico de 60 A.	212.40
262	3	JABALINA P/ ATERRAMIENTO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Jabalina P/ Aterramiento	170.70
238	3	IMPERMEABILIZACION DE JARDINERAS CON RECUPLAST	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Impermeabilizacion de jardineras con Recuplast	78.97
249	3	CONMUTADOR DOBLE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Conmutador doble	354.13
290	3	GRIFO DE 1/2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Grifo de 1/2"	114.00
299	3	LLAVE DE PASO DE BRONCE 2 "	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Llave de paso de bronce 2 "	339.00
291	3	GRIFO DE RIEGO DE 1"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Grifo de riego de 1"	125.06
302	3	TENDIDO DE CANERIA DE FO GO DE 1 1/2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de caneria de Fo Go de 1 1/2"	73.55
311	3	TENDIDO DE CAÑERÍA DE PVC DE 3/4"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de cañería de PVC de 3/4"	30.54
279	5	PUNTO PARA TELEFONO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto para telefono	179.25
277	5	PUNTO PARA INTERCOMUNICADOR	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto para intercomunicador	202.25
310	3	TENDIDO DE CAÑERÍA DE PVC DE 1/2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de cañería de PVC de 1/2"	27.48
306	3	TENDIDO DE CAÑERÍA DE FO GO DE 3/4"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de cañería de Fo Go de 3/4"	48.65
294	3	LLAVE DE PASO DE  2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Llave de paso de  2"	339.00
278	5	PUNTO PARA SONIDO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto para sonido	131.65
309	3	TENDIDO DE CAÑERIA DE PVC DE 1"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de cañeria de PVC de 1"	43.65
292	5	INSTALACION DE AGUA CALIENTE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Instalacion de agua caliente	280.61
280	5	PUNTO PARA TELEVISION	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto para television	222.35
298	3	LLAVE DE PASO DE BRONCE 1"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Llave de paso de bronce 1"	139.00
283	3	TABLERO DE CONTROL INTERNO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tablero de control interno	2186.99
305	3	TENDIDO DE CANERIA DE FO GO DE 3"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de caneria de Fo Go de 3"	140.70
297	3	LLAVE DE PASO DE BRONCE 1 1/2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Llave de paso de bronce 1 1/2"	252.00
303	3	TENDIDO DE CAÑERÍA DE FO GO DE 1"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de cañería de Fo Go de 1"	65.05
285	3	TABLERO DE DISTRIBUCION SECUNDARIO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tablero de distribucion secundario	291.47
301	5	TENDIDO DE CAÑERÍA DE AGUA CALIENTE DE 1/2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de cañería de agua caliente de 1/2"	28.98
304	3	TENDIDO DE CAÑERIA DE FO GO DE 2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de cañeria de Fo Go de 2"	84.60
296	3	LLAVE DE PASO DE 1/2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Llave de paso de 1/2"	72.00
295	3	LLAVE DE PASO DE 1 1/2 PULG	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Llave de paso de 1 1/2 pulg	252.00
300	3	LLAVE DE PASO DE BRONCE 3/4"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Llave de paso de bronce 3/4"	89.00
284	3	TABLERO DE DISTRIBUCION PRINCIPAL	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tablero de distribucion principal	391.47
308	3	TENDIDO DE CAÑERÍA DE HIDRO3 DE 3/4"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de cañería de HIDRO3 de 3/4"	31.76
293	5	INSTALACION DE AGUA FRÍA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Instalacion de agua fría	129.27
341	3	COLOCACIÓN DE GRAMA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Colocación de grama	68.25
247	6	CAJA METÁLICA PARA MEDIDOR CON BASTÓN GO 3/4	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Caja metálica para medidor con bastón Go 3/4	181.80
255	6	DISYUNTOR DE 32A	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Disyuntor de 32A	32.00
282	6	PUNTO PARARRAYO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto pararrayo	2559.80
328	3	TENDIDO DE TUBO CERÁMICO DE 6"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de tubo cerámico de 6"	76.81
345	5	BOTAGUA DE LADRILLO ADOBITO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Botagua de ladrillo adobito	23.85
347	3	CIMIENTO DE LADRILLO ADOBITO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cimiento de ladrillo adobito	2123.50
321	3	CÁMARA DE REGISTRO DE 25X25 CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cámara de registro de 25x25 cm	311.04
343	3	COLOCACIÓN PLANTAS ORNAMENTALES EN JARDINERAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Colocación plantas ornamentales en jardineras	118.64
327	4	REJILLA DE PISO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Rejilla de piso	107.50
339	3	TUBO DE VENTILACIÓN DE PVC DE 2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tubo de ventilación de PVC de 2"	34.21
344	2	RELLENO DE TIERRA NEGRA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Relleno de tierra negra	154.00
319	3	CÁMARA DE INSPECCIÓN DE 40X40 CON REJILLA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cámara de inspección de 40x40 con rejilla	628.50
346	4	CERRAMIENTO CON CELOSÍA CERAMICA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cerramiento con celosía ceramica	94.54
322	3	CÁMARA DE REGISTRO DE 40X40 CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cámara de registro de 40x40 cm	515.15
323	3	CÁMARA DESGRASADORA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cámara desgrasadora	74.00
348	3	CIMIENTO DE LADRILLO ADOBITO 35CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cimiento de ladrillo adobito 35cm	731.27
337	3	TENDIDO TUBO DE PVC DE 6"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido tubo de PVC de 6"	82.74
320	3	CÁMARA DE INSPECCIÓN DE 60X60 CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cámara de inspección de 60x60 cm	644.50
329	3	TENDIDO DE TUBO DE CEMENTO DE 8"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de tubo de cemento de 8"	135.13
338	3	TUBO DE VENTILACIÓN  DE PVC DE 4 PLG	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tubo de ventilación  de PVC de 4 plg	48.51
324	3	CÁMARA SÉPTICA 1X2X1.5	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cámara séptica 1x2x1.5	3100.90
333	3	TENDIDO TUBO DE PVC DE 2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido tubo de PVC de 2"	34.21
334	3	TENDIDO TUBO DE PVC DE 3"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido tubo de PVC de 3"	41.02
312	5	TENDIDO DE CAÑERÍA DE PVC DE 3/4" AGUA CALIENTE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de cañería de PVC de 3/4" agua caliente	26.31
342	3	COLOCACIÓN DE VEGETACIÓN ORNAMENTAL EN VIVIENDAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Colocación de vegetación ornamental en viviendas	76.64
326	3	POZO ABSORVENTE (PROF. 5 M)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pozo absorvente (prof. 5 m)	1088.68
336	3	TENDIDO TUBO DE PVC DE 5"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido tubo de PVC de 5"	65.92
313	3	TENDIDO DE CAÑERÍA FO GO DE 1/2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de cañería Fo Go de 1/2"	33.35
378	3	MESON DE MÁRMOL RECONSTITUIDO 60CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Meson de mármol reconstituido 60cm	888.65
381	3	TINGLADO METALICO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tinglado metalico	350.00
351	3	CORDÓN DE LADRILLO ADOBITO H=0.28M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cordón de ladrillo adobito h=0.28m	76.60
350	3	CORDÓN DE LADRILLO ADOBITO H=0.20M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cordón de ladrillo adobito h=0.20m	73.35
364	3	MURO DE LADRILLO ADOBITO VISTO 15CM 2 CARAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro de ladrillo adobito visto 15cm 2 caras	198.66
357	3	MURO DE BLOQUE DE YESO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro de bloque de yeso	153.75
366	3	MURO DE LADRILLO CERAMICO DE 6H	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro de ladrillo ceramico de 6H	95.79
361	3	MURO DE LADRILLO ADOBITO 30CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro de ladrillo adobito 30cm	686.55
373	3	SUBMURACION DE LADRILLO, 30CM, DOSIF 1:4	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Submuracion de ladrillo, 30cm, Dosif 1:4	369.48
363	3	MURO DE LADRILLO ADOBITO VISTO 15CM 1 CARA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro de ladrillo adobito visto 15cm 1 cara	186.78
356	3	MURO CON PANEL 3D	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro con panel 3D	102.40
368	3	MURO DE LADRILLO CERAMICO DE 8H	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro de ladrillo ceramico de 8H	93.81
317	5	CAJA SIFONADA 4 PLG	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Caja sifonada 4 plg	75.00
331	5	TENDIDO TUBO DE PVC DE 1 1/2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido tubo de PVC de 1 1/2"	36.45
372	3	SOBRECIMIENTO DE LADRILLO ADOBITO 30CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Sobrecimiento de ladrillo adobito 30cm	672.10
383	2	EXCAVACIÓN HASTA 2.00M (RETRO)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Excavación hasta 2.00m (retro)	80.38
359	3	MURO DE BLOQUES DE CONCRETO CELOCÍA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro de bloques de concreto celocía	144.00
370	3	MURO VISTO LADRILLO CERAMICO 21 HUECOS 0.30	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro visto ladrillo ceramico 21 Huecos 0.30	567.64
382	2	EXCAVACION CON RETROEXCAVADORA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Excavacion con retroexcavadora	16.10
379	3	MESONES DE GRANITO (60CM)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Mesones de granito (60cm)	909.15
376	4	MESON DE HO AO REV. CON CERAMICA PICADA 0.10X0.60	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Meson de Ho Ao rev. con ceramica picada 0.10x0.60	1459.50
353	3	CORDÓN DE LADRILLO ADOBITO H=0.40M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cordón de ladrillo adobito h=0.40m	72.81
352	3	CORDÓN DE LADRILLO ADOBITO H=0.35M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cordón de ladrillo adobito h=0.35m	79.85
362	3	MURO DE LADRILLO ADOBITO 8CM (PANDERETA)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro de ladrillo adobito 8cm (pandereta)	127.67
360	3	MURO DE LADRILLO ADOBITO 15CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro de ladrillo adobito 15cm	182.00
371	3	SOBRECIMIENTO DE LADRILLO ADOBITO 15CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Sobrecimiento de ladrillo adobito 15cm	184.39
367	3	MURO DE LADRILLO CERAMICO DE 6H (30 CM)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro de ladrillo ceramico de 6H (30 cm)	139.45
365	3	MURO DE LADRILLO ADOBITO VISTO 30CM 1 CARA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro de ladrillo adobito visto 30cm 1 cara	373.57
354	3	CORDÓN DE LADRILLO ADOBITO VISTO 30CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cordón de ladrillo adobito visto 30cm	289.98
420	4	PISO DE CERÁMICA ESMALTADA (30X30)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de cerámica esmaltada (30x30)	150.06
388	3	INSTALACIÓN DE OBRADOR	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Instalación de obrador	200.00
408	4	PINTURA LATEX EN MURO DE LADRILLO VISTO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pintura latex en muro de ladrillo visto	51.41
391	2	RELLENO DE ARENA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Relleno de arena	373.88
419	4	PISO DE CEMENTO PLANCHADO CON OCRE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de cemento planchado con ocre	75.49
400	4	PINTURA AL ÓLEO COM IMPRIMACIÓN	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pintura al óleo com imprimación	38.75
398	4	PINTURA ACRÍLICA SOBRE CUBIERTA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pintura acrílica sobre cubierta	28.23
389	3	LETRERO DE OBRA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Letrero de obra	281.25
417	4	PISO DE CEMENTO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de cemento	49.25
395	3	REPLANTEO DE FUNDACIONES	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Replanteo de fundaciones	8.90
401	4	PINTURA ANTICORROSIVA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pintura anticorrosiva	21.57
404	4	PINTURA LATEX EN CIELO RASO BAJO LOSA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pintura latex en cielo raso bajo losa	37.86
392	2	RELLENO Y COMPACTACION MANUAL C/MATERIAL	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Relleno y compactacion manual c/material	358.38
409	4	PINTURA LATEX EN MUROS (INTERIORES)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pintura latex en muros (interiores)	42.61
421	4	PISO DE CERAMICA ESMALTADA (40X40CM)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso De Ceramica Esmaltada (40x40cm)	113.50
410	4	PINTURA LATEX MUROS INTERIORES	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pintura latex muros interiores	35.52
399	4	PINTURA AL OLEO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pintura al oleo	33.46
414	4	CONTRAPISO DE PIEDRA E=10CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Contrapiso de piedra e=10cm	159.93
390	1	LIMPIEZA DE TERRENO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Limpieza de terreno	303.88
407	4	PINTURA LATEX EN CUBIERTA INT.	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pintura latex en cubierta int.	32.23
412	4	CONTRAPISO DE MORTERO ESP=5CM DOSIF 1:6	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Contrapiso de mortero esp=5cm dosif 1:6	124.40
411	4	CONTRAPISO DE LADRILLO ADOBITO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Contrapiso de ladrillo adobito	170.97
377	4	MESÓN DE MADERA MARA (60CM)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Mesón de madera mara (60cm)	407.50
380	4	DIVISIONES DE REJILLA METÁLICA PARA ROPEROS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Divisiones de rejilla metálica para roperos	426.00
416	4	PISO DE ALFOMBRA DE ALTO TRÁFICO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de alfombra de alto tráfico	81.72
403	4	PINTURA LATEX EN CIELO RASO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pintura latex en cielo raso	32.23
385	2	EXCAVACION MANUAL	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Excavacion manual	31.25
394	3	REPLANTEO DE FUNDACIONE CON TEODOLITO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Replanteo de fundacione con teodolito	25.61
406	4	PINTURA LATEX EN CUBIERTA EXT.	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pintura latex en cubierta ext.	43.34
402	4	PINTURA DE PUERTAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pintura de Puertas	39.76
415	4	PISO CERAMICO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso ceramico	118.81
418	4	PISO DE CEMENTO PLANCHADO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de cemento planchado	62.68
387	3	PLACA DE ENTREGA DE OBRA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Placa de entrega de obra	503.40
393	2	RELLENO Y COMPACTACION MANUAL S/MATERIAL	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Relleno y compactacion manual s/material	272.19
433	4	PISO DE PIEDRA LAJA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de piedra laja	234.20
424	4	PISO DE CERÁMICA GRES 15 X 15 CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de cerámica gres 15 x 15 cm	168.20
434	4	PISO DE PIEDRA PEQUEÑA CON RECUADROS DE CERÁMICA ROJA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de piedra pequeña con recuadros de cerámica roja	162.25
460	3	REBORDE DE CEMENTO 5 CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Reborde de cemento 5 cm	7.66
426	4	PISO DE CERÁMICA ROJA NATURAL	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de cerámica roja natural	135.48
455	5	BOTAGUAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Botaguas	32.21
436	4	PISO PORCELANATO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso porcelanato	256.23
449	4	CHAPA PARA PUERTA DE BAÑO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Chapa para puerta de baño	309.07
431	4	PISO DE MOSAICO GRANITICO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de mosaico granitico	217.78
437	4	PISO PREFABRICADO DE BALDOSA TIPO REJILLA DE CONCRETO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso prefabricado de baldosa tipo rejilla de concreto	154.95
454	4	PICAPORTE PARA VENTANA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Picaporte para ventana	13.50
451	4	CHAPA PARA PUERTA INTERIOR	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Chapa para puerta interior	275.87
457	3	CASTIGADO DE CEMENTO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Castigado de cemento	7.66
448	4	CHAPA EN PUERTA EXTERIOR (SERVICIO)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Chapa en puerta exterior (servicio)	311.20
435	4	PISO DE TAPIZON	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de tapizon	96.81
447	3	BISAGRA DE 4 PLG	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Bisagra de 4 plg	40.00
456	3	BUÑA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Buña	8.84
427	4	PISO DE LADRILLO COMUN	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de ladrillo comun	125.90
446	3	BISAGRA DE 3 PLG	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Bisagra de 3 plg	27.00
458	4	FILO DE REVOQUE	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Filo de revoque	19.84
428	4	PISO DE LOSETA DE HO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de loseta de Ho	134.28
432	4	PISO DE PARKET	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de parket	199.00
450	4	CHAPA PARA PUERTA EXTERIOR	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Chapa para puerta exterior	470.75
430	4	PISO DE MOSAICO COMUN	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de mosaico comun	147.25
459	3	REBAJE EN MUROS (BUÑAS) 1 X 1 CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Rebaje en muros (buñas) 1 x 1 cm	10.21
423	4	PISO DE CERÁMICA EXTERIOR	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de cerámica exterior	161.56
429	4	PISO DE MORTERO PLANCHADO SOBRE LOSA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de mortero planchado sobre losa	70.49
482	4	VIDRIO BLINDEX	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Vidrio blindex	500.00
464	4	REVESTIMIENTO DE AZULEJO BLANCO 15X15	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Revestimiento de azulejo blanco 15x15	116.60
444	7	ZÓCALO DE TAPIZÓN	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Zócalo de tapizón	23.72
470	4	REVOQUE DE ESTUCO CON MULTIMASA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Revoque de estuco con multimasa	75.34
70	4	RECEPTÁCULO PARA DUCHA 80X80 DE FIBRA DE VIDRIO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Receptáculo para ducha 80x80 de fibra de vidrio	997.40
173	4	FILO DE ALERO EN CIELO RASO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Filo de alero en cielo raso	17.21
131	4	PROTECTOR DE VENTANA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Protector de ventana	433.30
478	4	COLOCACIÓN DE ESPEJO 8MM PARA BAÑO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Colocación de espejo 8mm para baño	176.83
330	5	TENDIDO DE TUBO DE VENTILACIÓN SANITARIA DE PVC DE 4 "	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de tubo de ventilación sanitaria de PVC de 4 "	48.51
471	4	REVOQUE EXTERIOR PIRULEADO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Revoque exterior piruleado	60.31
483	4	VIDRIO BLINDEX PARA BOX DE BAÑO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Vidrio blindex para box de baño	500.00
477	4	COLOCACIÓN DE ESPEJO 3MM PARA BAÑO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Colocación de espejo 3mm para baño	103.87
462	3	REVESTIMIENTO CON LADRILLO REFRACTARIO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Revestimiento con ladrillo refractario	302.63
475	4	ZÓCALO DE CERAMICA GRES	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Zócalo de ceramica gres	47.42
103	4	PISO DE MADERA SOBRE ESTRUCTURA DE MADERA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de madera sobre estructura de madera	303.30
468	3	REVESTIMIENTO DE MURO CON PIEDRA LISTON	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Revestimiento de muro con piedra liston	190.95
466	3	REVESTIMIENTO DE LADRILLO VISTO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Revestimiento de ladrillo visto	186.73
472	4	REVOQUE FINO INTERIOR	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Revoque fino interior	49.85
467	3	REVESTIMIENTO DE MURO CON PIEDRA LAJA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Revestimiento de muro con piedra laja	266.25
133	4	PUERTA METÁLICA TIPO REJA CON CHAPA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Puerta metálica tipo reja con chapa	1251.38
485	4	VIDRIO DOBLE PROVISIÓN Y COLOCACIÓN	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Vidrio doble provisión y colocación	105.95
200	4	EMPEDRADO Y CONTRAPISO DE HORMIGÓN	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Empedrado y contrapiso de hormigón	137.78
480	4	VIDRIO 4MM PROVISIÓN Y COLOCACIÓN	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Vidrio 4mm provisión y colocación	119.38
325	5	INSTALACION SANITARIA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Instalacion sanitaria	148.68
484	4	VIDRIO CATEDRAL PROVISION Y COLOCACION	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Vidrio catedral provision y colocacion	127.75
275	5	PUNTO PARA AIRE ACONDICIONADO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Punto para aire acondicionado	100.50
479	4	DOMUS DE ALUMINIO Y VIDRIO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Domus de aluminio y vidrio	1.00
465	4	REVESTIMIENTO DE AZULEJO DECORADO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Revestimiento de azulejo decorado	140.75
384	2	EXCAVACION HASTA 2.00M (RETRO)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Excavacion hasta 2.00m (retro)	80.38
386	1	LIMPIEZA Y RETIRO DE ESCOMBROS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Limpieza y retiro de escombros	303.88
461	4	REVESTIMIENTO CON CERAMICA ESMALTADA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Revestimiento con ceramica esmaltada	125.90
307	3	TENDIDO DE CAÑERÍA DE HIDRO3 DE 1/2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido de cañería de HIDRO3 de 1/2"	28.30
369	3	MURO VISTO LADRILLO CERAMICO 21 HUECOS 0.15	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro visto ladrillo ceramico 21 Huecos 0.15	338.35
217	4	PISO DE HO AO ESP=10 CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de Ho Ao esp=10 cm	135.33
481	4	VIDRIO ACANALADO PROVISIÓN Y COLOCACIÓN	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Vidrio acanalado provisión y colocación	8.29
405	4	PINTURA LATEX EN CIELO RASO BAJO TIJERA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pintura latex en cielo raso bajo tijera	29.72
375	4	MESON DE HO AO CON AZULEJO BLANCO 0.10X0.60	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Meson de Ho Ao con azulejo blanco 0.10x0.60	1487.20
452	4	JALADORES DE PUERTAS Y VENTANAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Jaladores de puertas y ventanas	20.00
34	4	BAÑERA DE HIDROMASAJE DE FIBRA DE VIDRIO 1.80X0.95	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Bañera de hidromasaje de fibra de vidrio 1.80x0.95	369.00
474	7	ZÓCALO DE CERÁMICA ESPAÑOLA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Zócalo de cerámica española	35.73
169	4	CUBIERTA DE TEJA COLONIAL CON VIGA VISTA 3X6	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de teja colonial con viga vista 3x6	436.16
119	4	VIGA DE MADERA TAJIBO 3X7 CEPILLADA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Viga de madera tajibo 3x7 cepillada	112.50
90	4	MACHIMBRE DE TAJIBO PARA CIELO RASO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Machimbre de tajibo para cielo raso	225.80
144	3	VALLA DE PROTECCIÓN CON 3 HEBRAS DE ALAMBRE DE PÚAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Valla de protección con 3 hebras de alambre de púas	41.87
208	3	LOSA DE VIGUETA PRETENSADA COMPL. #12 (PREMEZCLADO)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Losa de vigueta pretensada compl. #12 (premezclado)	1300.61
425	4	PISO DE CERÁMICA ROJA NACIONAL (15X15 CM)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de cerámica roja nacional (15x15 cm)	66.88
332	3	TENDIDO TUBO DE PVC DE 2 1/2"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Tendido tubo de PVC de 2 1/2"	36.45
422	4	PISO DE CERÁMICA ESPAÑOLA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Piso de cerámica española	277.81
35	5	BIDÉ BLANCO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Bidé blanco	528.00
52	5	INODORO DE COLOR TANQUE BAJO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Inodoro de color tanque bajo	127.30
44	5	GRIFERÍA DE LAVAMANOS CON MEZCLADODRA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Grifería de lavamanos con mezcladodra	304.30
39	5	DUCHA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Ducha	183.90
61	5	LAVAPLATOS DE 1 BACHA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Lavaplatos de 1 bacha	394.30
75	5	URINARIO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Urinario	517.20
60	5	LAVAMANOS EN MESÓN	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Lavamanos en mesón	528.05
59	5	LAVAMANOS DE COLOR (SIN PEDESTAL)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Lavamanos de color (sin pedestal)	549.30
67	5	PAPELERO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Papelero	99.88
63	5	LAVAPLATOS DE 2 BACHAS 1 ESCURRIDERO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Lavaplatos de 2 bachas 1 escurridero	469.95
64	5	LAVAPLATOS DE 2 BACHAS 2 ESCURRIDERAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Lavaplatos de 2 bachas 2 escurrideras	759.80
99	5	MUEBLES FIJOS BAJO MESONES DE BAÑOS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muebles fijos bajo mesones de baños	714.25
142	5	POSTE DE TUBERÍA DE FOGO DE 2" H=3.0M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Poste de tubería de FoGo de 2" h=3.0m	223.54
143	5	POSTE DE TUBERÍA DE FOGO DE 3" H=3.0M	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Poste de tubería de FoGo de 3" h=3.0m	223.54
57	5	LAVAMANOS BLANCO (SIN PEDESTAL)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Lavamanos blanco (sin pedestal)	512.05
183	5	REMOSIÓN DE INSTALACIÓN EXISTENTE (TUBERÍA Y CÁMARAS)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Remosión de instalación existente (tubería y cámaras)	5.94
172	7	CUMBRERA DE TEJA CERÁMICA COLONIAL	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cumbrera de teja cerámica colonial	26.29
174	7	MOLDURA DE ESTUCO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Moldura de estuco	125.25
355	7	MURO CELOCÍA CERÁMICA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Muro celocía cerámica	143.63
374	7	MESON DE HO AO 0.10X0.60 CON REVESTIMIENTO DE CERÁMICA ESMALTADA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Meson de Ho Ao 0.10x0.60 con revestimiento de cerámica esmaltada	1517.20
396	7	BARNIZADO DE MADERA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Barnizado de madera	11.75
397	7	BARNIZADO DE TIJERAS	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Barnizado de tijeras	19.90
438	7	ZÓCALO CALCÁREO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Zócalo calcáreo	49.57
443	7	ZÓCALO DE PORCELANATO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Zócalo de porcelanato	59.20
440	7	ZÓCALO DE CERÁMICA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Zócalo de cerámica	35.05
441	7	ZÓCALO DE CERÁMICA ROJA NATURAL	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Zócalo de cerámica roja natural	41.13
445	7	ZÓCALO GRANÍTICO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Zócalo granítico	67.63
439	7	ZÓCALO DE CEMENTO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Zócalo de cemento	10.03
473	7	ZÓCALO DE CERÁMICA ESMALTADA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Zócalo de cerámica esmaltada	34.45
476	7	ZÓCALO DE MADERA DE 3"  (ROBLE)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Zócalo de madera de 3"  (roble)	28.02
93	4	MALLA MILIMÉTRICA CON MARCO DE MADERA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Malla milimétrica con marco de madera	32.66
101	4	PELDAÑO DE MADERA 2X12	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Peldaño de madera 2x12	72.75
123	4	VIGA DE MADERA TAJIBO 6X8 CEPILLADA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Viga de madera tajibo 6x8 cepillada	274.41
121	4	VIGA DE MADERA TAJIBO 4X8 CEPILLADA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Viga de madera tajibo 4x8 cepillada	12.50
125	4	BARANDA DE TUBO METÁLICO H=90CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Baranda de tubo metálico h=90cm	372.95
264	6	PILASTRA PREFABRICADA PARA MEDIDOR MONOFÁSICO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pilastra prefabricada para medidor monofásico	667.00
113	4	ROPERO EMPOTRADO DE MADERA (SIN CAJONERÍA)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Ropero empotrado de madera (sin cajonería)	335.00
120	4	VIGA DE MADERA TAJIBO 3X8 CEPILLADA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Viga de madera tajibo 3x8 cepillada	147.50
104	4	PORTÓN DE MADERA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Portón de madera	635.20
96	4	MARCO CAJON 2"X6"	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Marco cajon 2"x6"	103.70
102	4	PERGOLADO MADERA 2X4 CADA 80 CM	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pergolado madera 2x4 cada 80 cm	118.75
100	4	PASAMANOS DE MADERA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Pasamanos de madera	204.26
122	4	VIGA DE MADERA TAJIBO 6X6 CEPILLADA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Viga de madera tajibo 6x6 cepillada	207.81
94	4	MARCO 2X4 MARA	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Marco 2x4 mara	94.64
138	4	COLOCACIÓN DE MALLA OLIMPICA #14	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Colocación de malla olimpica #14	66.75
128	4	ESCALERA CARACOL METÁLICA C/PELDAÑOS DE MADERA H=2.6 R=0	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Escalera caracol metálica c/peldaños de madera H=2.6 R=0	2.00
148	4	CERCHA DE MADERA ALMENDRILLO 2X4	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cercha de madera almendrillo 2x4	190.25
156	4	CUBIERTA CON DURALIT ESPAÑOLA 1.60X1.05 C/VIGA VISTA 2X4	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta con Duralit Española 1.60x1.05 c/viga vista 2x4	337.92
149	4	CERCHA DE MADERA ALMENDRILLO 2X5	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cercha de madera almendrillo 2x5	250.25
160	4	CUBIERTA DE PLACA ONDULINE CON VIGA VISTA DE 2X6	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de placa Onduline con viga vista de 2x6	230.30
163	4	CUBIERTA DE TEJA  FIBROCEMENTO CON VIGA VISTA 2X4	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de teja  fibrocemento con viga vista 2x4	209.91
139	4	COLOCACIÓN DE MALLA OLIMPICA #16	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Colocación de malla olimpica #16	77.75
137	4	COLOCACIÓN DE MALLA OLIMPICA #10	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Colocación de malla olimpica #10	63.75
181	4	REMOCION DE CUBIERTA TEJA Y MADERAMEN	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Remocion de cubierta teja y maderamen	7.50
195	4	COLUMNA DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Columna de Ho Ao	10652.05
164	4	CUBIERTA DE TEJA  FIBROCEMENTO CON VIGA VISTA 2X6	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de teja  fibrocemento con viga vista 2x6	242.80
168	4	CUBIERTA DE TEJA COLONIAL CON VIGA VISTA 2X6	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Cubierta de teja colonial con viga vista 2x6	302.90
231	4	VIGA DE HO AO (PREMEZCLADO)	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Viga de Ho Ao (premezclado)	7799.50
227	4	VIGA CANAL	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Viga canal	10132.10
201	4	ESCALERA DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Escalera de Ho Ao	10408.78
233	4	VIGAS DE ARRIOSTRE DE HO AO	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Vigas de arriostre de Ho Ao	6074.00
349	4	COLUMNA DE LADRILLO ADOBITO 30X30	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Columna de ladrillo adobito 30x30	77.13
314	5	BAJANTE DE PVC DE 3 PLG	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Bajante de PVC de 3 plg	42.52
315	5	BAJANTE DE PVC DE 4 PLG	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Bajante de PVC de 4 plg	48.51
318	5	CAJA SIFONADA 6 PLG	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Caja sifonada 6 plg	104.00
316	5	BAJANTE DE PVC DE 6 PLG	UND	Actividad importada desde APU: Análisis de precios unitarios (apu) de: Bajante de PVC de 6 plg	84.24
\.


--
-- Data for Name: activity_compositions; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.activity_compositions (id, activity_id, material_id, description, unit, quantity, unit_cost, type, created_at, updated_at, labor_id, tool_id) FROM stdin;
3130	160	\N	Cumbrera Onduline	pza	0.0200	194.56	material	2025-06-01 00:15:32.489298	2025-06-01 00:15:32.489298	\N	\N
3131	160	\N	Ayudante	hr	1.8000	12.50	labor	2025-06-01 00:15:32.506335	2025-06-01 00:15:32.506335	\N	\N
3132	160	\N	Maestro albañil	hr	1.8000	18.75	labor	2025-06-01 00:15:32.523109	2025-06-01 00:15:32.523109	\N	\N
3133	161	\N	Teja Duralit Canalit 1.00x3.50	pza	0.3200	212.80	material	2025-06-01 00:15:32.919899	2025-06-01 00:15:32.919899	\N	\N
3134	161	\N	Tirafondo 4 1/2x1/4	pza	2.0000	2.50	material	2025-06-01 00:15:32.95538	2025-06-01 00:15:32.95538	\N	\N
3135	161	\N	Ayudante	hr	1.2000	12.50	labor	2025-06-01 00:15:32.972423	2025-06-01 00:15:32.972423	\N	\N
3136	161	\N	Maestro albañil	hr	1.2000	18.75	labor	2025-06-01 00:15:32.989594	2025-06-01 00:15:32.989594	\N	\N
3137	162	24	Clavos de 3 pulg	kg	0.5000	13.00	material	2025-06-01 00:15:33.395785	2025-06-01 00:15:33.395785	\N	\N
3138	162	\N	Teja FBC	m2	1.0000	72.00	material	2025-06-01 00:15:33.43079	2025-06-01 00:15:33.43079	\N	\N
3139	162	\N	Listón de 2x2 pulg	ml	2.0000	12.00	material	2025-06-01 00:15:33.467559	2025-06-01 00:15:33.467559	\N	\N
3140	162	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:15:33.484656	2025-06-01 00:15:33.484656	\N	\N
3141	162	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:15:33.50158	2025-06-01 00:15:33.50158	\N	\N
3142	163	24	Clavos de 3 pulg	kg	0.2500	13.00	material	2025-06-01 00:15:33.887863	2025-06-01 00:15:33.887863	\N	\N
3143	163	\N	Cumbrera para teja ondulada	pza	0.0100	33.44	material	2025-06-01 00:15:33.923185	2025-06-01 00:15:33.923185	\N	\N
3144	163	\N	Teja ondulada Duralit 2.44 x 1.08	pza	0.5200	105.00	material	2025-06-01 00:15:33.958415	2025-06-01 00:15:33.958415	\N	\N
3145	163	\N	Tirafondo 4 1/2x1/4	pza	3.0000	2.50	material	2025-06-01 00:15:33.994341	2025-06-01 00:15:33.994341	\N	\N
3146	163	\N	Listón de 2x2 pulg	ml	1.0000	12.00	material	2025-06-01 00:15:34.02961	2025-06-01 00:15:34.02961	\N	\N
3147	163	\N	Viga de 2x4 pulg	ml	1.4300	45.00	material	2025-06-01 00:15:34.066413	2025-06-01 00:15:34.066413	\N	\N
3148	163	\N	Ayudante	hr	2.2000	12.50	labor	2025-06-01 00:15:34.083439	2025-06-01 00:15:34.083439	\N	\N
3149	163	\N	Maestro albañil	hr	2.2000	18.75	labor	2025-06-01 00:15:34.100721	2025-06-01 00:15:34.100721	\N	\N
3150	164	24	Clavos de 3 pulg	kg	0.2500	13.00	material	2025-06-01 00:15:34.491534	2025-06-01 00:15:34.491534	\N	\N
3151	164	\N	Cumbrera para teja ondulada	pza	0.0100	33.44	material	2025-06-01 00:15:34.526718	2025-06-01 00:15:34.526718	\N	\N
3152	164	\N	Teja ondulada Duralit 2.44 x 1.08	pza	0.5200	105.00	material	2025-06-01 00:15:34.561612	2025-06-01 00:15:34.561612	\N	\N
3153	164	\N	Tirafondo 4 1/2x1/4	pza	3.0000	2.50	material	2025-06-01 00:15:34.596238	2025-06-01 00:15:34.596238	\N	\N
3154	164	\N	Listón de 2x2 pulg	ml	1.0000	12.00	material	2025-06-01 00:15:34.630723	2025-06-01 00:15:34.630723	\N	\N
3155	164	\N	Viga de 2x6 pulg	ml	1.4300	68.00	material	2025-06-01 00:15:34.665865	2025-06-01 00:15:34.665865	\N	\N
3156	164	\N	Ayudante	hr	2.2000	12.50	labor	2025-06-01 00:15:34.684012	2025-06-01 00:15:34.684012	\N	\N
3157	164	\N	Maestro albañil	hr	2.2000	18.75	labor	2025-06-01 00:15:34.701959	2025-06-01 00:15:34.701959	\N	\N
3158	165	24	Clavos de 3 pulg	kg	0.5000	13.00	material	2025-06-01 00:15:35.112649	2025-06-01 00:15:35.112649	\N	\N
3159	165	\N	Cercha de madera de 2x4 pulg	ml	1.0000	87.92	material	2025-06-01 00:15:35.14736	2025-06-01 00:15:35.14736	\N	\N
3160	165	\N	Teja ondulada Duralit 2.44 x 1.08	pza	0.5200	105.00	material	2025-06-01 00:15:35.182586	2025-06-01 00:15:35.182586	\N	\N
3161	165	\N	Tirafondo 4 1/2x1/4	pza	3.0000	2.50	material	2025-06-01 00:15:35.217486	2025-06-01 00:15:35.217486	\N	\N
3162	165	\N	Listón de 2x2 pulg	ml	1.0000	12.00	material	2025-06-01 00:15:35.252313	2025-06-01 00:15:35.252313	\N	\N
3163	165	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:15:35.269381	2025-06-01 00:15:35.269381	\N	\N
3164	165	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:15:35.325602	2025-06-01 00:15:35.325602	\N	\N
3165	166	\N	Cemento portland IP-30	kg	1.8000	1.20	material	2025-06-01 00:15:35.733098	2025-06-01 00:15:35.733098	\N	\N
3166	166	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:15:35.767251	2025-06-01 00:15:35.767251	\N	\N
3167	166	\N	Teja colonial	pza	24.0000	2.30	material	2025-06-01 00:15:35.802007	2025-06-01 00:15:35.802007	\N	\N
3168	166	24	Clavos de 3 pulg	kg	0.6000	13.00	material	2025-06-01 00:15:35.835342	2025-06-01 00:15:35.835342	\N	\N
3169	166	\N	Listón de 2x2 pulg	ml	2.5000	12.00	material	2025-06-01 00:15:35.870732	2025-06-01 00:15:35.870732	\N	\N
3170	166	\N	Ayudante	hr	1.5000	12.50	labor	2025-06-01 00:15:35.887491	2025-06-01 00:15:35.887491	\N	\N
3171	166	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:15:35.904205	2025-06-01 00:15:35.904205	\N	\N
3172	167	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:15:36.312235	2025-06-01 00:15:36.312235	\N	\N
3173	167	\N	Arenilla	m3	0.0200	100.00	material	2025-06-01 00:15:36.346984	2025-06-01 00:15:36.346984	\N	\N
3174	167	\N	Cercha metálica	m2	1.0000	210.00	material	2025-06-01 00:15:36.381401	2025-06-01 00:15:36.381401	\N	\N
3175	167	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:15:36.398284	2025-06-01 00:15:36.398284	\N	\N
3176	167	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:15:36.415166	2025-06-01 00:15:36.415166	\N	\N
3177	168	\N	Cemento portland IP-30	kg	1.8000	1.20	material	2025-06-01 00:15:36.832151	2025-06-01 00:15:36.832151	\N	\N
3178	168	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:15:36.865324	2025-06-01 00:15:36.865324	\N	\N
3179	168	\N	Teja colonial	pza	23.0000	2.30	material	2025-06-01 00:15:36.89934	2025-06-01 00:15:36.89934	\N	\N
3180	168	24	Clavos de 3 pulg	kg	0.6000	13.00	material	2025-06-01 00:15:36.932843	2025-06-01 00:15:36.932843	\N	\N
3181	168	\N	Listón de 2x2 pulg	ml	2.5000	12.00	material	2025-06-01 00:15:36.967297	2025-06-01 00:15:36.967297	\N	\N
3182	168	\N	Viga de 2x6 pulg	ml	1.4300	68.00	material	2025-06-01 00:15:37.001581	2025-06-01 00:15:37.001581	\N	\N
3183	168	\N	Ayudante	hr	6.0000	12.50	labor	2025-06-01 00:15:37.018571	2025-06-01 00:15:37.018571	\N	\N
3184	168	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:15:37.035365	2025-06-01 00:15:37.035365	\N	\N
3185	169	\N	Cemento portland IP-30	kg	1.8000	1.20	material	2025-06-01 00:15:37.464698	2025-06-01 00:15:37.464698	\N	\N
3186	169	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:15:37.499913	2025-06-01 00:15:37.499913	\N	\N
3187	169	\N	Teja colonial	pza	23.0000	2.30	material	2025-06-01 00:15:37.546133	2025-06-01 00:15:37.546133	\N	\N
3188	169	24	Clavos de 3 pulg	kg	0.6000	13.00	material	2025-06-01 00:15:37.583821	2025-06-01 00:15:37.583821	\N	\N
3189	169	\N	Listón de 2x2 pulg	ml	2.5000	12.00	material	2025-06-01 00:15:37.61919	2025-06-01 00:15:37.61919	\N	\N
3190	169	\N	Madera 3x6 tajibo cepillada	ml	1.2500	75.00	material	2025-06-01 00:15:37.659615	2025-06-01 00:15:37.659615	\N	\N
3191	169	\N	Viga de 3x6 pulg	ml	1.4300	100.00	material	2025-06-01 00:15:37.694734	2025-06-01 00:15:37.694734	\N	\N
3192	169	\N	Ayudante	hr	5.2000	12.50	labor	2025-06-01 00:15:37.711946	2025-06-01 00:15:37.711946	\N	\N
3193	169	\N	Maestro albañil	hr	2.2000	18.75	labor	2025-06-01 00:15:37.728717	2025-06-01 00:15:37.728717	\N	\N
3194	170	\N	Cemento portland IP-30	kg	1.8000	1.20	material	2025-06-01 00:15:38.140546	2025-06-01 00:15:38.140546	\N	\N
3195	170	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:15:38.174005	2025-06-01 00:15:38.174005	\N	\N
3196	170	\N	Teja colonial	pza	24.0000	2.30	material	2025-06-01 00:15:38.207768	2025-06-01 00:15:38.207768	\N	\N
3197	170	24	Clavos de 3 pulg	kg	0.6000	13.00	material	2025-06-01 00:15:38.241731	2025-06-01 00:15:38.241731	\N	\N
3198	170	\N	Cercha de madera de 2x4 pulg	ml	1.0000	87.92	material	2025-06-01 00:15:38.276367	2025-06-01 00:15:38.276367	\N	\N
3199	170	\N	Listón de 2x2 pulg	ml	2.5000	12.00	material	2025-06-01 00:15:38.310613	2025-06-01 00:15:38.310613	\N	\N
3200	170	\N	Ayudante	hr	6.0000	12.50	labor	2025-06-01 00:15:38.329255	2025-06-01 00:15:38.329255	\N	\N
3201	170	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:15:38.346209	2025-06-01 00:15:38.346209	\N	\N
3202	171	\N	Cumbrera para Residencial 10 Duralit	pza	2.0000	30.40	material	2025-06-01 00:15:38.871232	2025-06-01 00:15:38.871232	\N	\N
3203	171	\N	Ayudante	hr	0.2000	12.50	labor	2025-06-01 00:15:38.887943	2025-06-01 00:15:38.887943	\N	\N
3204	171	\N	Maestro albañil	hr	0.2000	18.75	labor	2025-06-01 00:15:38.904626	2025-06-01 00:15:38.904626	\N	\N
3205	172	\N	Cemento portland IP-30	kg	0.7500	1.20	material	2025-06-01 00:15:39.410374	2025-06-01 00:15:39.410374	\N	\N
3206	172	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:15:39.444076	2025-06-01 00:15:39.444076	\N	\N
3207	172	\N	Teja colonial	pza	3.2000	2.30	material	2025-06-01 00:15:39.47922	2025-06-01 00:15:39.47922	\N	\N
3208	172	\N	Ayudante	hr	0.5000	12.50	labor	2025-06-01 00:15:39.496497	2025-06-01 00:15:39.496497	\N	\N
3209	172	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:15:39.513463	2025-06-01 00:15:39.513463	\N	\N
3210	173	\N	Estuco	kg	0.5000	0.75	material	2025-06-01 00:15:39.952858	2025-06-01 00:15:39.952858	\N	\N
3211	173	\N	Clavos de 1 1/2 pulg	kg	0.0900	13.00	material	2025-06-01 00:15:39.988092	2025-06-01 00:15:39.988092	\N	\N
3212	173	22	Agua	lt	0.0100	0.06	material	2025-06-01 00:15:40.021791	2025-06-01 00:15:40.021791	\N	\N
3213	173	\N	Ayudante	hr	0.5000	12.50	labor	2025-06-01 00:15:40.038625	2025-06-01 00:15:40.038625	\N	\N
3214	173	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:15:40.055695	2025-06-01 00:15:40.055695	\N	\N
3215	174	\N	Estuco	kg	30.0000	0.75	material	2025-06-01 00:15:40.444035	2025-06-01 00:15:40.444035	\N	\N
3216	174	22	Agua	lt	20.0000	0.06	material	2025-06-01 00:15:40.477614	2025-06-01 00:15:40.477614	\N	\N
3217	174	\N	Ayudante	hr	0.6000	12.50	labor	2025-06-01 00:15:40.494953	2025-06-01 00:15:40.494953	\N	\N
3218	174	\N	Maestro albañil	hr	0.6000	18.75	labor	2025-06-01 00:15:40.511747	2025-06-01 00:15:40.511747	\N	\N
3219	175	\N	Peón	hr	0.9500	6.25	labor	2025-06-01 00:15:40.929965	2025-06-01 00:15:40.929965	\N	\N
3220	176	\N	Peón	hr	0.9500	6.25	labor	2025-06-01 00:15:41.273528	2025-06-01 00:15:41.273528	\N	\N
3221	177	\N	Peón	hr	0.7500	6.25	labor	2025-06-01 00:15:41.61759	2025-06-01 00:15:41.61759	\N	\N
3222	178	\N	Peón	hr	2.0000	6.25	labor	2025-06-01 00:15:41.965941	2025-06-01 00:15:41.965941	\N	\N
3223	179	\N	Peón	hr	0.7500	6.25	labor	2025-06-01 00:15:42.31326	2025-06-01 00:15:42.31326	\N	\N
3224	180	\N	Peón	hr	0.8500	6.25	labor	2025-06-01 00:15:42.655282	2025-06-01 00:15:42.655282	\N	\N
3225	181	\N	Peón	hr	1.2000	6.25	labor	2025-06-01 00:15:42.995202	2025-06-01 00:15:42.995202	\N	\N
3226	182	\N	Peón	hr	0.7500	6.25	labor	2025-06-01 00:15:43.337598	2025-06-01 00:15:43.337598	\N	\N
3227	183	\N	Peón	hr	0.9500	6.25	labor	2025-06-01 00:15:43.686512	2025-06-01 00:15:43.686512	\N	\N
3228	184	\N	Peón	hr	0.2000	6.25	labor	2025-06-01 00:15:44.030504	2025-06-01 00:15:44.030504	\N	\N
3229	185	\N	Peón	hr	1.0000	6.25	labor	2025-06-01 00:15:44.373374	2025-06-01 00:15:44.373374	\N	\N
3230	186	\N	Bajante con calamina #28 de 10x15	ml	1.0000	100.00	material	2025-06-01 00:15:44.812746	2025-06-01 00:15:44.812746	\N	\N
3231	186	\N	Maestro cerrajero	hr	0.2000	25.00	labor	2025-06-01 00:15:44.829845	2025-06-01 00:15:44.829845	\N	\N
3232	187	\N	Canaleta con calamina #28 de 15x12	ml	1.0000	80.00	material	2025-06-01 00:15:45.198358	2025-06-01 00:15:45.198358	\N	\N
3233	187	\N	Maestro cerrajero	hr	0.2000	25.00	labor	2025-06-01 00:15:45.215252	2025-06-01 00:15:45.215252	\N	\N
3234	188	\N	Canaleta media luna con calamina #28	ml	1.0000	70.00	material	2025-06-01 00:15:45.586733	2025-06-01 00:15:45.586733	\N	\N
3235	188	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:15:45.603445	2025-06-01 00:15:45.603445	\N	\N
3236	188	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:15:45.620228	2025-06-01 00:15:45.620228	\N	\N
3237	189	\N	Acero de alta resistencia	kg	65.0000	8.50	material	2025-06-01 00:15:46.131678	2025-06-01 00:15:46.131678	\N	\N
3238	189	\N	Clavos de 2 1/2 pulg	kg	1.0000	13.00	material	2025-06-01 00:15:46.16672	2025-06-01 00:15:46.16672	\N	\N
3239	189	\N	Hormigón premezclado fck=210	m3	1.0000	830.00	material	2025-06-01 00:15:46.201459	2025-06-01 00:15:46.201459	\N	\N
3240	189	13	Madera para encofrado	p2	50.0000	8.00	material	2025-06-01 00:15:46.234671	2025-06-01 00:15:46.234671	\N	\N
3241	189	\N	Alambre de amarre	kg	1.0000	11.00	material	2025-06-01 00:15:46.269055	2025-06-01 00:15:46.269055	\N	\N
3242	189	\N	Ayudante	hr	22.0000	12.50	labor	2025-06-01 00:15:46.286121	2025-06-01 00:15:46.286121	\N	\N
3243	189	\N	Ayudante (encofrador)	hr	10.0000	12.50	labor	2025-06-01 00:15:46.304155	2025-06-01 00:15:46.304155	\N	\N
3244	189	\N	Ayudante (fierrista)	hr	12.0000	12.50	labor	2025-06-01 00:15:46.321044	2025-06-01 00:15:46.321044	\N	\N
3245	189	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:15:46.338385	2025-06-01 00:15:46.338385	\N	\N
3246	189	\N	Maestro encofrador	hr	5.0000	18.75	labor	2025-06-01 00:15:46.355276	2025-06-01 00:15:46.355276	\N	\N
3247	189	\N	Maestro fierrista	hr	5.0000	18.75	labor	2025-06-01 00:15:46.373215	2025-06-01 00:15:46.373215	\N	\N
3248	189	\N	Vibradora de inmersion	hr	1.0000	22.00	equipment	2025-06-01 00:15:46.390103	2025-06-01 00:15:46.390103	\N	\N
3249	190	\N	Cemento portland IP-30	kg	220.0000	1.20	material	2025-06-01 00:15:46.81074	2025-06-01 00:15:46.81074	\N	\N
3250	190	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:15:46.845493	2025-06-01 00:15:46.845493	\N	\N
3251	190	\N	Ripio bruto	m3	0.8000	180.00	material	2025-06-01 00:15:46.881157	2025-06-01 00:15:46.881157	\N	\N
3252	190	22	Agua	lt	220.0000	0.06	material	2025-06-01 00:15:46.914422	2025-06-01 00:15:46.914422	\N	\N
3253	190	\N	Ayudante	hr	15.0000	12.50	labor	2025-06-01 00:15:46.931091	2025-06-01 00:15:46.931091	\N	\N
3254	190	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:15:46.947838	2025-06-01 00:15:46.947838	\N	\N
3255	191	\N	Cemento portland IP-30	kg	8.0000	1.20	material	2025-06-01 00:15:47.374876	2025-06-01 00:15:47.374876	\N	\N
3256	191	\N	Arenilla	m3	0.0300	100.00	material	2025-06-01 00:15:47.409781	2025-06-01 00:15:47.409781	\N	\N
3257	191	\N	Ripio bruto	m3	0.0300	180.00	material	2025-06-01 00:15:47.44559	2025-06-01 00:15:47.44559	\N	\N
3258	191	22	Agua	lt	9.0000	0.06	material	2025-06-01 00:15:47.479195	2025-06-01 00:15:47.479195	\N	\N
3259	191	\N	Ayudante	hr	0.6000	12.50	labor	2025-06-01 00:15:47.496952	2025-06-01 00:15:47.496952	\N	\N
3260	191	\N	Maestro albañil	hr	0.4000	18.75	labor	2025-06-01 00:15:47.513645	2025-06-01 00:15:47.513645	\N	\N
3261	192	\N	Acero de alta resistencia	kg	55.0000	8.50	material	2025-06-01 00:15:48.020638	2025-06-01 00:15:48.020638	\N	\N
3262	192	\N	Cemento portland IP-30	kg	300.0000	1.20	material	2025-06-01 00:15:48.05679	2025-06-01 00:15:48.05679	\N	\N
3263	192	\N	Arenilla	m3	0.6000	100.00	material	2025-06-01 00:15:48.091396	2025-06-01 00:15:48.091396	\N	\N
3264	192	\N	Ripio rodado	m3	0.8000	170.00	material	2025-06-01 00:15:48.125773	2025-06-01 00:15:48.125773	\N	\N
3265	192	\N	Clavos de 2 1/2 pulg	kg	0.8000	13.00	material	2025-06-01 00:15:48.160515	2025-06-01 00:15:48.160515	\N	\N
3266	192	13	Madera para encofrado	p2	30.0000	8.00	material	2025-06-01 00:15:48.193452	2025-06-01 00:15:48.193452	\N	\N
3267	192	\N	Alambre de amarre	kg	0.8000	11.00	material	2025-06-01 00:15:48.228845	2025-06-01 00:15:48.228845	\N	\N
3268	192	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:15:48.262147	2025-06-01 00:15:48.262147	\N	\N
3269	192	\N	Ayudante	hr	22.0000	12.50	labor	2025-06-01 00:15:48.279085	2025-06-01 00:15:48.279085	\N	\N
3270	192	\N	Ayudante (encofrador)	hr	8.0000	12.50	labor	2025-06-01 00:15:48.295896	2025-06-01 00:15:48.295896	\N	\N
3271	192	\N	Ayudante (fierrista)	hr	8.0000	12.50	labor	2025-06-01 00:15:48.315656	2025-06-01 00:15:48.315656	\N	\N
3272	192	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:15:48.334292	2025-06-01 00:15:48.334292	\N	\N
3273	192	\N	Maestro encofrador	hr	4.0000	18.75	labor	2025-06-01 00:15:48.35184	2025-06-01 00:15:48.35184	\N	\N
3274	192	\N	Maestro fierrista	hr	4.0000	18.75	labor	2025-06-01 00:15:48.369699	2025-06-01 00:15:48.369699	\N	\N
3275	192	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:15:48.386891	2025-06-01 00:15:48.386891	\N	\N
3276	192	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:15:48.403582	2025-06-01 00:15:48.403582	\N	\N
3277	193	\N	Cemento portland IP-30	kg	180.0000	1.20	material	2025-06-01 00:15:48.838413	2025-06-01 00:15:48.838413	\N	\N
3278	193	\N	Arenilla	m3	0.2800	100.00	material	2025-06-01 00:15:48.873098	2025-06-01 00:15:48.873098	\N	\N
3279	193	\N	Piedra bola	m3	0.6000	192.00	material	2025-06-01 00:15:48.9079	2025-06-01 00:15:48.9079	\N	\N
3280	193	\N	Ripio rodado	m3	0.3800	170.00	material	2025-06-01 00:15:48.943251	2025-06-01 00:15:48.943251	\N	\N
3281	193	22	Agua	lt	180.0000	0.06	material	2025-06-01 00:15:48.977557	2025-06-01 00:15:48.977557	\N	\N
3282	193	\N	Ayudante	hr	12.0000	12.50	labor	2025-06-01 00:15:48.994355	2025-06-01 00:15:48.994355	\N	\N
3283	193	\N	Maestro albañil	hr	6.0000	18.75	labor	2025-06-01 00:15:49.011172	2025-06-01 00:15:49.011172	\N	\N
3284	193	\N	Mezcladora 350 lts (1 bolsa)	hr	0.8000	30.00	equipment	2025-06-01 00:15:49.028648	2025-06-01 00:15:49.028648	\N	\N
3285	193	\N	Vibradora de inmersion	hr	0.8000	22.00	equipment	2025-06-01 00:15:49.04574	2025-06-01 00:15:49.04574	\N	\N
3286	194	\N	Cemento portland IP-30	kg	180.0000	1.20	material	2025-06-01 00:15:49.501912	2025-06-01 00:15:49.501912	\N	\N
3287	194	\N	Arenilla	m3	0.2400	100.00	material	2025-06-01 00:15:49.536936	2025-06-01 00:15:49.536936	\N	\N
3288	194	\N	Piedra bola	m3	0.4000	192.00	material	2025-06-01 00:15:49.57147	2025-06-01 00:15:49.57147	\N	\N
3289	194	\N	Ripio rodado	m3	0.4800	170.00	material	2025-06-01 00:15:49.606072	2025-06-01 00:15:49.606072	\N	\N
3290	194	22	Agua	lt	180.0000	0.06	material	2025-06-01 00:15:49.639937	2025-06-01 00:15:49.639937	\N	\N
3291	194	\N	Ayudante	hr	8.0000	12.50	labor	2025-06-01 00:15:49.65718	2025-06-01 00:15:49.65718	\N	\N
3292	194	\N	Capataz	hr	0.5000	18.75	labor	2025-06-01 00:15:49.675318	2025-06-01 00:15:49.675318	\N	\N
3293	194	\N	Maestro albañil	hr	6.0000	18.75	labor	2025-06-01 00:15:49.692962	2025-06-01 00:15:49.692962	\N	\N
3294	194	\N	Mezcladora 350 lts (1 bolsa)	hr	0.8000	30.00	equipment	2025-06-01 00:15:49.709777	2025-06-01 00:15:49.709777	\N	\N
3295	194	\N	Vibradora de inmersion	hr	0.8000	22.00	equipment	2025-06-01 00:15:49.726399	2025-06-01 00:15:49.726399	\N	\N
3296	195	\N	Acero de alta resistencia	kg	175.0000	8.50	material	2025-06-01 00:15:50.194111	2025-06-01 00:15:50.194111	\N	\N
3297	195	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:15:50.228537	2025-06-01 00:15:50.228537	\N	\N
3298	195	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:15:50.26291	2025-06-01 00:15:50.26291	\N	\N
3299	195	\N	Ripio rodado	m3	0.7500	170.00	material	2025-06-01 00:15:50.297084	2025-06-01 00:15:50.297084	\N	\N
3300	195	\N	Clavos de 2 1/2 pulg	kg	1.2000	13.00	material	2025-06-01 00:15:50.331842	2025-06-01 00:15:50.331842	\N	\N
3301	195	13	Madera para encofrado	p2	80.0000	8.00	material	2025-06-01 00:15:50.3652	2025-06-01 00:15:50.3652	\N	\N
3302	195	\N	Alambre de amarre	kg	1.2000	11.00	material	2025-06-01 00:15:50.398222	2025-06-01 00:15:50.398222	\N	\N
3303	195	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:15:50.43138	2025-06-01 00:15:50.43138	\N	\N
3304	195	\N	Ayudante	hr	28.0000	12.50	labor	2025-06-01 00:15:50.448021	2025-06-01 00:15:50.448021	\N	\N
3305	195	\N	Ayudante (encofrador)	hr	15.0000	12.50	labor	2025-06-01 00:15:50.464718	2025-06-01 00:15:50.464718	\N	\N
3306	195	\N	Ayudante (fierrista)	hr	15.0000	12.50	labor	2025-06-01 00:15:50.481343	2025-06-01 00:15:50.481343	\N	\N
3307	195	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:15:50.498353	2025-06-01 00:15:50.498353	\N	\N
3308	195	\N	Maestro encofrador	hr	5.0000	18.75	labor	2025-06-01 00:15:50.515471	2025-06-01 00:15:50.515471	\N	\N
3309	195	\N	Maestro fierrista	hr	5.0000	18.75	labor	2025-06-01 00:15:50.532254	2025-06-01 00:15:50.532254	\N	\N
3310	195	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:15:50.549011	2025-06-01 00:15:50.549011	\N	\N
3311	195	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:15:50.566282	2025-06-01 00:15:50.566282	\N	\N
3312	196	\N	Cemento portland IP-30	kg	250.0000	1.20	material	2025-06-01 00:15:50.987102	2025-06-01 00:15:50.987102	\N	\N
3313	196	\N	Arenilla	m3	0.5000	100.00	material	2025-06-01 00:15:51.022236	2025-06-01 00:15:51.022236	\N	\N
3314	196	\N	Ripio rodado	m3	0.6000	170.00	material	2025-06-01 00:15:51.057349	2025-06-01 00:15:51.057349	\N	\N
3315	196	\N	Sika-1	lt	10.0000	18.00	material	2025-06-01 00:15:51.092111	2025-06-01 00:15:51.092111	\N	\N
3316	196	22	Agua	lt	220.0000	0.06	material	2025-06-01 00:15:51.125831	2025-06-01 00:15:51.125831	\N	\N
3317	196	\N	Ayudante	hr	20.0000	12.50	labor	2025-06-01 00:15:51.142531	2025-06-01 00:15:51.142531	\N	\N
3318	196	\N	Maestro albañil	hr	17.0000	18.75	labor	2025-06-01 00:15:51.159469	2025-06-01 00:15:51.159469	\N	\N
3319	196	\N	Mezcladora 350 lts (1 bolsa)	hr	0.6000	30.00	equipment	2025-06-01 00:15:51.17627	2025-06-01 00:15:51.17627	\N	\N
3320	197	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:15:51.613157	2025-06-01 00:15:51.613157	\N	\N
3321	197	5	Arena Fina	m3	0.0100	70.00	material	2025-06-01 00:15:51.646631	2025-06-01 00:15:51.646631	\N	\N
3322	197	\N	Cordón de acera	pza	1.2500	55.00	material	2025-06-01 00:15:51.682328	2025-06-01 00:15:51.682328	\N	\N
3323	197	\N	Ayudante	hr	0.9000	12.50	labor	2025-06-01 00:15:51.699138	2025-06-01 00:15:51.699138	\N	\N
3324	197	\N	Maestro albañil	hr	0.9000	18.75	labor	2025-06-01 00:15:51.716042	2025-06-01 00:15:51.716042	\N	\N
3325	198	\N	Acero de alta resistencia	kg	40.0000	8.50	material	2025-06-01 00:15:52.189748	2025-06-01 00:15:52.189748	\N	\N
3326	198	\N	Cemento portland IP-30	kg	300.0000	1.20	material	2025-06-01 00:15:52.231762	2025-06-01 00:15:52.231762	\N	\N
3327	198	\N	Arenilla	m3	0.6000	100.00	material	2025-06-01 00:15:52.266133	2025-06-01 00:15:52.266133	\N	\N
3328	198	\N	Ripio rodado	m3	0.8000	170.00	material	2025-06-01 00:15:52.300794	2025-06-01 00:15:52.300794	\N	\N
3329	198	\N	Clavos de 2 1/2 pulg	kg	0.8000	13.00	material	2025-06-01 00:15:52.336653	2025-06-01 00:15:52.336653	\N	\N
3330	198	13	Madera para encofrado	p2	30.0000	8.00	material	2025-06-01 00:15:52.370168	2025-06-01 00:15:52.370168	\N	\N
3331	198	\N	Alambre de amarre	kg	0.8000	11.00	material	2025-06-01 00:15:52.407395	2025-06-01 00:15:52.407395	\N	\N
3332	198	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:15:52.440264	2025-06-01 00:15:52.440264	\N	\N
3333	198	\N	Ayudante	hr	22.0000	12.50	labor	2025-06-01 00:15:52.457692	2025-06-01 00:15:52.457692	\N	\N
3334	198	\N	Ayudante (encofrador)	hr	8.0000	12.50	labor	2025-06-01 00:15:52.474407	2025-06-01 00:15:52.474407	\N	\N
3335	198	\N	Ayudante (fierrista)	hr	8.0000	12.50	labor	2025-06-01 00:15:52.491541	2025-06-01 00:15:52.491541	\N	\N
3336	198	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:15:52.508631	2025-06-01 00:15:52.508631	\N	\N
3337	198	\N	Maestro encofrador	hr	4.0000	18.75	labor	2025-06-01 00:15:52.525877	2025-06-01 00:15:52.525877	\N	\N
3338	198	\N	Maestro fierrista	hr	4.0000	18.75	labor	2025-06-01 00:15:52.542732	2025-06-01 00:15:52.542732	\N	\N
3339	198	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:15:52.559588	2025-06-01 00:15:52.559588	\N	\N
3340	198	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:15:52.576479	2025-06-01 00:15:52.576479	\N	\N
3341	199	\N	Acero de alta resistencia	kg	40.0000	8.50	material	2025-06-01 00:15:53.008968	2025-06-01 00:15:53.008968	\N	\N
3342	199	\N	Cemento portland IP-30	kg	250.0000	1.20	material	2025-06-01 00:15:53.043402	2025-06-01 00:15:53.043402	\N	\N
3343	199	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:15:53.078515	2025-06-01 00:15:53.078515	\N	\N
3344	199	\N	Ripio rodado	m3	0.7500	170.00	material	2025-06-01 00:15:53.112757	2025-06-01 00:15:53.112757	\N	\N
3345	199	23	Clavos de 2 pulg	kg	1.0000	13.00	material	2025-06-01 00:15:53.145568	2025-06-01 00:15:53.145568	\N	\N
3346	199	13	Madera para encofrado	p2	25.0000	8.00	material	2025-06-01 00:15:53.17909	2025-06-01 00:15:53.17909	\N	\N
3347	199	\N	Alambre de amarre	kg	1.0000	11.00	material	2025-06-01 00:15:53.213925	2025-06-01 00:15:53.213925	\N	\N
3348	199	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:15:53.247915	2025-06-01 00:15:53.247915	\N	\N
3349	199	\N	Ayudante	hr	20.0000	12.50	labor	2025-06-01 00:15:53.265172	2025-06-01 00:15:53.265172	\N	\N
3350	199	\N	Maestro albañil	hr	10.0000	18.75	labor	2025-06-01 00:15:53.281324	2025-06-01 00:15:53.281324	\N	\N
3351	200	\N	Cemento portland IP-30	kg	21.0000	1.20	material	2025-06-01 00:15:53.804121	2025-06-01 00:15:53.804121	\N	\N
3352	200	\N	Arenilla	m3	0.0400	100.00	material	2025-06-01 00:15:53.854658	2025-06-01 00:15:53.854658	\N	\N
3353	200	\N	Piedra manzana	m3	0.1500	250.00	material	2025-06-01 00:15:53.89143	2025-06-01 00:15:53.89143	\N	\N
3354	200	\N	Ripio rodado	m3	0.0600	170.00	material	2025-06-01 00:15:53.926318	2025-06-01 00:15:53.926318	\N	\N
3355	200	\N	Ayudante	hr	2.5000	12.50	labor	2025-06-01 00:15:53.9461	2025-06-01 00:15:53.9461	\N	\N
3356	200	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:15:53.970774	2025-06-01 00:15:53.970774	\N	\N
3357	200	\N	Mezcladora 350 lts (1 bolsa)	hr	0.0500	30.00	equipment	2025-06-01 00:15:53.988482	2025-06-01 00:15:53.988482	\N	\N
3358	201	\N	Acero de alta resistencia	kg	100.0000	8.50	material	2025-06-01 00:15:54.518928	2025-06-01 00:15:54.518928	\N	\N
3359	201	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:15:54.553499	2025-06-01 00:15:54.553499	\N	\N
3360	201	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:15:54.589317	2025-06-01 00:15:54.589317	\N	\N
3361	201	\N	Ripio chancado	m3	0.7500	230.00	material	2025-06-01 00:15:54.623607	2025-06-01 00:15:54.623607	\N	\N
3362	201	23	Clavos de 2 pulg	kg	1.5500	13.00	material	2025-06-01 00:15:54.656756	2025-06-01 00:15:54.656756	\N	\N
3363	201	13	Madera para encofrado	p2	80.0000	8.00	material	2025-06-01 00:15:54.691323	2025-06-01 00:15:54.691323	\N	\N
3364	201	\N	Alambre de amarre	kg	1.5500	11.00	material	2025-06-01 00:15:54.726238	2025-06-01 00:15:54.726238	\N	\N
3365	201	22	Agua	lt	180.0000	0.06	material	2025-06-01 00:15:54.760204	2025-06-01 00:15:54.760204	\N	\N
3366	201	\N	Ayudante	hr	22.0000	12.50	labor	2025-06-01 00:15:54.777057	2025-06-01 00:15:54.777057	\N	\N
3367	201	\N	Ayudante (encofrador)	hr	20.0000	12.50	labor	2025-06-01 00:15:54.793983	2025-06-01 00:15:54.793983	\N	\N
3368	201	\N	Ayudante (fierrista)	hr	20.0000	12.50	labor	2025-06-01 00:15:54.810851	2025-06-01 00:15:54.810851	\N	\N
3369	201	\N	Maestro albañil	hr	8.0000	18.75	labor	2025-06-01 00:15:54.827662	2025-06-01 00:15:54.827662	\N	\N
3370	201	\N	Maestro encofrador	hr	10.0000	18.75	labor	2025-06-01 00:15:54.84444	2025-06-01 00:15:54.84444	\N	\N
3371	201	\N	Maestro fierrista	hr	10.0000	18.75	labor	2025-06-01 00:15:54.915437	2025-06-01 00:15:54.915437	\N	\N
3372	201	\N	Guinche	hr	0.2500	42.00	equipment	2025-06-01 00:15:54.932565	2025-06-01 00:15:54.932565	\N	\N
3373	201	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:15:54.949439	2025-06-01 00:15:54.949439	\N	\N
3374	201	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:15:54.966286	2025-06-01 00:15:54.966286	\N	\N
3375	202	\N	Acero de alta resistencia	kg	80.0000	8.50	material	2025-06-01 00:15:55.512447	2025-06-01 00:15:55.512447	\N	\N
3376	202	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:15:55.546663	2025-06-01 00:15:55.546663	\N	\N
3377	202	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:15:55.581309	2025-06-01 00:15:55.581309	\N	\N
3378	202	\N	Ripio chancado	m3	0.7500	230.00	material	2025-06-01 00:15:55.615541	2025-06-01 00:15:55.615541	\N	\N
3379	202	23	Clavos de 2 pulg	kg	1.5500	13.00	material	2025-06-01 00:15:55.6483	2025-06-01 00:15:55.6483	\N	\N
3380	202	\N	Madera para andamio	p2	10.0000	10.00	material	2025-06-01 00:15:55.682413	2025-06-01 00:15:55.682413	\N	\N
3381	202	13	Madera para encofrado	p2	50.0000	8.00	material	2025-06-01 00:15:55.715289	2025-06-01 00:15:55.715289	\N	\N
3382	202	\N	Alambre de amarre	kg	1.5500	11.00	material	2025-06-01 00:15:55.750143	2025-06-01 00:15:55.750143	\N	\N
3383	202	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:15:55.783354	2025-06-01 00:15:55.783354	\N	\N
3384	202	\N	Ayudante	hr	21.0000	12.50	labor	2025-06-01 00:15:55.800515	2025-06-01 00:15:55.800515	\N	\N
3385	202	\N	Maestro albañil	hr	7.0000	18.75	labor	2025-06-01 00:15:55.817607	2025-06-01 00:15:55.817607	\N	\N
3386	202	\N	Mezcladora 350 lts (1 bolsa)	hr	1.0000	30.00	equipment	2025-06-01 00:15:55.834875	2025-06-01 00:15:55.834875	\N	\N
3387	202	\N	Vibradora de inmersion	hr	1.0000	22.00	equipment	2025-06-01 00:15:55.851709	2025-06-01 00:15:55.851709	\N	\N
3388	203	\N	Sika Flex 1A	kg	1.0000	245.94	material	2025-06-01 00:15:56.235388	2025-06-01 00:15:56.235388	\N	\N
3389	203	\N	Plastoform	m2	1.0000	255.00	material	2025-06-01 00:15:56.269567	2025-06-01 00:15:56.269567	\N	\N
3390	203	\N	Ayudante de albañil	hr	1.0000	12.50	labor	2025-06-01 00:15:56.286253	2025-06-01 00:15:56.286253	\N	\N
3391	203	\N	Maestro albañil	hr	1.0000	18.75	labor	2025-06-01 00:15:56.303037	2025-06-01 00:15:56.303037	\N	\N
3392	203	\N	Maquina para corte de hormigón	hr	1.0000	95.00	equipment	2025-06-01 00:15:56.319652	2025-06-01 00:15:56.319652	\N	\N
3393	204	\N	Acero de alta resistencia	kg	19.6000	8.50	material	2025-06-01 00:15:56.870106	2025-06-01 00:15:56.870106	\N	\N
3394	204	23	Clavos de 2 pulg	kg	0.0500	13.00	material	2025-06-01 00:15:56.901865	2025-06-01 00:15:56.901865	\N	\N
3395	204	\N	Hormigón premezclado fck=210	m3	0.1400	830.00	material	2025-06-01 00:15:56.935708	2025-06-01 00:15:56.935708	\N	\N
3396	204	13	Madera para encofrado	p2	20.0000	8.00	material	2025-06-01 00:15:56.968707	2025-06-01 00:15:56.968707	\N	\N
3397	204	\N	Alambre de amarre	kg	0.2000	11.00	material	2025-06-01 00:15:57.002821	2025-06-01 00:15:57.002821	\N	\N
3398	204	\N	puntales de 3 m.	pza	1.5000	17.00	material	2025-06-01 00:15:57.038506	2025-06-01 00:15:57.038506	\N	\N
3399	204	\N	Plastoform	m2	0.1600	255.00	material	2025-06-01 00:15:57.073852	2025-06-01 00:15:57.073852	\N	\N
3400	204	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:15:57.090502	2025-06-01 00:15:57.090502	\N	\N
3401	204	\N	Ayudante (encofrador)	hr	4.0000	12.50	labor	2025-06-01 00:15:57.107046	2025-06-01 00:15:57.107046	\N	\N
3402	204	\N	Ayudante (fierrista)	hr	2.0000	12.50	labor	2025-06-01 00:15:57.123735	2025-06-01 00:15:57.123735	\N	\N
3403	204	\N	Maestro albañil	hr	1.0000	18.75	labor	2025-06-01 00:15:57.140321	2025-06-01 00:15:57.140321	\N	\N
3404	204	\N	Maestro encofrador	hr	4.0000	18.75	labor	2025-06-01 00:15:57.158972	2025-06-01 00:15:57.158972	\N	\N
3405	204	\N	Maestro fierrista	hr	2.0000	18.75	labor	2025-06-01 00:15:57.175723	2025-06-01 00:15:57.175723	\N	\N
3406	204	\N	Vibradora de inmersion	hr	0.3000	22.00	equipment	2025-06-01 00:15:57.192409	2025-06-01 00:15:57.192409	\N	\N
3407	205	\N	Acero de alta resistencia	kg	68.0000	8.50	material	2025-06-01 00:15:57.655178	2025-06-01 00:15:57.655178	\N	\N
3408	205	\N	Cemento portland IP-30	kg	300.0000	1.20	material	2025-06-01 00:15:57.692058	2025-06-01 00:15:57.692058	\N	\N
3409	205	\N	Arenilla	m3	0.6000	100.00	material	2025-06-01 00:15:57.727069	2025-06-01 00:15:57.727069	\N	\N
3410	205	\N	Ripio rodado	m3	0.8000	170.00	material	2025-06-01 00:15:57.76117	2025-06-01 00:15:57.76117	\N	\N
3411	205	\N	Clavos de 2 1/2 pulg	kg	0.8000	13.00	material	2025-06-01 00:15:57.796281	2025-06-01 00:15:57.796281	\N	\N
3412	205	13	Madera para encofrado	p2	30.0000	8.00	material	2025-06-01 00:15:57.829296	2025-06-01 00:15:57.829296	\N	\N
3413	205	\N	Alambre de amarre	kg	0.8000	11.00	material	2025-06-01 00:15:57.863502	2025-06-01 00:15:57.863502	\N	\N
3414	205	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:15:57.896588	2025-06-01 00:15:57.896588	\N	\N
3415	205	\N	Ayudante	hr	22.0000	12.50	labor	2025-06-01 00:15:57.913401	2025-06-01 00:15:57.913401	\N	\N
3416	205	\N	Ayudante (encofrador)	hr	8.0000	12.50	labor	2025-06-01 00:15:57.930086	2025-06-01 00:15:57.930086	\N	\N
3417	205	\N	Ayudante (fierrista)	hr	8.0000	12.50	labor	2025-06-01 00:15:57.946696	2025-06-01 00:15:57.946696	\N	\N
3418	205	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:15:57.963335	2025-06-01 00:15:57.963335	\N	\N
3419	205	\N	Maestro encofrador	hr	4.0000	18.75	labor	2025-06-01 00:15:57.979871	2025-06-01 00:15:57.979871	\N	\N
3420	205	\N	Maestro fierrista	hr	4.0000	18.75	labor	2025-06-01 00:15:57.99649	2025-06-01 00:15:57.99649	\N	\N
3421	205	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:15:58.013336	2025-06-01 00:15:58.013336	\N	\N
3422	205	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:15:58.030423	2025-06-01 00:15:58.030423	\N	\N
3423	206	\N	Acero de alta resistencia	kg	2.0000	8.50	material	2025-06-01 00:15:58.460224	2025-06-01 00:15:58.460224	\N	\N
3424	206	\N	Cemento portland IP-30	kg	27.0000	1.20	material	2025-06-01 00:15:58.496608	2025-06-01 00:15:58.496608	\N	\N
3425	206	\N	Arenilla	m3	0.0500	100.00	material	2025-06-01 00:15:58.531093	2025-06-01 00:15:58.531093	\N	\N
3426	206	\N	Ripio chancado	m3	0.0700	230.00	material	2025-06-01 00:15:58.565951	2025-06-01 00:15:58.565951	\N	\N
3427	206	23	Clavos de 2 pulg	kg	0.1500	13.00	material	2025-06-01 00:15:58.59777	2025-06-01 00:15:58.59777	\N	\N
3428	206	13	Madera para encofrado	p2	12.0000	8.00	material	2025-06-01 00:15:58.631035	2025-06-01 00:15:58.631035	\N	\N
3429	206	\N	Alambre de amarre	kg	0.1500	11.00	material	2025-06-01 00:15:58.66536	2025-06-01 00:15:58.66536	\N	\N
3430	206	22	Agua	lt	17.0000	0.06	material	2025-06-01 00:15:58.698141	2025-06-01 00:15:58.698141	\N	\N
3431	206	\N	Viguetas y complemento #10	m2	1.0000	77.00	material	2025-06-01 00:15:58.732908	2025-06-01 00:15:58.732908	\N	\N
3432	206	\N	Ayudante	hr	5.2500	12.50	labor	2025-06-01 00:15:58.749932	2025-06-01 00:15:58.749932	\N	\N
3433	206	\N	Maestro albañil	hr	1.7500	18.75	labor	2025-06-01 00:15:58.767358	2025-06-01 00:15:58.767358	\N	\N
3434	206	\N	Guinche	hr	0.1000	42.00	equipment	2025-06-01 00:15:58.784159	2025-06-01 00:15:58.784159	\N	\N
3435	206	\N	Mezcladora 350 lts (1 bolsa)	hr	0.0800	30.00	equipment	2025-06-01 00:15:58.801015	2025-06-01 00:15:58.801015	\N	\N
3436	206	\N	Vibradora de inmersion	hr	0.0800	22.00	equipment	2025-06-01 00:15:58.818348	2025-06-01 00:15:58.818348	\N	\N
3437	207	\N	Acero de alta resistencia	kg	2.0000	8.50	material	2025-06-01 00:15:59.279608	2025-06-01 00:15:59.279608	\N	\N
3438	207	\N	Cemento portland IP-30	kg	32.0000	1.20	material	2025-06-01 00:15:59.314424	2025-06-01 00:15:59.314424	\N	\N
3439	207	\N	Arenilla	m3	0.0500	100.00	material	2025-06-01 00:15:59.348724	2025-06-01 00:15:59.348724	\N	\N
3440	207	\N	Ripio chancado	m3	0.0700	230.00	material	2025-06-01 00:15:59.383042	2025-06-01 00:15:59.383042	\N	\N
3441	207	23	Clavos de 2 pulg	kg	0.1500	13.00	material	2025-06-01 00:15:59.415109	2025-06-01 00:15:59.415109	\N	\N
3442	207	13	Madera para encofrado	p2	8.0000	8.00	material	2025-06-01 00:15:59.4482	2025-06-01 00:15:59.4482	\N	\N
3443	207	\N	Alambre de amarre	kg	0.1500	11.00	material	2025-06-01 00:15:59.482759	2025-06-01 00:15:59.482759	\N	\N
3444	207	22	Agua	lt	17.0000	0.06	material	2025-06-01 00:15:59.516196	2025-06-01 00:15:59.516196	\N	\N
3445	207	\N	Viguetas y complemento #12	m2	1.0000	100.00	material	2025-06-01 00:15:59.551302	2025-06-01 00:15:59.551302	\N	\N
3446	207	\N	Ayudante	hr	3.0000	12.50	labor	2025-06-01 00:15:59.568254	2025-06-01 00:15:59.568254	\N	\N
3447	207	\N	Ayudante (encofrador)	hr	2.0000	12.50	labor	2025-06-01 00:15:59.584963	2025-06-01 00:15:59.584963	\N	\N
3448	207	\N	Ayudante (fierrista)	hr	1.2000	12.50	labor	2025-06-01 00:15:59.602029	2025-06-01 00:15:59.602029	\N	\N
3449	207	\N	Maestro albañil	hr	0.6000	18.75	labor	2025-06-01 00:15:59.617742	2025-06-01 00:15:59.617742	\N	\N
3450	207	\N	Maestro encofrador	hr	1.0000	18.75	labor	2025-06-01 00:15:59.634336	2025-06-01 00:15:59.634336	\N	\N
3451	207	\N	Maestro fierrista	hr	0.6000	18.75	labor	2025-06-01 00:15:59.651169	2025-06-01 00:15:59.651169	\N	\N
3452	207	\N	Guinche	hr	0.1000	42.00	equipment	2025-06-01 00:15:59.667903	2025-06-01 00:15:59.667903	\N	\N
3453	207	\N	Mezcladora 350 lts (1 bolsa)	hr	0.1000	30.00	equipment	2025-06-01 00:15:59.685327	2025-06-01 00:15:59.685327	\N	\N
3454	207	\N	Vibradora de inmersion	hr	0.1000	22.00	equipment	2025-06-01 00:15:59.702182	2025-06-01 00:15:59.702182	\N	\N
3455	208	\N	Acero de alta resistencia	kg	2.0000	8.50	material	2025-06-01 00:16:00.221389	2025-06-01 00:16:00.221389	\N	\N
3456	208	23	Clavos de 2 pulg	kg	0.1500	13.00	material	2025-06-01 00:16:00.254501	2025-06-01 00:16:00.254501	\N	\N
3457	208	\N	Hormigón premezclado fck=210	m3	0.1000	830.00	material	2025-06-01 00:16:00.290688	2025-06-01 00:16:00.290688	\N	\N
3458	208	13	Madera para encofrado	p2	12.0000	8.00	material	2025-06-01 00:16:00.325241	2025-06-01 00:16:00.325241	\N	\N
3459	208	\N	Alambre de amarre	kg	0.0500	11.00	material	2025-06-01 00:16:00.360604	2025-06-01 00:16:00.360604	\N	\N
3460	208	\N	Viguetas y complemento #12	m2	1.0000	100.00	material	2025-06-01 00:16:00.395889	2025-06-01 00:16:00.395889	\N	\N
3461	208	\N	Ayudante	hr	2.2000	12.50	labor	2025-06-01 00:16:00.413016	2025-06-01 00:16:00.413016	\N	\N
3462	208	\N	Ayudante (encofrador)	hr	1.0000	12.50	labor	2025-06-01 00:16:00.430062	2025-06-01 00:16:00.430062	\N	\N
3463	208	\N	Ayudante (fierrista)	hr	1.0000	12.50	labor	2025-06-01 00:16:00.447158	2025-06-01 00:16:00.447158	\N	\N
3464	208	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:16:00.463886	2025-06-01 00:16:00.463886	\N	\N
3465	208	\N	Maestro encofrador	hr	0.4000	18.75	labor	2025-06-01 00:16:00.480556	2025-06-01 00:16:00.480556	\N	\N
3466	208	\N	Maestro fierrista	hr	0.4000	18.75	labor	2025-06-01 00:16:00.497271	2025-06-01 00:16:00.497271	\N	\N
3467	208	\N	Vibradora de inmersion	hr	0.0800	22.00	equipment	2025-06-01 00:16:00.513892	2025-06-01 00:16:00.513892	\N	\N
3468	209	\N	Acero de alta resistencia	kg	2.0000	8.50	material	2025-06-01 00:16:01.048623	2025-06-01 00:16:01.048623	\N	\N
3469	209	\N	Cemento portland IP-30	kg	27.0000	1.20	material	2025-06-01 00:16:01.084224	2025-06-01 00:16:01.084224	\N	\N
3470	209	\N	Arenilla	m3	0.0500	100.00	material	2025-06-01 00:16:01.12113	2025-06-01 00:16:01.12113	\N	\N
3471	209	\N	Ripio chancado	m3	0.0700	230.00	material	2025-06-01 00:16:01.154812	2025-06-01 00:16:01.154812	\N	\N
3472	209	23	Clavos de 2 pulg	kg	0.1500	13.00	material	2025-06-01 00:16:01.188036	2025-06-01 00:16:01.188036	\N	\N
3473	209	13	Madera para encofrado	p2	12.0000	8.00	material	2025-06-01 00:16:01.221065	2025-06-01 00:16:01.221065	\N	\N
3474	209	\N	Alambre de amarre	kg	0.1500	11.00	material	2025-06-01 00:16:01.256222	2025-06-01 00:16:01.256222	\N	\N
3475	209	22	Agua	lt	17.0000	0.06	material	2025-06-01 00:16:01.289413	2025-06-01 00:16:01.289413	\N	\N
3476	209	\N	Viguetas y complemento #16	m2	1.0000	102.00	material	2025-06-01 00:16:01.323714	2025-06-01 00:16:01.323714	\N	\N
3477	209	\N	Ayudante	hr	5.2500	12.50	labor	2025-06-01 00:16:01.34089	2025-06-01 00:16:01.34089	\N	\N
3478	209	\N	Maestro albañil	hr	1.7500	18.75	labor	2025-06-01 00:16:01.357436	2025-06-01 00:16:01.357436	\N	\N
3479	209	\N	Guinche	hr	0.1000	42.00	equipment	2025-06-01 00:16:01.37434	2025-06-01 00:16:01.37434	\N	\N
3480	209	\N	Mezcladora 350 lts (1 bolsa)	hr	0.0800	30.00	equipment	2025-06-01 00:16:01.391265	2025-06-01 00:16:01.391265	\N	\N
3481	209	\N	Vibradora de inmersion	hr	0.0800	22.00	equipment	2025-06-01 00:16:01.407915	2025-06-01 00:16:01.407915	\N	\N
3482	210	\N	Acero de alta resistencia	kg	2.0000	8.50	material	2025-06-01 00:16:01.831186	2025-06-01 00:16:01.831186	\N	\N
3483	210	23	Clavos de 2 pulg	kg	0.1500	13.00	material	2025-06-01 00:16:01.864655	2025-06-01 00:16:01.864655	\N	\N
3484	210	\N	Hormigón premezclado fck=210	m3	0.1000	830.00	material	2025-06-01 00:16:01.89972	2025-06-01 00:16:01.89972	\N	\N
3485	210	13	Madera para encofrado	p2	12.0000	8.00	material	2025-06-01 00:16:01.934633	2025-06-01 00:16:01.934633	\N	\N
3486	210	\N	Alambre de amarre	kg	0.0500	11.00	material	2025-06-01 00:16:01.969066	2025-06-01 00:16:01.969066	\N	\N
3487	210	\N	Viguetas y complemento #16	m2	1.0000	102.00	material	2025-06-01 00:16:02.004057	2025-06-01 00:16:02.004057	\N	\N
3488	210	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:16:02.021244	2025-06-01 00:16:02.021244	\N	\N
3489	210	\N	Maestro albañil	hr	0.9000	18.75	labor	2025-06-01 00:16:02.038298	2025-06-01 00:16:02.038298	\N	\N
3490	210	\N	Vibradora de inmersion	hr	0.0800	22.00	equipment	2025-06-01 00:16:02.055928	2025-06-01 00:16:02.055928	\N	\N
3491	211	\N	Acero de alta resistencia	kg	68.0000	8.50	material	2025-06-01 00:16:02.525004	2025-06-01 00:16:02.525004	\N	\N
3492	211	\N	Cemento portland IP-30	kg	300.0000	1.20	material	2025-06-01 00:16:02.559297	2025-06-01 00:16:02.559297	\N	\N
3493	211	\N	Arenilla	m3	0.6000	100.00	material	2025-06-01 00:16:02.595306	2025-06-01 00:16:02.595306	\N	\N
3494	211	\N	Ripio rodado	m3	0.8000	170.00	material	2025-06-01 00:16:02.629568	2025-06-01 00:16:02.629568	\N	\N
3495	211	\N	Clavos de 2 1/2 pulg	kg	0.8000	13.00	material	2025-06-01 00:16:02.664013	2025-06-01 00:16:02.664013	\N	\N
3496	211	13	Madera para encofrado	p2	30.0000	8.00	material	2025-06-01 00:16:02.697045	2025-06-01 00:16:02.697045	\N	\N
3497	211	\N	Alambre de amarre	kg	0.8000	11.00	material	2025-06-01 00:16:02.732529	2025-06-01 00:16:02.732529	\N	\N
3498	211	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:16:02.766149	2025-06-01 00:16:02.766149	\N	\N
3499	211	\N	Ayudante	hr	22.0000	12.50	labor	2025-06-01 00:16:02.783256	2025-06-01 00:16:02.783256	\N	\N
3500	211	\N	Ayudante (encofrador)	hr	8.0000	12.50	labor	2025-06-01 00:16:02.800735	2025-06-01 00:16:02.800735	\N	\N
3501	211	\N	Ayudante (fierrista)	hr	8.0000	12.50	labor	2025-06-01 00:16:02.818601	2025-06-01 00:16:02.818601	\N	\N
3502	211	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:02.83561	2025-06-01 00:16:02.83561	\N	\N
3503	211	\N	Maestro encofrador	hr	4.0000	18.75	labor	2025-06-01 00:16:02.852613	2025-06-01 00:16:02.852613	\N	\N
3504	211	\N	Maestro fierrista	hr	4.0000	18.75	labor	2025-06-01 00:16:02.869395	2025-06-01 00:16:02.869395	\N	\N
3505	211	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:16:02.886248	2025-06-01 00:16:02.886248	\N	\N
3506	211	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:16:02.903298	2025-06-01 00:16:02.903298	\N	\N
3507	212	\N	Acero de alta resistencia	kg	122.0000	8.50	material	2025-06-01 00:16:03.413933	2025-06-01 00:16:03.413933	\N	\N
3508	212	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:16:03.453303	2025-06-01 00:16:03.453303	\N	\N
3509	212	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:03.488335	2025-06-01 00:16:03.488335	\N	\N
3510	212	\N	Ripio rodado	m3	0.7500	170.00	material	2025-06-01 00:16:03.522734	2025-06-01 00:16:03.522734	\N	\N
3511	212	\N	Clavos de 2 1/2 pulg	kg	1.2000	13.00	material	2025-06-01 00:16:03.55961	2025-06-01 00:16:03.55961	\N	\N
3512	212	13	Madera para encofrado	p2	80.0000	8.00	material	2025-06-01 00:16:03.59366	2025-06-01 00:16:03.59366	\N	\N
3513	212	\N	Alambre de amarre	kg	1.2000	11.00	material	2025-06-01 00:16:03.628724	2025-06-01 00:16:03.628724	\N	\N
3514	212	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:16:03.661748	2025-06-01 00:16:03.661748	\N	\N
3515	212	\N	Ayudante	hr	28.0000	12.50	labor	2025-06-01 00:16:03.679303	2025-06-01 00:16:03.679303	\N	\N
3516	212	\N	Ayudante (encofrador)	hr	15.0000	12.50	labor	2025-06-01 00:16:03.696522	2025-06-01 00:16:03.696522	\N	\N
3517	212	\N	Ayudante (fierrista)	hr	15.0000	12.50	labor	2025-06-01 00:16:03.713272	2025-06-01 00:16:03.713272	\N	\N
3518	212	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:03.730361	2025-06-01 00:16:03.730361	\N	\N
3519	212	\N	Maestro encofrador	hr	5.0000	18.75	labor	2025-06-01 00:16:03.747137	2025-06-01 00:16:03.747137	\N	\N
3520	212	\N	Maestro fierrista	hr	5.0000	18.75	labor	2025-06-01 00:16:03.764618	2025-06-01 00:16:03.764618	\N	\N
3521	212	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:16:03.781362	2025-06-01 00:16:03.781362	\N	\N
3522	212	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:16:03.797999	2025-06-01 00:16:03.797999	\N	\N
3523	213	\N	Acero de alta resistencia	kg	60.0000	8.50	material	2025-06-01 00:16:04.215946	2025-06-01 00:16:04.215946	\N	\N
3524	213	23	Clavos de 2 pulg	kg	1.5500	13.00	material	2025-06-01 00:16:04.249073	2025-06-01 00:16:04.249073	\N	\N
3525	213	\N	Hormigón premezclado fck=210	m3	1.0000	830.00	material	2025-06-01 00:16:04.283767	2025-06-01 00:16:04.283767	\N	\N
3526	213	\N	Madera para andamio	p2	10.0000	10.00	material	2025-06-01 00:16:04.318187	2025-06-01 00:16:04.318187	\N	\N
3527	213	13	Madera para encofrado	p2	50.0000	8.00	material	2025-06-01 00:16:04.351775	2025-06-01 00:16:04.351775	\N	\N
3528	213	\N	Alambre de amarre	kg	0.2000	11.00	material	2025-06-01 00:16:04.386366	2025-06-01 00:16:04.386366	\N	\N
3529	213	\N	Ayudante	hr	30.0000	12.50	labor	2025-06-01 00:16:04.403978	2025-06-01 00:16:04.403978	\N	\N
3530	213	\N	Maestro albañil	hr	10.0000	18.75	labor	2025-06-01 00:16:04.420955	2025-06-01 00:16:04.420955	\N	\N
3531	213	\N	Vibradora de inmersion	hr	1.0000	22.00	equipment	2025-06-01 00:16:04.438128	2025-06-01 00:16:04.438128	\N	\N
3532	214	\N	Acero de alta resistencia	kg	80.0000	8.50	material	2025-06-01 00:16:04.875251	2025-06-01 00:16:04.875251	\N	\N
3533	214	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:16:04.909738	2025-06-01 00:16:04.909738	\N	\N
3534	214	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:04.943909	2025-06-01 00:16:04.943909	\N	\N
3535	214	\N	Ripio chancado	m3	0.7500	230.00	material	2025-06-01 00:16:04.978849	2025-06-01 00:16:04.978849	\N	\N
3536	214	23	Clavos de 2 pulg	kg	1.5500	13.00	material	2025-06-01 00:16:05.012169	2025-06-01 00:16:05.012169	\N	\N
3537	214	\N	Madera para andamio	p2	10.0000	10.00	material	2025-06-01 00:16:05.046887	2025-06-01 00:16:05.046887	\N	\N
3538	214	13	Madera para encofrado	p2	50.0000	8.00	material	2025-06-01 00:16:05.079889	2025-06-01 00:16:05.079889	\N	\N
3539	214	\N	Alambre de amarre	kg	1.5500	11.00	material	2025-06-01 00:16:05.114529	2025-06-01 00:16:05.114529	\N	\N
3540	214	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:16:05.147535	2025-06-01 00:16:05.147535	\N	\N
3541	214	\N	Ayudante	hr	45.0000	12.50	labor	2025-06-01 00:16:05.164261	2025-06-01 00:16:05.164261	\N	\N
3542	214	\N	Maestro albañil	hr	15.0000	18.75	labor	2025-06-01 00:16:05.181019	2025-06-01 00:16:05.181019	\N	\N
3543	214	\N	Mezcladora 350 lts (1 bolsa)	hr	1.0000	30.00	equipment	2025-06-01 00:16:05.197529	2025-06-01 00:16:05.197529	\N	\N
3544	214	\N	Vibradora de inmersion	hr	1.0000	22.00	equipment	2025-06-01 00:16:05.21408	2025-06-01 00:16:05.21408	\N	\N
3545	215	\N	Acero de alta resistencia	kg	122.0000	8.50	material	2025-06-01 00:16:05.688819	2025-06-01 00:16:05.688819	\N	\N
3546	215	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:16:05.724468	2025-06-01 00:16:05.724468	\N	\N
3547	215	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:05.758995	2025-06-01 00:16:05.758995	\N	\N
3548	215	\N	Ripio rodado	m3	0.7500	170.00	material	2025-06-01 00:16:05.793863	2025-06-01 00:16:05.793863	\N	\N
3549	215	\N	Clavos de 2 1/2 pulg	kg	1.2000	13.00	material	2025-06-01 00:16:05.827524	2025-06-01 00:16:05.827524	\N	\N
3550	215	13	Madera para encofrado	p2	80.0000	8.00	material	2025-06-01 00:16:05.86114	2025-06-01 00:16:05.86114	\N	\N
3551	215	\N	Alambre de amarre	kg	1.2000	11.00	material	2025-06-01 00:16:05.896888	2025-06-01 00:16:05.896888	\N	\N
3552	215	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:16:05.930446	2025-06-01 00:16:05.930446	\N	\N
3553	215	\N	Ayudante	hr	28.0000	12.50	labor	2025-06-01 00:16:05.947439	2025-06-01 00:16:05.947439	\N	\N
3554	215	\N	Ayudante (encofrador)	hr	15.0000	12.50	labor	2025-06-01 00:16:05.964307	2025-06-01 00:16:05.964307	\N	\N
3555	215	\N	Ayudante (fierrista)	hr	15.0000	12.50	labor	2025-06-01 00:16:05.981322	2025-06-01 00:16:05.981322	\N	\N
3556	215	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:05.998303	2025-06-01 00:16:05.998303	\N	\N
3557	215	\N	Maestro encofrador	hr	5.0000	18.75	labor	2025-06-01 00:16:06.015266	2025-06-01 00:16:06.015266	\N	\N
3558	215	\N	Maestro fierrista	hr	5.0000	18.75	labor	2025-06-01 00:16:06.032575	2025-06-01 00:16:06.032575	\N	\N
3559	215	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:16:06.049401	2025-06-01 00:16:06.049401	\N	\N
3560	215	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:16:06.06626	2025-06-01 00:16:06.06626	\N	\N
3561	216	\N	Acero de alta resistencia	kg	60.0000	8.50	material	2025-06-01 00:16:06.530695	2025-06-01 00:16:06.530695	\N	\N
3562	216	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:16:06.565293	2025-06-01 00:16:06.565293	\N	\N
3563	216	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:06.601983	2025-06-01 00:16:06.601983	\N	\N
3564	216	\N	Ripio chancado	m3	0.7500	230.00	material	2025-06-01 00:16:06.635844	2025-06-01 00:16:06.635844	\N	\N
3565	216	23	Clavos de 2 pulg	kg	1.5500	13.00	material	2025-06-01 00:16:06.669112	2025-06-01 00:16:06.669112	\N	\N
3566	216	13	Madera para encofrado	p2	40.0000	8.00	material	2025-06-01 00:16:06.702484	2025-06-01 00:16:06.702484	\N	\N
3567	216	\N	Alambre de amarre	kg	1.5500	11.00	material	2025-06-01 00:16:06.741968	2025-06-01 00:16:06.741968	\N	\N
3568	216	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:16:06.774984	2025-06-01 00:16:06.774984	\N	\N
3569	216	\N	Ayudante	hr	45.0000	12.50	labor	2025-06-01 00:16:06.793015	2025-06-01 00:16:06.793015	\N	\N
3570	216	\N	Maestro albañil	hr	15.0000	18.75	labor	2025-06-01 00:16:06.808737	2025-06-01 00:16:06.808737	\N	\N
3571	216	\N	Mezcladora 350 lts (1 bolsa)	hr	1.0000	30.00	equipment	2025-06-01 00:16:06.825478	2025-06-01 00:16:06.825478	\N	\N
3572	216	\N	Vibradora de inmersion	hr	1.0000	22.00	equipment	2025-06-01 00:16:06.842296	2025-06-01 00:16:06.842296	\N	\N
3573	217	\N	Acero de alta resistencia	kg	3.0000	8.50	material	2025-06-01 00:16:07.274864	2025-06-01 00:16:07.274864	\N	\N
3574	217	\N	Cemento portland IP-30	kg	35.0000	1.20	material	2025-06-01 00:16:07.309223	2025-06-01 00:16:07.309223	\N	\N
3575	217	\N	Arenilla	m3	0.0600	100.00	material	2025-06-01 00:16:07.343759	2025-06-01 00:16:07.343759	\N	\N
3576	217	\N	Ripio rodado	m3	0.0800	170.00	material	2025-06-01 00:16:07.37834	2025-06-01 00:16:07.37834	\N	\N
3577	217	\N	Alambre de amarre	kg	0.1500	11.00	material	2025-06-01 00:16:07.412978	2025-06-01 00:16:07.412978	\N	\N
3578	217	22	Agua	lt	0.1800	0.06	material	2025-06-01 00:16:07.446102	2025-06-01 00:16:07.446102	\N	\N
3579	217	\N	Ayudante	hr	1.3000	12.50	labor	2025-06-01 00:16:07.463178	2025-06-01 00:16:07.463178	\N	\N
3580	217	\N	Maestro albañil	hr	1.3000	18.75	labor	2025-06-01 00:16:07.479987	2025-06-01 00:16:07.479987	\N	\N
3581	217	\N	Mezcladora 350 lts (1 bolsa)	hr	0.1000	30.00	equipment	2025-06-01 00:16:07.496658	2025-06-01 00:16:07.496658	\N	\N
3582	217	\N	Vibradora de inmersion	hr	0.1000	22.00	equipment	2025-06-01 00:16:07.51343	2025-06-01 00:16:07.51343	\N	\N
3583	218	\N	Acero de alta resistencia	kg	2.2500	8.50	material	2025-06-01 00:16:07.961732	2025-06-01 00:16:07.961732	\N	\N
3584	218	\N	Cemento portland IP-30	kg	25.0000	1.20	material	2025-06-01 00:16:07.997019	2025-06-01 00:16:07.997019	\N	\N
3585	218	\N	Arenilla	m3	0.0500	100.00	material	2025-06-01 00:16:08.032259	2025-06-01 00:16:08.032259	\N	\N
3586	218	\N	Ripio rodado	m3	0.0600	170.00	material	2025-06-01 00:16:08.067753	2025-06-01 00:16:08.067753	\N	\N
3587	218	\N	Alambre de amarre	kg	0.1200	11.00	material	2025-06-01 00:16:08.10592	2025-06-01 00:16:08.10592	\N	\N
3588	218	22	Agua	lt	0.1800	0.06	material	2025-06-01 00:16:08.139237	2025-06-01 00:16:08.139237	\N	\N
3589	218	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:16:08.156506	2025-06-01 00:16:08.156506	\N	\N
3590	218	\N	Maestro albañil	hr	1.0000	18.75	labor	2025-06-01 00:16:08.17409	2025-06-01 00:16:08.17409	\N	\N
3591	218	\N	Mezcladora 350 lts (1 bolsa)	hr	0.1000	30.00	equipment	2025-06-01 00:16:08.190876	2025-06-01 00:16:08.190876	\N	\N
3592	218	\N	Vibradora de inmersion	hr	0.1000	22.00	equipment	2025-06-01 00:16:08.207893	2025-06-01 00:16:08.207893	\N	\N
3593	219	\N	Alquitran	kg	4.8000	12.60	material	2025-06-01 00:16:08.628989	2025-06-01 00:16:08.628989	\N	\N
3594	219	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:16:08.664652	2025-06-01 00:16:08.664652	\N	\N
3595	219	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:08.699509	2025-06-01 00:16:08.699509	\N	\N
3596	219	\N	Ripio rodado	m3	0.7500	170.00	material	2025-06-01 00:16:08.73521	2025-06-01 00:16:08.73521	\N	\N
3597	219	22	Agua	lt	180.0000	0.06	material	2025-06-01 00:16:08.770111	2025-06-01 00:16:08.770111	\N	\N
3598	219	\N	Ayudante	hr	14.0000	12.50	labor	2025-06-01 00:16:08.786805	2025-06-01 00:16:08.786805	\N	\N
3599	219	\N	Maestro albañil	hr	18.0000	18.75	labor	2025-06-01 00:16:08.803472	2025-06-01 00:16:08.803472	\N	\N
3600	219	\N	Mezcladora 350 lts (1 bolsa)	hr	0.8000	30.00	equipment	2025-06-01 00:16:08.820327	2025-06-01 00:16:08.820327	\N	\N
3601	220	\N	Acero de alta resistencia	kg	80.0000	8.50	material	2025-06-01 00:16:09.27007	2025-06-01 00:16:09.27007	\N	\N
3602	220	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:16:09.304474	2025-06-01 00:16:09.304474	\N	\N
3603	220	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:09.338875	2025-06-01 00:16:09.338875	\N	\N
3604	220	\N	Ripio chancado	m3	0.7500	230.00	material	2025-06-01 00:16:09.373246	2025-06-01 00:16:09.373246	\N	\N
3605	220	23	Clavos de 2 pulg	kg	0.7000	13.00	material	2025-06-01 00:16:09.406074	2025-06-01 00:16:09.406074	\N	\N
3606	220	13	Madera para encofrado	p2	40.0000	8.00	material	2025-06-01 00:16:09.44004	2025-06-01 00:16:09.44004	\N	\N
3607	220	\N	Alambre de amarre	kg	1.5500	11.00	material	2025-06-01 00:16:09.474239	2025-06-01 00:16:09.474239	\N	\N
3608	220	22	Agua	lt	200.0000	0.06	material	2025-06-01 00:16:09.507185	2025-06-01 00:16:09.507185	\N	\N
3609	220	\N	Ayudante	hr	45.0000	12.50	labor	2025-06-01 00:16:09.523694	2025-06-01 00:16:09.523694	\N	\N
3610	220	\N	Maestro albañil	hr	15.0000	18.75	labor	2025-06-01 00:16:09.540355	2025-06-01 00:16:09.540355	\N	\N
3611	220	\N	Mezcladora 350 lts (1 bolsa)	hr	1.0000	30.00	equipment	2025-06-01 00:16:09.556943	2025-06-01 00:16:09.556943	\N	\N
3612	220	\N	Vibradora de inmersion	hr	1.0000	22.00	equipment	2025-06-01 00:16:09.573816	2025-06-01 00:16:09.573816	\N	\N
3613	221	\N	Acero de alta resistencia	kg	80.0000	8.50	material	2025-06-01 00:16:10.129244	2025-06-01 00:16:10.129244	\N	\N
3614	221	23	Clavos de 2 pulg	kg	0.7000	13.00	material	2025-06-01 00:16:10.162247	2025-06-01 00:16:10.162247	\N	\N
3615	221	\N	Hormigón premezclado fck=210	m3	1.0000	830.00	material	2025-06-01 00:16:10.197601	2025-06-01 00:16:10.197601	\N	\N
3616	221	13	Madera para encofrado	p2	40.0000	8.00	material	2025-06-01 00:16:10.230442	2025-06-01 00:16:10.230442	\N	\N
3617	221	\N	Alambre de amarre	kg	0.2000	11.00	material	2025-06-01 00:16:10.263799	2025-06-01 00:16:10.263799	\N	\N
3618	221	\N	Ayudante	hr	30.0000	12.50	labor	2025-06-01 00:16:10.280647	2025-06-01 00:16:10.280647	\N	\N
3619	221	\N	Maestro albañil	hr	10.0000	18.75	labor	2025-06-01 00:16:10.297547	2025-06-01 00:16:10.297547	\N	\N
3620	221	\N	Vibradora de inmersion	hr	1.0000	22.00	equipment	2025-06-01 00:16:10.315271	2025-06-01 00:16:10.315271	\N	\N
3621	222	\N	Acero de alta resistencia	kg	40.0000	8.50	material	2025-06-01 00:16:10.784094	2025-06-01 00:16:10.784094	\N	\N
3622	222	\N	Cemento portland IP-30	kg	280.0000	1.20	material	2025-06-01 00:16:10.818742	2025-06-01 00:16:10.818742	\N	\N
3623	222	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:10.853533	2025-06-01 00:16:10.853533	\N	\N
3624	222	\N	Ripio rodado	m3	0.7500	170.00	material	2025-06-01 00:16:10.886739	2025-06-01 00:16:10.886739	\N	\N
3625	222	23	Clavos de 2 pulg	kg	1.5000	13.00	material	2025-06-01 00:16:10.920911	2025-06-01 00:16:10.920911	\N	\N
3626	222	13	Madera para encofrado	p2	30.0000	8.00	material	2025-06-01 00:16:10.952778	2025-06-01 00:16:10.952778	\N	\N
3627	222	\N	Alambre de amarre	kg	1.5000	11.00	material	2025-06-01 00:16:10.987072	2025-06-01 00:16:10.987072	\N	\N
3628	222	22	Agua	lt	16.0000	0.06	material	2025-06-01 00:16:11.035825	2025-06-01 00:16:11.035825	\N	\N
3629	222	\N	Ayudante	hr	22.0000	12.50	labor	2025-06-01 00:16:11.053253	2025-06-01 00:16:11.053253	\N	\N
3630	222	\N	Ayudante (encofrador)	hr	8.0000	12.50	labor	2025-06-01 00:16:11.069908	2025-06-01 00:16:11.069908	\N	\N
3631	222	\N	Ayudante (fierrista)	hr	8.0000	12.50	labor	2025-06-01 00:16:11.086559	2025-06-01 00:16:11.086559	\N	\N
3632	222	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:11.103714	2025-06-01 00:16:11.103714	\N	\N
3633	222	\N	Maestro encofrador	hr	4.0000	18.75	labor	2025-06-01 00:16:11.121224	2025-06-01 00:16:11.121224	\N	\N
3634	222	\N	Maestro fierrista	hr	4.0000	18.75	labor	2025-06-01 00:16:11.137994	2025-06-01 00:16:11.137994	\N	\N
3635	222	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:16:11.154677	2025-06-01 00:16:11.154677	\N	\N
3636	222	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:16:11.171489	2025-06-01 00:16:11.171489	\N	\N
3637	223	\N	Cemento portland IP-30	kg	150.0000	1.20	material	2025-06-01 00:16:11.60081	2025-06-01 00:16:11.60081	\N	\N
3638	223	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:11.635546	2025-06-01 00:16:11.635546	\N	\N
3639	223	\N	Ripio rodado	m3	0.8000	170.00	material	2025-06-01 00:16:11.668881	2025-06-01 00:16:11.668881	\N	\N
3640	223	13	Madera para encofrado	p2	35.0000	8.00	material	2025-06-01 00:16:11.702737	2025-06-01 00:16:11.702737	\N	\N
3641	223	22	Agua	lt	180.0000	0.06	material	2025-06-01 00:16:11.735838	2025-06-01 00:16:11.735838	\N	\N
3642	223	\N	Ayudante	hr	6.0000	12.50	labor	2025-06-01 00:16:11.751748	2025-06-01 00:16:11.751748	\N	\N
3643	223	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:11.768419	2025-06-01 00:16:11.768419	\N	\N
3644	223	\N	Mezcladora 350 lts (1 bolsa)	hr	0.8000	30.00	equipment	2025-06-01 00:16:11.785103	2025-06-01 00:16:11.785103	\N	\N
3645	223	\N	Vibradora de inmersion	hr	0.8000	22.00	equipment	2025-06-01 00:16:11.801699	2025-06-01 00:16:11.801699	\N	\N
3646	224	\N	Cemento portland IP-30	kg	145.0000	1.20	material	2025-06-01 00:16:12.228739	2025-06-01 00:16:12.228739	\N	\N
3647	224	\N	Arenilla	m3	0.4000	100.00	material	2025-06-01 00:16:12.263034	2025-06-01 00:16:12.263034	\N	\N
3648	224	\N	Ripio rodado	m3	0.8000	170.00	material	2025-06-01 00:16:12.298469	2025-06-01 00:16:12.298469	\N	\N
3649	224	13	Madera para encofrado	p2	35.0000	8.00	material	2025-06-01 00:16:12.3315	2025-06-01 00:16:12.3315	\N	\N
3650	224	22	Agua	lt	180.0000	0.06	material	2025-06-01 00:16:12.365368	2025-06-01 00:16:12.365368	\N	\N
3651	224	\N	Ayudante	hr	6.0000	12.50	labor	2025-06-01 00:16:12.382392	2025-06-01 00:16:12.382392	\N	\N
3652	224	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:12.399112	2025-06-01 00:16:12.399112	\N	\N
3653	224	\N	Mezcladora 350 lts (1 bolsa)	hr	0.8000	30.00	equipment	2025-06-01 00:16:12.415919	2025-06-01 00:16:12.415919	\N	\N
3654	224	\N	Vibradora de inmersion	hr	0.8000	22.00	equipment	2025-06-01 00:16:12.433363	2025-06-01 00:16:12.433363	\N	\N
3655	225	\N	Acero de alta resistencia	kg	85.0000	8.50	material	2025-06-01 00:16:13.011438	2025-06-01 00:16:13.011438	\N	\N
3656	225	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:16:13.046757	2025-06-01 00:16:13.046757	\N	\N
3657	225	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:13.081216	2025-06-01 00:16:13.081216	\N	\N
3658	225	\N	Ripio chancado	m3	0.7500	230.00	material	2025-06-01 00:16:13.116754	2025-06-01 00:16:13.116754	\N	\N
3659	225	23	Clavos de 2 pulg	kg	1.5500	13.00	material	2025-06-01 00:16:13.149863	2025-06-01 00:16:13.149863	\N	\N
3660	225	13	Madera para encofrado	p2	60.0000	8.00	material	2025-06-01 00:16:13.182634	2025-06-01 00:16:13.182634	\N	\N
3661	225	\N	Alambre de amarre	kg	1.5500	11.00	material	2025-06-01 00:16:13.223982	2025-06-01 00:16:13.223982	\N	\N
3662	225	22	Agua	lt	200.0000	0.06	material	2025-06-01 00:16:13.261407	2025-06-01 00:16:13.261407	\N	\N
3663	225	\N	Ayudante	hr	22.0000	12.50	labor	2025-06-01 00:16:13.278495	2025-06-01 00:16:13.278495	\N	\N
3664	225	\N	Ayudante (encofrador)	hr	12.0000	12.50	labor	2025-06-01 00:16:13.295164	2025-06-01 00:16:13.295164	\N	\N
3665	225	\N	Ayudante (fierrista)	hr	12.0000	12.50	labor	2025-06-01 00:16:13.311889	2025-06-01 00:16:13.311889	\N	\N
3666	225	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:13.328804	2025-06-01 00:16:13.328804	\N	\N
3667	225	\N	Maestro encofrador	hr	5.0000	18.75	labor	2025-06-01 00:16:13.347274	2025-06-01 00:16:13.347274	\N	\N
3668	225	\N	Maestro fierrista	hr	5.0000	18.75	labor	2025-06-01 00:16:13.372465	2025-06-01 00:16:13.372465	\N	\N
3669	225	\N	Guinche	hr	1.2000	42.00	equipment	2025-06-01 00:16:13.389097	2025-06-01 00:16:13.389097	\N	\N
3670	225	\N	Mezcladora 350 lts (1 bolsa)	hr	1.2000	30.00	equipment	2025-06-01 00:16:13.405783	2025-06-01 00:16:13.405783	\N	\N
3671	225	\N	Vibradora de inmersion	hr	1.2000	22.00	equipment	2025-06-01 00:16:13.42309	2025-06-01 00:16:13.42309	\N	\N
3672	226	\N	Acero de alta resistencia	kg	85.0000	8.50	material	2025-06-01 00:16:13.888004	2025-06-01 00:16:13.888004	\N	\N
3673	226	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:16:13.924445	2025-06-01 00:16:13.924445	\N	\N
3674	226	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:13.958667	2025-06-01 00:16:13.958667	\N	\N
3675	226	\N	Ripio chancado	m3	0.7500	230.00	material	2025-06-01 00:16:13.993103	2025-06-01 00:16:13.993103	\N	\N
3676	226	23	Clavos de 2 pulg	kg	1.5500	13.00	material	2025-06-01 00:16:14.026086	2025-06-01 00:16:14.026086	\N	\N
3677	226	13	Madera para encofrado	p2	60.0000	8.00	material	2025-06-01 00:16:14.058964	2025-06-01 00:16:14.058964	\N	\N
3678	226	\N	Alambre de amarre	kg	1.5500	11.00	material	2025-06-01 00:16:14.093789	2025-06-01 00:16:14.093789	\N	\N
3679	226	22	Agua	lt	200.0000	0.06	material	2025-06-01 00:16:14.127044	2025-06-01 00:16:14.127044	\N	\N
3680	226	\N	Ayudante	hr	22.0000	12.50	labor	2025-06-01 00:16:14.144225	2025-06-01 00:16:14.144225	\N	\N
3681	226	\N	Ayudante (encofrador)	hr	12.0000	12.50	labor	2025-06-01 00:16:14.161041	2025-06-01 00:16:14.161041	\N	\N
3682	226	\N	Ayudante (fierrista)	hr	12.0000	12.50	labor	2025-06-01 00:16:14.177877	2025-06-01 00:16:14.177877	\N	\N
3683	226	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:14.194508	2025-06-01 00:16:14.194508	\N	\N
3684	226	\N	Maestro encofrador	hr	5.0000	18.75	labor	2025-06-01 00:16:14.211433	2025-06-01 00:16:14.211433	\N	\N
3685	226	\N	Maestro fierrista	hr	5.0000	18.75	labor	2025-06-01 00:16:14.228135	2025-06-01 00:16:14.228135	\N	\N
3686	226	\N	Guinche	hr	1.2000	42.00	equipment	2025-06-01 00:16:14.245026	2025-06-01 00:16:14.245026	\N	\N
3687	226	\N	Mezcladora 350 lts (1 bolsa)	hr	1.2000	30.00	equipment	2025-06-01 00:16:14.261792	2025-06-01 00:16:14.261792	\N	\N
3688	226	\N	Vibradora de inmersion	hr	1.2000	22.00	equipment	2025-06-01 00:16:14.27861	2025-06-01 00:16:14.27861	\N	\N
3689	227	\N	Acero de alta resistencia	kg	80.0000	8.50	material	2025-06-01 00:16:14.882487	2025-06-01 00:16:14.882487	\N	\N
3690	227	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:16:14.917009	2025-06-01 00:16:14.917009	\N	\N
3691	227	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:14.952412	2025-06-01 00:16:14.952412	\N	\N
3692	227	\N	Ripio chancado	m3	0.7500	230.00	material	2025-06-01 00:16:14.98679	2025-06-01 00:16:14.98679	\N	\N
3693	227	23	Clavos de 2 pulg	kg	1.7000	13.00	material	2025-06-01 00:16:15.019753	2025-06-01 00:16:15.019753	\N	\N
3694	227	\N	Sika-1	lt	20.0000	18.00	material	2025-06-01 00:16:15.055291	2025-06-01 00:16:15.055291	\N	\N
3695	227	13	Madera para encofrado	p2	80.0000	8.00	material	2025-06-01 00:16:15.088954	2025-06-01 00:16:15.088954	\N	\N
3696	227	\N	Alambre de amarre	kg	1.7000	11.00	material	2025-06-01 00:16:15.123875	2025-06-01 00:16:15.123875	\N	\N
3697	227	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:16:15.162408	2025-06-01 00:16:15.162408	\N	\N
3698	227	\N	Ayudante	hr	45.0000	12.50	labor	2025-06-01 00:16:15.179025	2025-06-01 00:16:15.179025	\N	\N
3699	227	\N	Maestro albañil	hr	15.0000	18.75	labor	2025-06-01 00:16:15.196579	2025-06-01 00:16:15.196579	\N	\N
3700	227	\N	Mezcladora 350 lts (1 bolsa)	hr	1.0000	30.00	equipment	2025-06-01 00:16:15.2131	2025-06-01 00:16:15.2131	\N	\N
3701	227	\N	Vibradora de inmersion	hr	1.0000	22.00	equipment	2025-06-01 00:16:15.229551	2025-06-01 00:16:15.229551	\N	\N
3702	228	\N	Acero de alta resistencia	kg	75.0000	8.50	material	2025-06-01 00:16:15.695879	2025-06-01 00:16:15.695879	\N	\N
3703	228	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:16:15.731208	2025-06-01 00:16:15.731208	\N	\N
3704	228	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:15.765294	2025-06-01 00:16:15.765294	\N	\N
3705	228	\N	Ripio chancado	m3	0.7500	230.00	material	2025-06-01 00:16:15.79949	2025-06-01 00:16:15.79949	\N	\N
3706	228	23	Clavos de 2 pulg	kg	1.0000	13.00	material	2025-06-01 00:16:15.832353	2025-06-01 00:16:15.832353	\N	\N
3707	228	13	Madera para encofrado	p2	35.0000	8.00	material	2025-06-01 00:16:15.866049	2025-06-01 00:16:15.866049	\N	\N
3708	228	\N	Alambre de amarre	kg	1.0000	11.00	material	2025-06-01 00:16:15.901147	2025-06-01 00:16:15.901147	\N	\N
3709	228	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:16:15.93312	2025-06-01 00:16:15.93312	\N	\N
3710	228	\N	Ayudante	hr	42.0000	12.50	labor	2025-06-01 00:16:15.952199	2025-06-01 00:16:15.952199	\N	\N
3711	228	\N	Maestro albañil	hr	14.0000	18.75	labor	2025-06-01 00:16:15.968923	2025-06-01 00:16:15.968923	\N	\N
3712	228	\N	Mezcladora 350 lts (1 bolsa)	hr	1.0000	30.00	equipment	2025-06-01 00:16:15.985493	2025-06-01 00:16:15.985493	\N	\N
3713	228	\N	Vibradora de inmersion	hr	1.0000	22.00	equipment	2025-06-01 00:16:16.002338	2025-06-01 00:16:16.002338	\N	\N
3714	229	\N	Acero de alta resistencia	kg	120.0000	8.50	material	2025-06-01 00:16:16.501326	2025-06-01 00:16:16.501326	\N	\N
3715	229	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:16:16.535363	2025-06-01 00:16:16.535363	\N	\N
3716	229	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:16.569623	2025-06-01 00:16:16.569623	\N	\N
3717	229	\N	Ripio rodado	m3	0.7500	170.00	material	2025-06-01 00:16:16.604312	2025-06-01 00:16:16.604312	\N	\N
3718	229	23	Clavos de 2 pulg	kg	1.5000	13.00	material	2025-06-01 00:16:16.637906	2025-06-01 00:16:16.637906	\N	\N
3719	229	13	Madera para encofrado	p2	60.0000	8.00	material	2025-06-01 00:16:16.670979	2025-06-01 00:16:16.670979	\N	\N
3720	229	\N	Alambre de amarre	kg	1.5000	11.00	material	2025-06-01 00:16:16.705813	2025-06-01 00:16:16.705813	\N	\N
3721	229	22	Agua	lt	16.0000	0.06	material	2025-06-01 00:16:16.739814	2025-06-01 00:16:16.739814	\N	\N
3722	229	\N	Ayudante	hr	25.0000	12.50	labor	2025-06-01 00:16:16.759344	2025-06-01 00:16:16.759344	\N	\N
3723	229	\N	Ayudante (encofrador)	hr	10.0000	12.50	labor	2025-06-01 00:16:16.776125	2025-06-01 00:16:16.776125	\N	\N
3724	229	\N	Ayudante (fierrista)	hr	10.0000	12.50	labor	2025-06-01 00:16:16.794042	2025-06-01 00:16:16.794042	\N	\N
3725	229	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:16.81054	2025-06-01 00:16:16.81054	\N	\N
3726	229	\N	Maestro encofrador	hr	5.0000	18.75	labor	2025-06-01 00:16:16.830372	2025-06-01 00:16:16.830372	\N	\N
3727	229	\N	Maestro fierrista	hr	5.0000	18.75	labor	2025-06-01 00:16:16.847261	2025-06-01 00:16:16.847261	\N	\N
3728	229	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:16:16.863914	2025-06-01 00:16:16.863914	\N	\N
3729	229	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:16:16.880532	2025-06-01 00:16:16.880532	\N	\N
3730	230	\N	Acero de alta resistencia	kg	110.0000	8.50	material	2025-06-01 00:16:17.376576	2025-06-01 00:16:17.376576	\N	\N
3731	230	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:16:17.411203	2025-06-01 00:16:17.411203	\N	\N
3732	230	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:17.446404	2025-06-01 00:16:17.446404	\N	\N
3733	230	\N	Ripio rodado	m3	0.7500	170.00	material	2025-06-01 00:16:17.480896	2025-06-01 00:16:17.480896	\N	\N
3734	230	23	Clavos de 2 pulg	kg	1.5000	13.00	material	2025-06-01 00:16:17.514168	2025-06-01 00:16:17.514168	\N	\N
3735	230	13	Madera para encofrado	p2	60.0000	8.00	material	2025-06-01 00:16:17.547643	2025-06-01 00:16:17.547643	\N	\N
3736	230	\N	Alambre de amarre	kg	1.5000	11.00	material	2025-06-01 00:16:17.581995	2025-06-01 00:16:17.581995	\N	\N
3737	230	22	Agua	lt	16.0000	0.06	material	2025-06-01 00:16:17.614804	2025-06-01 00:16:17.614804	\N	\N
3738	230	\N	Ayudante	hr	25.0000	12.50	labor	2025-06-01 00:16:17.632233	2025-06-01 00:16:17.632233	\N	\N
3739	230	\N	Ayudante (encofrador)	hr	10.0000	12.50	labor	2025-06-01 00:16:17.649581	2025-06-01 00:16:17.649581	\N	\N
3740	230	\N	Ayudante (fierrista)	hr	10.0000	12.50	labor	2025-06-01 00:16:17.666128	2025-06-01 00:16:17.666128	\N	\N
3741	230	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:17.682945	2025-06-01 00:16:17.682945	\N	\N
3742	230	\N	Maestro encofrador	hr	5.0000	18.75	labor	2025-06-01 00:16:17.699494	2025-06-01 00:16:17.699494	\N	\N
3743	230	\N	Maestro fierrista	hr	5.0000	18.75	labor	2025-06-01 00:16:17.716698	2025-06-01 00:16:17.716698	\N	\N
3744	230	\N	Guinche	hr	1.0000	42.00	equipment	2025-06-01 00:16:17.733313	2025-06-01 00:16:17.733313	\N	\N
3745	230	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:16:17.750426	2025-06-01 00:16:17.750426	\N	\N
3746	230	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:16:17.767272	2025-06-01 00:16:17.767272	\N	\N
3747	231	\N	Acero de alta resistencia	kg	110.0000	8.50	material	2025-06-01 00:16:18.221029	2025-06-01 00:16:18.221029	\N	\N
3748	231	23	Clavos de 2 pulg	kg	1.5000	13.00	material	2025-06-01 00:16:18.253725	2025-06-01 00:16:18.253725	\N	\N
3749	231	\N	Hormigón premezclado fck=210	m3	1.0000	830.00	material	2025-06-01 00:16:18.288559	2025-06-01 00:16:18.288559	\N	\N
3750	231	13	Madera para encofrado	p2	60.0000	8.00	material	2025-06-01 00:16:18.321416	2025-06-01 00:16:18.321416	\N	\N
3751	231	\N	Alambre de amarre	kg	1.5000	11.00	material	2025-06-01 00:16:18.356276	2025-06-01 00:16:18.356276	\N	\N
3752	231	\N	Ayudante	hr	22.0000	12.50	labor	2025-06-01 00:16:18.373252	2025-06-01 00:16:18.373252	\N	\N
3753	231	\N	Ayudante (encofrador)	hr	12.0000	12.50	labor	2025-06-01 00:16:18.391704	2025-06-01 00:16:18.391704	\N	\N
3754	231	\N	Ayudante (fierrista)	hr	12.0000	12.50	labor	2025-06-01 00:16:18.412374	2025-06-01 00:16:18.412374	\N	\N
3755	231	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:18.42992	2025-06-01 00:16:18.42992	\N	\N
3756	231	\N	Maestro encofrador	hr	5.0000	18.75	labor	2025-06-01 00:16:18.446618	2025-06-01 00:16:18.446618	\N	\N
3757	231	\N	Maestro fierrista	hr	5.0000	18.75	labor	2025-06-01 00:16:18.464268	2025-06-01 00:16:18.464268	\N	\N
3758	231	\N	Guinche	hr	1.0000	42.00	equipment	2025-06-01 00:16:18.481214	2025-06-01 00:16:18.481214	\N	\N
3759	231	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:16:18.497895	2025-06-01 00:16:18.497895	\N	\N
3760	232	\N	Acero de alta resistencia	kg	50.0000	8.50	material	2025-06-01 00:16:19.127135	2025-06-01 00:16:19.127135	\N	\N
3761	232	\N	Cemento portland IP-30	kg	280.0000	1.20	material	2025-06-01 00:16:19.160467	2025-06-01 00:16:19.160467	\N	\N
3762	232	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:19.194613	2025-06-01 00:16:19.194613	\N	\N
3763	232	\N	Ripio rodado	m3	0.7500	170.00	material	2025-06-01 00:16:19.228778	2025-06-01 00:16:19.228778	\N	\N
3764	232	23	Clavos de 2 pulg	kg	1.5000	13.00	material	2025-06-01 00:16:19.262264	2025-06-01 00:16:19.262264	\N	\N
3911	256	\N	Disyuntor térmico de 40A	pza	1.0000	29.00	material	2025-06-01 00:16:32.635496	2025-06-01 00:16:32.635496	\N	\N
3912	256	\N	Maestro electricista	hr	0.2000	15.00	labor	2025-06-01 00:16:32.652286	2025-06-01 00:16:32.652286	\N	\N
3913	257	\N	Disyuntor trifásico de 150A	pza	1.0000	364.80	material	2025-06-01 00:16:33.033794	2025-06-01 00:16:33.033794	\N	\N
3914	257	\N	Ayudante (electricista)	hr	1.0000	12.50	labor	2025-06-01 00:16:33.050639	2025-06-01 00:16:33.050639	\N	\N
3915	257	\N	Maestro electricista	hr	2.0000	15.00	labor	2025-06-01 00:16:33.067282	2025-06-01 00:16:33.067282	\N	\N
3916	258	\N	Disyuntor trifásico de 30A	pza	1.0000	152.00	material	2025-06-01 00:16:33.460746	2025-06-01 00:16:33.460746	\N	\N
3917	258	\N	Ayudante (electricista)	hr	1.0000	12.50	labor	2025-06-01 00:16:33.480024	2025-06-01 00:16:33.480024	\N	\N
3918	258	\N	Maestro electricista	hr	2.0000	15.00	labor	2025-06-01 00:16:33.497566	2025-06-01 00:16:33.497566	\N	\N
3919	259	\N	Disyuntor trifásico de 60A	pza	1.0000	182.40	material	2025-06-01 00:16:33.863458	2025-06-01 00:16:33.863458	\N	\N
3920	259	\N	Maestro electricista	hr	2.0000	15.00	labor	2025-06-01 00:16:33.88013	2025-06-01 00:16:33.88013	\N	\N
3921	260	\N	Alambre aislado 1.5mm2 (#14)	ml	10.0000	2.08	material	2025-06-01 00:16:34.266749	2025-06-01 00:16:34.266749	\N	\N
3922	260	\N	Alambre aislado 2.5mm2 (#12)	ml	10.0000	3.23	material	2025-06-01 00:16:34.301202	2025-06-01 00:16:34.301202	\N	\N
3923	260	\N	Cinta aislante	pza	0.1500	6.00	material	2025-06-01 00:16:34.335431	2025-06-01 00:16:34.335431	\N	\N
3924	260	\N	Medidor de flujo eléctrico	pza	1.0000	2.00	material	2025-06-01 00:16:34.371126	2025-06-01 00:16:34.371126	\N	\N
3925	260	\N	Maestro electricista	hr	2.0000	15.00	labor	2025-06-01 00:16:34.388007	2025-06-01 00:16:34.388007	\N	\N
3926	261	\N	Pegante para PVC	lt	0.1500	35.00	material	2025-06-01 00:16:34.768274	2025-06-01 00:16:34.768274	\N	\N
3927	261	\N	Alambre aislado 1.5mm2 (#14)	ml	10.0000	2.08	material	2025-06-01 00:16:34.803599	2025-06-01 00:16:34.803599	\N	\N
3928	261	\N	Alambre aislado 2.5mm2 (#12)	ml	10.0000	3.23	material	2025-06-01 00:16:34.839554	2025-06-01 00:16:34.839554	\N	\N
3929	261	\N	Caja plástica pvc 2x4	pza	1.0000	5.00	material	2025-06-01 00:16:34.874309	2025-06-01 00:16:34.874309	\N	\N
3930	261	\N	Cinta aislante	pza	0.1500	6.00	material	2025-06-01 00:16:34.908946	2025-06-01 00:16:34.908946	\N	\N
3931	261	\N	Tubo Berman de 3/4 pulg	ml	4.0000	5.00	material	2025-06-01 00:16:34.943327	2025-06-01 00:16:34.943327	\N	\N
3932	261	\N	Tubo Berman de 5/8 pulg	ml	3.0000	2.00	material	2025-06-01 00:16:34.978097	2025-06-01 00:16:34.978097	\N	\N
3933	261	\N	Maestro electricista	hr	2.0000	15.00	labor	2025-06-01 00:16:34.998038	2025-06-01 00:16:34.998038	\N	\N
3934	262	\N	Cable Multifilar P/ Tierra De 2.5mm	ml	7.0000	2.60	material	2025-06-01 00:16:35.373279	2025-06-01 00:16:35.373279	\N	\N
3935	262	\N	Politubo De 1/2"	ml	5.0000	2.00	material	2025-06-01 00:16:35.407485	2025-06-01 00:16:35.407485	\N	\N
3936	262	\N	Jabalina De Cobre	pza	1.0000	60.00	material	2025-06-01 00:16:35.441925	2025-06-01 00:16:35.441925	\N	\N
3937	262	\N	Ayudante (electricista)	hr	3.0000	12.50	labor	2025-06-01 00:16:35.45889	2025-06-01 00:16:35.45889	\N	\N
3938	262	\N	Maestro electricista	hr	3.0000	15.00	labor	2025-06-01 00:16:35.476286	2025-06-01 00:16:35.476286	\N	\N
3939	263	\N	Cemento portland IP-30	kg	10.0000	1.20	material	2025-06-01 00:16:35.880746	2025-06-01 00:16:35.880746	\N	\N
3940	263	\N	Arenilla	m3	0.0600	100.00	material	2025-06-01 00:16:35.91523	2025-06-01 00:16:35.91523	\N	\N
3941	263	\N	Ripio rodado	m3	0.6000	170.00	material	2025-06-01 00:16:35.949574	2025-06-01 00:16:35.949574	\N	\N
3942	263	\N	Barra de Cu de 40mm2	pza	1.0000	25.00	material	2025-06-01 00:16:35.984555	2025-06-01 00:16:35.984555	\N	\N
3943	263	\N	Bastón de 3/4	pza	1.0000	60.80	material	2025-06-01 00:16:36.019387	2025-06-01 00:16:36.019387	\N	\N
3944	263	\N	Caja metálica para medidor	pza	1.0000	50.00	material	2025-06-01 00:16:36.054134	2025-06-01 00:16:36.054134	\N	\N
3945	263	\N	Pilastra prefabricada para medidor monofásico	pza	1.0000	400.00	material	2025-06-01 00:16:36.089062	2025-06-01 00:16:36.089062	\N	\N
3946	263	\N	Disyuntor termico de 50A	pza	1.0000	28.74	material	2025-06-01 00:16:36.122301	2025-06-01 00:16:36.122301	\N	\N
3947	263	\N	Maestro albañil	hr	4.0000	18.75	labor	2025-06-01 00:16:36.140681	2025-06-01 00:16:36.140681	\N	\N
3948	263	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:36.157764	2025-06-01 00:16:36.157764	\N	\N
3949	264	\N	Cemento portland IP-30	kg	20.0000	1.20	material	2025-06-01 00:16:36.636918	2025-06-01 00:16:36.636918	\N	\N
3950	264	\N	Arenilla	m3	0.0800	100.00	material	2025-06-01 00:16:36.671232	2025-06-01 00:16:36.671232	\N	\N
3951	264	\N	Piedra bola	m3	0.1500	192.00	material	2025-06-01 00:16:36.705445	2025-06-01 00:16:36.705445	\N	\N
3952	264	\N	Ripio rodado	m3	0.1100	170.00	material	2025-06-01 00:16:36.739746	2025-06-01 00:16:36.739746	\N	\N
3953	264	\N	Pilastra prefabricada para medidor monofásico	pza	1.0000	400.00	material	2025-06-01 00:16:36.774631	2025-06-01 00:16:36.774631	\N	\N
3954	264	\N	Ayudante	hr	6.0000	12.50	labor	2025-06-01 00:16:36.791289	2025-06-01 00:16:36.791289	\N	\N
3955	264	\N	Maestro albañil	hr	6.0000	18.75	labor	2025-06-01 00:16:36.808218	2025-06-01 00:16:36.808218	\N	\N
3956	265	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:37.190454	2025-06-01 00:16:37.190454	\N	\N
3957	265	\N	Caja plástica pvc 2x4	pza	1.0000	5.00	material	2025-06-01 00:16:37.225519	2025-06-01 00:16:37.225519	\N	\N
3958	265	\N	Caja plástica pvc 4x4	pza	1.0000	8.00	material	2025-06-01 00:16:37.263706	2025-06-01 00:16:37.263706	\N	\N
3959	265	\N	Cinta aislante	pza	1.0000	6.00	material	2025-06-01 00:16:37.298391	2025-06-01 00:16:37.298391	\N	\N
3960	265	\N	Multipar (para 2 pares)	ml	30.0000	2.19	material	2025-06-01 00:16:37.333129	2025-06-01 00:16:37.333129	\N	\N
3961	265	\N	Portero eléctrico de vivienda	pza	1.0000	384.00	material	2025-06-01 00:16:37.367657	2025-06-01 00:16:37.367657	\N	\N
3962	265	\N	Tubo Berman de 3/4 pulg	ml	30.0000	5.00	material	2025-06-01 00:16:37.402889	2025-06-01 00:16:37.402889	\N	\N
3963	265	\N	Capataz	hr	0.5000	18.75	labor	2025-06-01 00:16:37.419792	2025-06-01 00:16:37.419792	\N	\N
3964	265	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:37.435826	2025-06-01 00:16:37.435826	\N	\N
3965	266	\N	Alambre de cobre desnudo #2	ml	12.0000	3.00	material	2025-06-01 00:16:37.807734	2025-06-01 00:16:37.807734	\N	\N
3966	266	\N	Jabalina cooper weld	pza	1.0000	62.00	material	2025-06-01 00:16:37.840826	2025-06-01 00:16:37.840826	\N	\N
3967	266	\N	Tubo Berman de 1 pulg	ml	12.0000	4.50	material	2025-06-01 00:16:37.875088	2025-06-01 00:16:37.875088	\N	\N
3968	266	\N	Maestro electricista	hr	8.0000	15.00	labor	2025-06-01 00:16:37.891737	2025-06-01 00:16:37.891737	\N	\N
3969	267	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:38.308334	2025-06-01 00:16:38.308334	\N	\N
3970	267	\N	Alambre aislado 1.5mm2 (#14)	ml	1.0000	2.08	material	2025-06-01 00:16:38.343481	2025-06-01 00:16:38.343481	\N	\N
3971	267	\N	Caja plástica pvc 4x4	pza	1.0000	8.00	material	2025-06-01 00:16:38.384768	2025-06-01 00:16:38.384768	\N	\N
3972	267	\N	Cinta aislante	pza	0.1500	6.00	material	2025-06-01 00:16:38.419488	2025-06-01 00:16:38.419488	\N	\N
3973	267	\N	Foco incandescente 60 W	pza	1.0000	3.00	material	2025-06-01 00:16:38.45534	2025-06-01 00:16:38.45534	\N	\N
3974	267	\N	Interruptor comun simple	pza	1.0000	32.00	material	2025-06-01 00:16:38.520652	2025-06-01 00:16:38.520652	\N	\N
3975	267	\N	Tubo Berman de 3/4 pulg	ml	1.0000	5.00	material	2025-06-01 00:16:38.556525	2025-06-01 00:16:38.556525	\N	\N
3976	267	\N	Zoquete de colgar común	pza	1.0000	3.00	material	2025-06-01 00:16:38.59218	2025-06-01 00:16:38.59218	\N	\N
3977	267	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:38.608839	2025-06-01 00:16:38.608839	\N	\N
3978	268	\N	Pantalla para un tubo fluorescente	pza	1.0000	91.20	material	2025-06-01 00:16:39.102195	2025-06-01 00:16:39.102195	\N	\N
3979	268	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:39.136563	2025-06-01 00:16:39.136563	\N	\N
3980	268	\N	Alambre aislado 1.5mm2 (#14)	ml	2.0000	2.08	material	2025-06-01 00:16:39.173996	2025-06-01 00:16:39.173996	\N	\N
3981	268	\N	Caja plástica pvc 4x4	pza	1.0000	8.00	material	2025-06-01 00:16:39.207255	2025-06-01 00:16:39.207255	\N	\N
3982	268	\N	Cinta aislante	pza	0.1500	6.00	material	2025-06-01 00:16:39.241919	2025-06-01 00:16:39.241919	\N	\N
3983	268	\N	Tubo Berman de 3/4 pulg	ml	1.0000	5.00	material	2025-06-01 00:16:39.276174	2025-06-01 00:16:39.276174	\N	\N
3984	268	\N	Tubo fluorescente 40 W	pza	1.0000	65.00	material	2025-06-01 00:16:39.309743	2025-06-01 00:16:39.309743	\N	\N
3985	268	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:39.326493	2025-06-01 00:16:39.326493	\N	\N
3986	269	\N	Pantalla para un tubo fluorescente	pza	1.0000	91.20	material	2025-06-01 00:16:39.706599	2025-06-01 00:16:39.706599	\N	\N
3987	269	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:39.740963	2025-06-01 00:16:39.740963	\N	\N
3988	269	\N	Alambre aislado 1.5mm2 (#14)	ml	2.0000	2.08	material	2025-06-01 00:16:39.776138	2025-06-01 00:16:39.776138	\N	\N
3989	269	\N	Caja plástica pvc 4x4	pza	1.0000	8.00	material	2025-06-01 00:16:39.810743	2025-06-01 00:16:39.810743	\N	\N
3990	269	\N	Cinta aislante	pza	0.1500	6.00	material	2025-06-01 00:16:39.84638	2025-06-01 00:16:39.84638	\N	\N
3991	269	\N	Tubo Berman de 3/4 pulg	ml	1.0000	5.00	material	2025-06-01 00:16:39.880953	2025-06-01 00:16:39.880953	\N	\N
3992	269	\N	Tubo fluorescente 20 W	pza	1.0000	91.20	material	2025-06-01 00:16:39.915381	2025-06-01 00:16:39.915381	\N	\N
3993	269	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:39.932405	2025-06-01 00:16:39.932405	\N	\N
3994	270	\N	Pantalla para dos tubos fluorescentes	pza	1.0000	120.00	material	2025-06-01 00:16:40.320971	2025-06-01 00:16:40.320971	\N	\N
3995	270	\N	Alambre aislado 1.5mm2 (#14)	ml	2.0000	2.08	material	2025-06-01 00:16:40.356187	2025-06-01 00:16:40.356187	\N	\N
3996	270	\N	Cinta aislante	pza	0.1500	6.00	material	2025-06-01 00:16:40.390646	2025-06-01 00:16:40.390646	\N	\N
3997	270	\N	Interruptor comun simple	pza	2.0000	32.00	material	2025-06-01 00:16:40.425202	2025-06-01 00:16:40.425202	\N	\N
3998	270	\N	Tubo fluorescente 40 W	pza	2.0000	65.00	material	2025-06-01 00:16:40.46094	2025-06-01 00:16:40.46094	\N	\N
3999	270	\N	Maestro electricista	hr	3.0000	15.00	labor	2025-06-01 00:16:40.477672	2025-06-01 00:16:40.477672	\N	\N
4000	271	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:40.88075	2025-06-01 00:16:40.88075	\N	\N
4001	271	\N	Alambre aislado 4mm2 (#10)	ml	15.0000	4.00	material	2025-06-01 00:16:40.917885	2025-06-01 00:16:40.917885	\N	\N
4002	271	\N	Caja para un térmico	pza	1.0000	21.00	material	2025-06-01 00:16:40.952423	2025-06-01 00:16:40.952423	\N	\N
4003	271	\N	Caja plástica pvc 2x4	pza	1.0000	5.00	material	2025-06-01 00:16:40.98714	2025-06-01 00:16:40.98714	\N	\N
4004	271	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:41.022005	2025-06-01 00:16:41.022005	\N	\N
4005	271	\N	Disyuntor 1x20A	pza	1.0000	25.00	material	2025-06-01 00:16:41.056467	2025-06-01 00:16:41.056467	\N	\N
4006	271	\N	Tubo Berman de 3/4 pulg	ml	6.0000	5.00	material	2025-06-01 00:16:41.090765	2025-06-01 00:16:41.090765	\N	\N
4007	271	\N	Maestro electricista	hr	3.0000	15.00	labor	2025-06-01 00:16:41.107669	2025-06-01 00:16:41.107669	\N	\N
4008	272	\N	Alambre aislado 2.5mm2 (#12)	ml	2.0000	3.23	material	2025-06-01 00:16:41.516709	2025-06-01 00:16:41.516709	\N	\N
4009	272	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:41.551435	2025-06-01 00:16:41.551435	\N	\N
4010	272	\N	Placa tomacorriente simple	pza	1.0000	25.00	material	2025-06-01 00:16:41.586306	2025-06-01 00:16:41.586306	\N	\N
4011	272	\N	Maestro electricista	hr	3.0000	15.00	labor	2025-06-01 00:16:41.603433	2025-06-01 00:16:41.603433	\N	\N
4012	273	\N	Alambre aislado 2.5mm2 (#12)	ml	5.0000	3.23	material	2025-06-01 00:16:41.979591	2025-06-01 00:16:41.979591	\N	\N
4013	273	\N	Caja plástica pvc 2x4	pza	1.0000	5.00	material	2025-06-01 00:16:42.014361	2025-06-01 00:16:42.014361	\N	\N
4014	273	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:42.049132	2025-06-01 00:16:42.049132	\N	\N
4015	273	\N	Placa tomacorriente doble	pza	1.0000	29.00	material	2025-06-01 00:16:42.084444	2025-06-01 00:16:42.084444	\N	\N
4016	273	\N	Tubo Berman de 3/4 pulg	ml	5.0000	5.00	material	2025-06-01 00:16:42.118851	2025-06-01 00:16:42.118851	\N	\N
4017	273	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:42.135728	2025-06-01 00:16:42.135728	\N	\N
4018	274	\N	Alambre aislado 2.5mm2 (#12)	ml	2.0000	3.23	material	2025-06-01 00:16:42.503434	2025-06-01 00:16:42.503434	\N	\N
4019	274	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:42.53817	2025-06-01 00:16:42.53817	\N	\N
4020	274	\N	Placa tomacorriente doble para computadora	pza	1.0000	36.48	material	2025-06-01 00:16:42.573103	2025-06-01 00:16:42.573103	\N	\N
4021	274	\N	Maestro electricista	hr	3.0000	15.00	labor	2025-06-01 00:16:42.589683	2025-06-01 00:16:42.589683	\N	\N
4022	275	\N	Alambre aislado 4mm2 (#10)	ml	2.0000	4.00	material	2025-06-01 00:16:42.962423	2025-06-01 00:16:42.962423	\N	\N
4023	275	\N	Caja para un térmico	pza	1.0000	21.00	material	2025-06-01 00:16:42.996929	2025-06-01 00:16:42.996929	\N	\N
4024	275	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:43.032557	2025-06-01 00:16:43.032557	\N	\N
4025	275	\N	Disyuntor 1x20A	pza	1.0000	25.00	material	2025-06-01 00:16:43.067277	2025-06-01 00:16:43.067277	\N	\N
4026	275	\N	Maestro electricista	hr	3.0000	15.00	labor	2025-06-01 00:16:43.08422	2025-06-01 00:16:43.08422	\N	\N
4027	276	\N	Alambre aislado 4mm2 (#10)	ml	2.0000	4.00	material	2025-06-01 00:16:43.47019	2025-06-01 00:16:43.47019	\N	\N
4028	276	\N	Caja para un térmico	pza	1.0000	21.00	material	2025-06-01 00:16:43.504763	2025-06-01 00:16:43.504763	\N	\N
4029	276	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:43.539933	2025-06-01 00:16:43.539933	\N	\N
4030	276	\N	Disyuntor 1x20A	pza	1.0000	25.00	material	2025-06-01 00:16:43.574672	2025-06-01 00:16:43.574672	\N	\N
4031	276	\N	Maestro electricista	hr	3.0000	15.00	labor	2025-06-01 00:16:43.591321	2025-06-01 00:16:43.591321	\N	\N
4032	277	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:43.967693	2025-06-01 00:16:43.967693	\N	\N
4033	277	\N	Alambre bipolar para telefono	ml	15.0000	2.60	material	2025-06-01 00:16:44.00246	2025-06-01 00:16:44.00246	\N	\N
4034	277	\N	Caja plástica pvc 2x4	pza	1.0000	5.00	material	2025-06-01 00:16:44.035725	2025-06-01 00:16:44.035725	\N	\N
4035	277	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:44.072242	2025-06-01 00:16:44.072242	\N	\N
4036	277	\N	Intercomunicador	pza	1.0000	94.00	material	2025-06-01 00:16:44.107014	2025-06-01 00:16:44.107014	\N	\N
4037	277	\N	Tubo Berman de 3/4 pulg	ml	6.0000	5.00	material	2025-06-01 00:16:44.185791	2025-06-01 00:16:44.185791	\N	\N
4038	277	\N	Maestro electricista	hr	1.6000	15.00	labor	2025-06-01 00:16:44.202876	2025-06-01 00:16:44.202876	\N	\N
4039	278	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:44.598253	2025-06-01 00:16:44.598253	\N	\N
4040	278	\N	Cable coaxial 75 ohms	ml	10.0000	4.44	material	2025-06-01 00:16:44.632886	2025-06-01 00:16:44.632886	\N	\N
4041	278	\N	Caja plástica pvc 2x4	pza	1.0000	5.00	material	2025-06-01 00:16:44.668289	2025-06-01 00:16:44.668289	\N	\N
4042	278	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:44.702639	2025-06-01 00:16:44.702639	\N	\N
4043	278	\N	Toma para sonido	pza	1.0000	18.00	material	2025-06-01 00:16:44.737013	2025-06-01 00:16:44.737013	\N	\N
4044	278	\N	Tubo Berman de 3/4 pulg	ml	6.0000	5.00	material	2025-06-01 00:16:44.771503	2025-06-01 00:16:44.771503	\N	\N
4045	278	\N	Maestro electricista	hr	1.6000	15.00	labor	2025-06-01 00:16:44.788247	2025-06-01 00:16:44.788247	\N	\N
4046	279	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:45.156731	2025-06-01 00:16:45.156731	\N	\N
4047	279	\N	Alambre bipolar para telefono	ml	15.0000	2.60	material	2025-06-01 00:16:45.191213	2025-06-01 00:16:45.191213	\N	\N
4048	279	\N	Caja plástica pvc 2x4	pza	1.0000	5.00	material	2025-06-01 00:16:45.225656	2025-06-01 00:16:45.225656	\N	\N
4049	279	\N	Caja plástica pvc 4x4	pza	1.0000	8.00	material	2025-06-01 00:16:45.26038	2025-06-01 00:16:45.26038	\N	\N
4050	279	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:45.294811	2025-06-01 00:16:45.294811	\N	\N
4051	279	\N	Toma de telefono de empotrar	pza	1.0000	27.00	material	2025-06-01 00:16:45.329384	2025-06-01 00:16:45.329384	\N	\N
4052	279	\N	Tubo Berman de 3/4 pulg	ml	6.0000	5.00	material	2025-06-01 00:16:45.363712	2025-06-01 00:16:45.363712	\N	\N
4053	279	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:45.381463	2025-06-01 00:16:45.381463	\N	\N
4054	280	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:45.756591	2025-06-01 00:16:45.756591	\N	\N
4055	280	\N	Cable coaxial 75 ohms	ml	15.0000	4.44	material	2025-06-01 00:16:45.790912	2025-06-01 00:16:45.790912	\N	\N
4056	280	\N	Caja plástica pvc 2x4	pza	1.0000	5.00	material	2025-06-01 00:16:45.825476	2025-06-01 00:16:45.825476	\N	\N
4057	280	\N	Caja plástica pvc 4x4	pza	1.0000	8.00	material	2025-06-01 00:16:45.861278	2025-06-01 00:16:45.861278	\N	\N
4058	280	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:45.900082	2025-06-01 00:16:45.900082	\N	\N
4059	280	\N	Toma coaxial para tv	pza	1.0000	29.00	material	2025-06-01 00:16:45.935414	2025-06-01 00:16:45.935414	\N	\N
4060	280	\N	Tubo Berman de 1 pulg	ml	3.0000	4.50	material	2025-06-01 00:16:45.969526	2025-06-01 00:16:45.969526	\N	\N
4061	280	\N	Tubo Berman de 3/4 pulg	ml	6.0000	5.00	material	2025-06-01 00:16:46.002707	2025-06-01 00:16:46.002707	\N	\N
4062	280	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:46.020871	2025-06-01 00:16:46.020871	\N	\N
4063	281	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:46.394622	2025-06-01 00:16:46.394622	\N	\N
4064	281	\N	Alambre aislado 1.5mm2 (#14)	ml	40.0000	2.08	material	2025-06-01 00:16:46.432858	2025-06-01 00:16:46.432858	\N	\N
4065	281	\N	Caja plástica pvc 2x4	pza	1.0000	5.00	material	2025-06-01 00:16:46.468486	2025-06-01 00:16:46.468486	\N	\N
4066	281	\N	Caja plástica pvc 4x4	pza	1.0000	8.00	material	2025-06-01 00:16:46.504572	2025-06-01 00:16:46.504572	\N	\N
4067	281	\N	Cinta aislante	pza	1.0000	6.00	material	2025-06-01 00:16:46.53944	2025-06-01 00:16:46.53944	\N	\N
4068	281	\N	Interruptor comun simple	pza	1.0000	32.00	material	2025-06-01 00:16:46.57431	2025-06-01 00:16:46.57431	\N	\N
4069	281	\N	Tubo Berman de 3/4 pulg	ml	32.0000	5.00	material	2025-06-01 00:16:46.609058	2025-06-01 00:16:46.609058	\N	\N
4070	281	\N	Maestro electricista	hr	6.0000	15.00	labor	2025-06-01 00:16:46.625732	2025-06-01 00:16:46.625732	\N	\N
4071	282	\N	Pegante para PVC	lt	1.0000	35.00	material	2025-06-01 00:16:47.003258	2025-06-01 00:16:47.003258	\N	\N
4072	282	\N	Alambre aislado 1.5mm2 (#14)	ml	100.0000	2.08	material	2025-06-01 00:16:47.038695	2025-06-01 00:16:47.038695	\N	\N
4073	282	\N	Alambre aislado 2.5mm2 (#12)	ml	100.0000	3.23	material	2025-06-01 00:16:47.075585	2025-06-01 00:16:47.075585	\N	\N
4074	282	\N	Alambre aislado 4mm2 (#10)	ml	200.0000	4.00	material	2025-06-01 00:16:47.109882	2025-06-01 00:16:47.109882	\N	\N
4075	282	\N	Caja plástica pvc 2x4	pza	1.0000	5.00	material	2025-06-01 00:16:47.144332	2025-06-01 00:16:47.144332	\N	\N
4076	282	\N	Cinta aislante	pza	4.0000	6.00	material	2025-06-01 00:16:47.178432	2025-06-01 00:16:47.178432	\N	\N
4077	282	\N	Fotocelula 1000 W s/base	pza	1.0000	121.60	material	2025-06-01 00:16:47.212795	2025-06-01 00:16:47.212795	\N	\N
4078	282	\N	Pararrayo radioactivo	pza	1.0000	304.00	material	2025-06-01 00:16:47.246732	2025-06-01 00:16:47.246732	\N	\N
4079	282	\N	Tubo Berman de 1 pulg	ml	80.0000	4.50	material	2025-06-01 00:16:47.282001	2025-06-01 00:16:47.282001	\N	\N
4080	282	\N	Manguera 1 pulg politubo	ml	60.0000	4.32	material	2025-06-01 00:16:47.316255	2025-06-01 00:16:47.316255	\N	\N
4081	282	\N	Maestro electricista	hr	8.0000	15.00	labor	2025-06-01 00:16:47.332989	2025-06-01 00:16:47.332989	\N	\N
4082	283	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:47.704146	2025-06-01 00:16:47.704146	\N	\N
4083	283	\N	Alambre aislado 10mm2 (#6)	ml	2.0000	1.61	material	2025-06-01 00:16:47.738749	2025-06-01 00:16:47.738749	\N	\N
4084	283	\N	Braker 1F de 25A	pza	4.0000	476.13	material	2025-06-01 00:16:47.773202	2025-06-01 00:16:47.773202	\N	\N
4085	283	\N	Caja metálica p/8 térmicos c/puerta	pza	1.0000	68.00	material	2025-06-01 00:16:47.807974	2025-06-01 00:16:47.807974	\N	\N
4086	283	\N	Cinta aislante	pza	3.0000	6.00	material	2025-06-01 00:16:47.842387	2025-06-01 00:16:47.842387	\N	\N
4087	283	\N	Disyuntor térmico de 25A	pza	4.0000	24.00	material	2025-06-01 00:16:47.876942	2025-06-01 00:16:47.876942	\N	\N
4088	283	\N	Tubo Berman de 1 pulg	ml	3.0000	4.50	material	2025-06-01 00:16:47.911446	2025-06-01 00:16:47.911446	\N	\N
4089	283	\N	Tubo Berman de 3/4 pulg	ml	3.0000	5.00	material	2025-06-01 00:16:47.947174	2025-06-01 00:16:47.947174	\N	\N
4090	283	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:47.963904	2025-06-01 00:16:47.963904	\N	\N
4091	284	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:48.342627	2025-06-01 00:16:48.342627	\N	\N
4092	284	\N	Alambre aislado 10mm2 (#6)	ml	2.0000	1.61	material	2025-06-01 00:16:48.376915	2025-06-01 00:16:48.376915	\N	\N
4093	284	\N	Barra de Cu de 40mm2	pza	4.0000	25.00	material	2025-06-01 00:16:48.411395	2025-06-01 00:16:48.411395	\N	\N
4094	284	\N	Caja metálica p/8 térmicos c/puerta	pza	1.0000	68.00	material	2025-06-01 00:16:48.446089	2025-06-01 00:16:48.446089	\N	\N
4095	284	\N	Cinta aislante	pza	3.0000	6.00	material	2025-06-01 00:16:48.480459	2025-06-01 00:16:48.480459	\N	\N
4096	284	\N	Disyuntor 1x10 A	pza	1.0000	19.00	material	2025-06-01 00:16:48.516595	2025-06-01 00:16:48.516595	\N	\N
4097	284	\N	Disyuntor 1x15A	pza	2.0000	19.00	material	2025-06-01 00:16:48.551154	2025-06-01 00:16:48.551154	\N	\N
4098	284	\N	Disyuntor térmico de 25A	pza	2.0000	24.00	material	2025-06-01 00:16:48.585208	2025-06-01 00:16:48.585208	\N	\N
4099	284	\N	Tubo Berman de 1 pulg	ml	3.0000	4.50	material	2025-06-01 00:16:48.619189	2025-06-01 00:16:48.619189	\N	\N
4100	284	\N	Tubo Berman de 3/4 pulg	ml	3.0000	5.00	material	2025-06-01 00:16:48.653515	2025-06-01 00:16:48.653515	\N	\N
4101	284	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:48.670175	2025-06-01 00:16:48.670175	\N	\N
4102	285	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:49.048481	2025-06-01 00:16:49.048481	\N	\N
4103	285	\N	Alambre aislado 10mm2 (#6)	ml	2.0000	1.61	material	2025-06-01 00:16:49.082948	2025-06-01 00:16:49.082948	\N	\N
4104	285	\N	Caja metálica p/8 térmicos c/puerta	pza	1.0000	68.00	material	2025-06-01 00:16:49.117383	2025-06-01 00:16:49.117383	\N	\N
4105	285	\N	Cinta aislante	pza	3.0000	6.00	material	2025-06-01 00:16:49.155357	2025-06-01 00:16:49.155357	\N	\N
4106	285	\N	Disyuntor 1x10 A	pza	1.0000	19.00	material	2025-06-01 00:16:49.190958	2025-06-01 00:16:49.190958	\N	\N
4107	285	\N	Disyuntor 1x15A	pza	2.0000	19.00	material	2025-06-01 00:16:49.226283	2025-06-01 00:16:49.226283	\N	\N
4108	285	\N	Disyuntor térmico de 25A	pza	2.0000	24.00	material	2025-06-01 00:16:49.260745	2025-06-01 00:16:49.260745	\N	\N
4109	285	\N	Tubo Berman de 1 pulg	ml	3.0000	4.50	material	2025-06-01 00:16:49.295278	2025-06-01 00:16:49.295278	\N	\N
4110	285	\N	Tubo Berman de 3/4 pulg	ml	3.0000	5.00	material	2025-06-01 00:16:49.330793	2025-06-01 00:16:49.330793	\N	\N
4111	285	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:49.347633	2025-06-01 00:16:49.347633	\N	\N
4112	286	\N	Alambre aislado 2.5mm2 (#12)	ml	5.0000	3.23	material	2025-06-01 00:16:49.731196	2025-06-01 00:16:49.731196	\N	\N
4113	286	\N	Caja plástica pvc 2x4	pza	1.0000	5.00	material	2025-06-01 00:16:49.765946	2025-06-01 00:16:49.765946	\N	\N
4114	286	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:49.800208	2025-06-01 00:16:49.800208	\N	\N
4115	286	\N	Placa tomacorriente doble con tierra	pza	1.0000	35.00	material	2025-06-01 00:16:49.835657	2025-06-01 00:16:49.835657	\N	\N
4116	286	\N	Tubo Berman de 3/4 pulg	ml	5.0000	5.00	material	2025-06-01 00:16:49.870428	2025-06-01 00:16:49.870428	\N	\N
4117	286	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:49.887069	2025-06-01 00:16:49.887069	\N	\N
4118	287	\N	Alambre aislado 2.5mm2 (#12)	ml	5.0000	3.23	material	2025-06-01 00:16:50.255346	2025-06-01 00:16:50.255346	\N	\N
4119	287	\N	Caja plástica pvc 4x4	pza	1.0000	8.00	material	2025-06-01 00:16:50.289751	2025-06-01 00:16:50.289751	\N	\N
4120	287	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:50.323926	2025-06-01 00:16:50.323926	\N	\N
4121	287	\N	Placa tomacorriente doble de piso	pza	1.0000	35.00	material	2025-06-01 00:16:50.35842	2025-06-01 00:16:50.35842	\N	\N
4122	287	\N	Tubo Berman de 3/4 pulg	ml	5.0000	5.00	material	2025-06-01 00:16:50.393437	2025-06-01 00:16:50.393437	\N	\N
4123	287	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:50.41005	2025-06-01 00:16:50.41005	\N	\N
4124	288	\N	Alambre aislado 2.5mm2 (#12)	ml	5.0000	3.23	material	2025-06-01 00:16:50.830496	2025-06-01 00:16:50.830496	\N	\N
4125	288	\N	Caja plástica pvc 4x4	pza	1.0000	8.00	material	2025-06-01 00:16:50.864896	2025-06-01 00:16:50.864896	\N	\N
4126	288	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:50.899632	2025-06-01 00:16:50.899632	\N	\N
4127	288	\N	Placa tomacorriente doble de piso con tierra	pza	1.0000	42.00	material	2025-06-01 00:16:50.934362	2025-06-01 00:16:50.934362	\N	\N
4128	288	\N	Tubo Berman de 3/4 pulg	ml	5.0000	5.00	material	2025-06-01 00:16:50.969219	2025-06-01 00:16:50.969219	\N	\N
4129	288	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:50.986239	2025-06-01 00:16:50.986239	\N	\N
4130	289	\N	Llave de paso de 3/4 pulg	pza	1.0000	65.00	material	2025-06-01 00:16:51.472167	2025-06-01 00:16:51.472167	\N	\N
4131	289	\N	Teflón 3/4 pulg	pza	0.5000	3.00	material	2025-06-01 00:16:51.506542	2025-06-01 00:16:51.506542	\N	\N
4132	289	\N	Cañería de FoGo de 3/4 pulg L=6.00	ml	4.0000	29.17	material	2025-06-01 00:16:51.54112	2025-06-01 00:16:51.54112	\N	\N
4133	289	\N	Medidor de flujo de agua	pza	1.0000	342.00	material	2025-06-01 00:16:51.575591	2025-06-01 00:16:51.575591	\N	\N
4134	289	\N	Ayudante (plomero)	hr	5.0000	12.50	labor	2025-06-01 00:16:51.592317	2025-06-01 00:16:51.592317	\N	\N
4135	289	\N	Maestro plomero	hr	5.0000	17.50	labor	2025-06-01 00:16:51.608984	2025-06-01 00:16:51.608984	\N	\N
4136	290	\N	Grifo de 1/2 pulg	pza	1.0000	90.00	material	2025-06-01 00:16:52.001616	2025-06-01 00:16:52.001616	\N	\N
4137	290	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:16:52.018549	2025-06-01 00:16:52.018549	\N	\N
4138	290	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:16:52.035487	2025-06-01 00:16:52.035487	\N	\N
4139	291	\N	Grifo de 1 pulg	pza	1.0000	58.81	material	2025-06-01 00:16:52.412003	2025-06-01 00:16:52.412003	\N	\N
4140	291	\N	Ayudante (plomero)	hr	1.8000	12.50	labor	2025-06-01 00:16:52.428883	2025-06-01 00:16:52.428883	\N	\N
4141	291	\N	Maestro plomero	hr	2.5000	17.50	labor	2025-06-01 00:16:52.445883	2025-06-01 00:16:52.445883	\N	\N
4142	292	\N	Codo de FoGo de 1/2 pulg	pza	4.0000	3.70	material	2025-06-01 00:16:52.85516	2025-06-01 00:16:52.85516	\N	\N
4143	292	\N	Cupla de FoGo de 1/2 pulg	pza	3.0000	3.00	material	2025-06-01 00:16:52.892151	2025-06-01 00:16:52.892151	\N	\N
4144	292	\N	Llave de paso de 1/2 pulg	pza	1.0000	48.00	material	2025-06-01 00:16:52.92922	2025-06-01 00:16:52.92922	\N	\N
4145	292	\N	Niple de Fe de 1/2 pulg	pza	2.0000	3.90	material	2025-06-01 00:16:52.963539	2025-06-01 00:16:52.963539	\N	\N
4146	292	\N	Unión patente de Fe de 1/2 pulg	pza	1.0000	14.50	material	2025-06-01 00:16:53.001868	2025-06-01 00:16:53.001868	\N	\N
4147	292	\N	Cañería de FoGo de 1/2 pulg L=6.00	ml	3.0000	14.17	material	2025-06-01 00:16:53.037173	2025-06-01 00:16:53.037173	\N	\N
4148	292	\N	Ayudante (plomero)	hr	4.8000	12.50	labor	2025-06-01 00:16:53.053756	2025-06-01 00:16:53.053756	\N	\N
4149	292	\N	Maestro plomero	hr	4.8000	17.50	labor	2025-06-01 00:16:53.07038	2025-06-01 00:16:53.07038	\N	\N
4150	293	\N	Codo de FoGo de 1/2 pulg	pza	1.0000	3.70	material	2025-06-01 00:16:53.461765	2025-06-01 00:16:53.461765	\N	\N
4151	293	\N	Cupla de FoGo de 1/2 pulg	pza	1.0000	3.00	material	2025-06-01 00:16:53.496556	2025-06-01 00:16:53.496556	\N	\N
4152	293	\N	Niple de Fe de 1/2 pulg	pza	1.0000	3.90	material	2025-06-01 00:16:53.537452	2025-06-01 00:16:53.537452	\N	\N
4153	293	\N	Unión patente de Fe de 1/2 pulg	pza	1.0000	14.50	material	2025-06-01 00:16:53.571809	2025-06-01 00:16:53.571809	\N	\N
4154	293	\N	Cañería de FoGo de 1/2 pulg L=6.00	ml	1.0000	14.17	material	2025-06-01 00:16:53.607334	2025-06-01 00:16:53.607334	\N	\N
4155	293	\N	Ayudante (plomero)	hr	3.0000	12.50	labor	2025-06-01 00:16:53.624068	2025-06-01 00:16:53.624068	\N	\N
4156	293	\N	Maestro plomero	hr	3.0000	17.50	labor	2025-06-01 00:16:53.640642	2025-06-01 00:16:53.640642	\N	\N
4157	294	\N	Válvula de cortina de 2 pulg	pza	1.0000	315.00	material	2025-06-01 00:16:54.00415	2025-06-01 00:16:54.00415	\N	\N
4158	294	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:16:54.020878	2025-06-01 00:16:54.020878	\N	\N
4159	294	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:16:54.037904	2025-06-01 00:16:54.037904	\N	\N
4160	295	\N	Válvula de cortina de 1 1/2 pulg	pza	1.0000	228.00	material	2025-06-01 00:16:54.401126	2025-06-01 00:16:54.401126	\N	\N
4161	295	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:16:54.417863	2025-06-01 00:16:54.417863	\N	\N
4162	295	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:16:54.435042	2025-06-01 00:16:54.435042	\N	\N
4163	296	\N	Llave de paso de 1/2 pulg	pza	1.0000	48.00	material	2025-06-01 00:16:54.803431	2025-06-01 00:16:54.803431	\N	\N
4164	296	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:16:54.820101	2025-06-01 00:16:54.820101	\N	\N
4165	296	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:16:54.837021	2025-06-01 00:16:54.837021	\N	\N
4166	297	\N	Llave de paso de 1 1/2"	pza	1.0000	228.00	material	2025-06-01 00:16:55.201735	2025-06-01 00:16:55.201735	\N	\N
4167	297	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:16:55.218995	2025-06-01 00:16:55.218995	\N	\N
4168	297	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:16:55.2356	2025-06-01 00:16:55.2356	\N	\N
4169	298	\N	Llave de paso de 1 "	pza	1.0000	115.00	material	2025-06-01 00:16:55.602272	2025-06-01 00:16:55.602272	\N	\N
4170	298	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:16:55.619742	2025-06-01 00:16:55.619742	\N	\N
4171	298	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:16:55.636607	2025-06-01 00:16:55.636607	\N	\N
4172	299	\N	Llave de paso de 2 "	pza	1.0000	315.00	material	2025-06-01 00:16:55.997767	2025-06-01 00:16:55.997767	\N	\N
4173	299	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:16:56.014592	2025-06-01 00:16:56.014592	\N	\N
4174	299	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:16:56.031244	2025-06-01 00:16:56.031244	\N	\N
4175	300	\N	Llave de paso de 3/4 pulg	pza	1.0000	65.00	material	2025-06-01 00:16:56.402114	2025-06-01 00:16:56.402114	\N	\N
4176	300	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:16:56.417707	2025-06-01 00:16:56.417707	\N	\N
4177	300	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:16:56.434564	2025-06-01 00:16:56.434564	\N	\N
4178	301	\N	Teflón 3/4 pulg	pza	0.3000	3.00	material	2025-06-01 00:16:56.804034	2025-06-01 00:16:56.804034	\N	\N
4179	301	\N	Cañería de agua caliente de 1/2 pulg	ml	1.0200	5.47	material	2025-06-01 00:16:56.838866	2025-06-01 00:16:56.838866	\N	\N
4180	301	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:16:56.855553	2025-06-01 00:16:56.855553	\N	\N
4181	301	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:16:56.872363	2025-06-01 00:16:56.872363	\N	\N
4182	302	\N	Teflón 3/4 pulg	pza	0.3000	3.00	material	2025-06-01 00:16:57.249113	2025-06-01 00:16:57.249113	\N	\N
4183	302	\N	Cañería de FoGo de 1 1/2 pulg L=6.00	ml	1.0200	49.17	material	2025-06-01 00:16:57.283755	2025-06-01 00:16:57.283755	\N	\N
4184	302	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:16:57.300512	2025-06-01 00:16:57.300512	\N	\N
4185	302	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:16:57.317303	2025-06-01 00:16:57.317303	\N	\N
4186	303	\N	Teflón 3/4 pulg	pza	0.3000	3.00	material	2025-06-01 00:16:57.682744	2025-06-01 00:16:57.682744	\N	\N
4187	303	\N	Cañería de FoGo de 1 pulg L=6.00	ml	1.0200	40.83	material	2025-06-01 00:16:57.718042	2025-06-01 00:16:57.718042	\N	\N
4188	303	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:16:57.735624	2025-06-01 00:16:57.735624	\N	\N
4189	303	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:16:57.754165	2025-06-01 00:16:57.754165	\N	\N
4190	304	\N	Teflón 3/4 pulg	pza	0.3000	3.00	material	2025-06-01 00:16:58.121092	2025-06-01 00:16:58.121092	\N	\N
4191	304	\N	Cañería de FoGo de 2 pulg L=6.00	ml	1.0200	60.00	material	2025-06-01 00:16:58.15576	2025-06-01 00:16:58.15576	\N	\N
4192	304	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:16:58.172489	2025-06-01 00:16:58.172489	\N	\N
4193	304	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:16:58.189322	2025-06-01 00:16:58.189322	\N	\N
4194	305	\N	Teflón 3/4 pulg	pza	0.3000	3.00	material	2025-06-01 00:16:58.587221	2025-06-01 00:16:58.587221	\N	\N
4195	305	\N	Cañería de FoGo de 3 pulg L=6.00	ml	1.0200	115.00	material	2025-06-01 00:16:58.684937	2025-06-01 00:16:58.684937	\N	\N
4196	305	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:16:58.702074	2025-06-01 00:16:58.702074	\N	\N
4197	305	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:16:58.718896	2025-06-01 00:16:58.718896	\N	\N
4198	306	\N	Teflón 3/4 pulg	pza	0.3000	3.00	material	2025-06-01 00:16:59.114969	2025-06-01 00:16:59.114969	\N	\N
4199	306	\N	Cañería de FoGo de 3/4 pulg L=6.00	ml	1.0200	29.17	material	2025-06-01 00:16:59.150124	2025-06-01 00:16:59.150124	\N	\N
4200	306	\N	Ayudante (plomero)	hr	0.6000	12.50	labor	2025-06-01 00:16:59.167537	2025-06-01 00:16:59.167537	\N	\N
4201	306	\N	Maestro plomero	hr	0.6000	17.50	labor	2025-06-01 00:16:59.18434	2025-06-01 00:16:59.18434	\N	\N
4202	307	\N	Teflón 3/4 pulg	pza	0.3000	3.00	material	2025-06-01 00:16:59.547306	2025-06-01 00:16:59.547306	\N	\N
4203	307	\N	Cañería de HIDRO3 de 1/2 pulg	ml	1.0200	4.80	material	2025-06-01 00:16:59.580724	2025-06-01 00:16:59.580724	\N	\N
4204	307	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:16:59.598057	2025-06-01 00:16:59.598057	\N	\N
4205	307	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:16:59.614891	2025-06-01 00:16:59.614891	\N	\N
4206	308	\N	Teflón 3/4 pulg	pza	0.3000	3.00	material	2025-06-01 00:16:59.976901	2025-06-01 00:16:59.976901	\N	\N
4207	308	\N	Cañería de HIDRO3 de 3/4 pulg	ml	1.0200	8.20	material	2025-06-01 00:17:00.011528	2025-06-01 00:17:00.011528	\N	\N
4208	308	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:17:00.028091	2025-06-01 00:17:00.028091	\N	\N
4209	308	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:17:00.044812	2025-06-01 00:17:00.044812	\N	\N
4210	309	\N	Teflón 3/4 pulg	pza	0.3000	3.00	material	2025-06-01 00:17:00.411106	2025-06-01 00:17:00.411106	\N	\N
4211	309	\N	Cañería de PVC de 1 1/2 pulg	ml	1.0500	15.00	material	2025-06-01 00:17:00.446406	2025-06-01 00:17:00.446406	\N	\N
4212	309	\N	Ayudante (plomero)	hr	0.9000	12.50	labor	2025-06-01 00:17:00.463076	2025-06-01 00:17:00.463076	\N	\N
4213	309	\N	Maestro plomero	hr	0.9000	17.50	labor	2025-06-01 00:17:00.479669	2025-06-01 00:17:00.479669	\N	\N
4214	310	\N	Teflón 3/4 pulg	pza	0.3000	3.00	material	2025-06-01 00:17:00.877807	2025-06-01 00:17:00.877807	\N	\N
4215	310	\N	Cañería de P.V.C. de 1/2 pulg	ml	1.0200	4.00	material	2025-06-01 00:17:00.912387	2025-06-01 00:17:00.912387	\N	\N
4216	310	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:17:00.929167	2025-06-01 00:17:00.929167	\N	\N
4217	310	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:17:00.945624	2025-06-01 00:17:00.945624	\N	\N
4218	311	\N	Teflón 3/4 pulg	pza	0.3000	3.00	material	2025-06-01 00:17:01.307599	2025-06-01 00:17:01.307599	\N	\N
4219	311	\N	Cañería de P.V.C. de 3/4 pulg	ml	1.0200	7.00	material	2025-06-01 00:17:01.342205	2025-06-01 00:17:01.342205	\N	\N
4220	311	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:17:01.362881	2025-06-01 00:17:01.362881	\N	\N
4221	311	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:17:01.380464	2025-06-01 00:17:01.380464	\N	\N
4222	312	\N	Teflón 3/4 pulg	pza	0.3000	3.00	material	2025-06-01 00:17:01.761229	2025-06-01 00:17:01.761229	\N	\N
4223	312	\N	Cañería HIDRO3 de 3/4 pulg	ml	1.0200	10.21	material	2025-06-01 00:17:01.796418	2025-06-01 00:17:01.796418	\N	\N
4224	312	\N	Ayudante (plomero)	hr	0.5000	12.50	labor	2025-06-01 00:17:01.81304	2025-06-01 00:17:01.81304	\N	\N
4225	312	\N	Maestro plomero	hr	0.5000	17.50	labor	2025-06-01 00:17:01.829467	2025-06-01 00:17:01.829467	\N	\N
4226	313	\N	Teflón 3/4 pulg	pza	0.3000	3.00	material	2025-06-01 00:17:02.192622	2025-06-01 00:17:02.192622	\N	\N
4227	313	\N	Cañería de FoGo de 1/2 pulg L=6.00	ml	1.0200	14.17	material	2025-06-01 00:17:02.22774	2025-06-01 00:17:02.22774	\N	\N
4228	313	\N	Ayudante (plomero)	hr	0.6000	12.50	labor	2025-06-01 00:17:02.244288	2025-06-01 00:17:02.244288	\N	\N
4229	313	\N	Maestro plomero	hr	0.6000	17.50	labor	2025-06-01 00:17:02.260927	2025-06-01 00:17:02.260927	\N	\N
4230	314	\N	Tubo de PVC de 3 pulg L=4.00	ml	1.0200	13.25	material	2025-06-01 00:17:02.710592	2025-06-01 00:17:02.710592	\N	\N
4231	314	\N	Adhesivo para P.V.C.	lt	0.2000	25.00	material	2025-06-01 00:17:02.745114	2025-06-01 00:17:02.745114	\N	\N
4232	314	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:17:02.760772	2025-06-01 00:17:02.760772	\N	\N
4233	314	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:17:02.777511	2025-06-01 00:17:02.777511	\N	\N
4234	315	\N	Tubo de PVC de 4 pulg L=4.00	ml	1.0200	19.13	material	2025-06-01 00:17:03.144329	2025-06-01 00:17:03.144329	\N	\N
4235	315	\N	Adhesivo para P.V.C.	lt	0.2000	25.00	material	2025-06-01 00:17:03.178546	2025-06-01 00:17:03.178546	\N	\N
4236	315	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:17:03.195482	2025-06-01 00:17:03.195482	\N	\N
4237	315	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:17:03.212302	2025-06-01 00:17:03.212302	\N	\N
4238	316	\N	Tubo de PVC de 6 pulg L=6.00	ml	1.0200	54.16	material	2025-06-01 00:17:03.59765	2025-06-01 00:17:03.59765	\N	\N
4239	316	\N	Adhesivo para P.V.C.	lt	0.2000	25.00	material	2025-06-01 00:17:03.632308	2025-06-01 00:17:03.632308	\N	\N
4240	316	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:17:03.649055	2025-06-01 00:17:03.649055	\N	\N
4241	316	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:17:03.667189	2025-06-01 00:17:03.667189	\N	\N
4242	317	\N	Caja sifonada de 4 plg	pza	1.0000	25.00	material	2025-06-01 00:17:04.236534	2025-06-01 00:17:04.236534	\N	\N
4243	317	\N	Ayudante	hr	1.6000	12.50	labor	2025-06-01 00:17:04.253676	2025-06-01 00:17:04.253676	\N	\N
4244	317	\N	Maestro albañil	hr	1.6000	18.75	labor	2025-06-01 00:17:04.270392	2025-06-01 00:17:04.270392	\N	\N
4245	318	\N	Caja sifonada de 6 plg	pza	1.0000	54.00	material	2025-06-01 00:17:04.698376	2025-06-01 00:17:04.698376	\N	\N
4246	318	\N	Ayudante	hr	1.6000	12.50	labor	2025-06-01 00:17:04.715258	2025-06-01 00:17:04.715258	\N	\N
4247	318	\N	Maestro albañil	hr	1.6000	18.75	labor	2025-06-01 00:17:04.732081	2025-06-01 00:17:04.732081	\N	\N
4248	319	\N	Rejilla de piso 20x20	pza	1.0000	25.00	material	2025-06-01 00:17:05.260944	2025-06-01 00:17:05.260944	\N	\N
4249	319	\N	Acero de alta resistencia	kg	4.0000	8.50	material	2025-06-01 00:17:05.295617	2025-06-01 00:17:05.295617	\N	\N
4250	319	\N	Cemento portland IP-30	kg	35.0000	1.20	material	2025-06-01 00:17:05.329915	2025-06-01 00:17:05.329915	\N	\N
4251	319	5	Arena Fina	m3	0.2000	70.00	material	2025-06-01 00:17:05.362935	2025-06-01 00:17:05.362935	\N	\N
4252	319	\N	Ladrillo adobito	pza	100.0000	0.65	material	2025-06-01 00:17:05.398396	2025-06-01 00:17:05.398396	\N	\N
4253	319	22	Agua	lt	30.0000	0.06	material	2025-06-01 00:17:05.432028	2025-06-01 00:17:05.432028	\N	\N
4254	319	\N	Ayudante	hr	10.0000	12.50	labor	2025-06-01 00:17:05.448843	2025-06-01 00:17:05.448843	\N	\N
4255	319	\N	Maestro albañil	hr	10.0000	18.75	labor	2025-06-01 00:17:05.465706	2025-06-01 00:17:05.465706	\N	\N
4256	320	\N	Acero de alta resistencia	kg	4.0000	8.50	material	2025-06-01 00:17:05.922433	2025-06-01 00:17:05.922433	\N	\N
4257	320	\N	Cemento portland IP-30	kg	50.0000	1.20	material	2025-06-01 00:17:05.957136	2025-06-01 00:17:05.957136	\N	\N
4258	320	5	Arena Fina	m3	0.2000	70.00	material	2025-06-01 00:17:05.994176	2025-06-01 00:17:05.994176	\N	\N
4259	320	\N	Ladrillo adobito	pza	132.0000	0.65	material	2025-06-01 00:17:06.027916	2025-06-01 00:17:06.027916	\N	\N
4260	320	\N	Alambre de amarre	kg	0.2000	11.00	material	2025-06-01 00:17:06.064261	2025-06-01 00:17:06.064261	\N	\N
4261	320	22	Agua	lt	30.0000	0.06	material	2025-06-01 00:17:06.107661	2025-06-01 00:17:06.107661	\N	\N
4262	320	\N	Ayudante	hr	10.0000	12.50	labor	2025-06-01 00:17:06.12453	2025-06-01 00:17:06.12453	\N	\N
4263	320	\N	Maestro albañil	hr	10.0000	18.75	labor	2025-06-01 00:17:06.141314	2025-06-01 00:17:06.141314	\N	\N
4264	321	\N	Acero de alta resistencia	kg	1.0000	8.50	material	2025-06-01 00:17:06.56438	2025-06-01 00:17:06.56438	\N	\N
4265	321	\N	Cemento portland IP-30	kg	21.0000	1.20	material	2025-06-01 00:17:06.599473	2025-06-01 00:17:06.599473	\N	\N
4266	321	5	Arena Fina	m3	0.1000	70.00	material	2025-06-01 00:17:06.632221	2025-06-01 00:17:06.632221	\N	\N
4267	321	\N	Ladrillo adobito	pza	50.0000	0.65	material	2025-06-01 00:17:06.666557	2025-06-01 00:17:06.666557	\N	\N
4268	321	\N	Alambre de amarre	kg	0.0900	11.00	material	2025-06-01 00:17:06.701012	2025-06-01 00:17:06.701012	\N	\N
4269	321	22	Agua	lt	18.0000	0.06	material	2025-06-01 00:17:06.733062	2025-06-01 00:17:06.733062	\N	\N
4270	321	\N	Ayudante	hr	5.0000	12.50	labor	2025-06-01 00:17:06.749984	2025-06-01 00:17:06.749984	\N	\N
4271	321	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:17:06.766653	2025-06-01 00:17:06.766653	\N	\N
4272	322	\N	Acero de alta resistencia	kg	3.0000	8.50	material	2025-06-01 00:17:07.187484	2025-06-01 00:17:07.187484	\N	\N
4273	322	\N	Cemento portland IP-30	kg	35.0000	1.20	material	2025-06-01 00:17:07.223001	2025-06-01 00:17:07.223001	\N	\N
4274	322	5	Arena Fina	m3	0.1500	70.00	material	2025-06-01 00:17:07.256422	2025-06-01 00:17:07.256422	\N	\N
4275	322	\N	Ladrillo adobito	pza	80.0000	0.65	material	2025-06-01 00:17:07.290898	2025-06-01 00:17:07.290898	\N	\N
4276	322	\N	Alambre de amarre	kg	0.1500	11.00	material	2025-06-01 00:17:07.325321	2025-06-01 00:17:07.325321	\N	\N
4277	322	22	Agua	lt	30.0000	0.06	material	2025-06-01 00:17:07.358355	2025-06-01 00:17:07.358355	\N	\N
4278	322	\N	Ayudante	hr	8.0000	12.50	labor	2025-06-01 00:17:07.375127	2025-06-01 00:17:07.375127	\N	\N
4279	322	\N	Maestro albañil	hr	8.0000	18.75	labor	2025-06-01 00:17:07.391777	2025-06-01 00:17:07.391777	\N	\N
4280	323	\N	Cámara desgrasadora de P.V.C. 6"	pza	1.0000	24.00	material	2025-06-01 00:17:07.784404	2025-06-01 00:17:07.784404	\N	\N
4281	323	\N	Ayudante	hr	1.6000	12.50	labor	2025-06-01 00:17:07.801216	2025-06-01 00:17:07.801216	\N	\N
4282	323	\N	Maestro albañil	hr	1.6000	18.75	labor	2025-06-01 00:17:07.817915	2025-06-01 00:17:07.817915	\N	\N
4283	324	\N	Acero de alta resistencia	kg	30.0000	8.50	material	2025-06-01 00:17:08.376634	2025-06-01 00:17:08.376634	\N	\N
4284	324	\N	Cemento portland IP-30	kg	465.0000	1.20	material	2025-06-01 00:17:08.411248	2025-06-01 00:17:08.411248	\N	\N
4285	324	\N	Arenilla	m3	1.3000	100.00	material	2025-06-01 00:17:08.445859	2025-06-01 00:17:08.445859	\N	\N
4286	324	\N	Piedra manzana	m3	0.3700	250.00	material	2025-06-01 00:17:08.48205	2025-06-01 00:17:08.48205	\N	\N
4287	324	\N	Ripio rodado	m3	0.6700	170.00	material	2025-06-01 00:17:08.516858	2025-06-01 00:17:08.516858	\N	\N
4288	324	\N	Ladrillo adobito	pza	975.0000	0.65	material	2025-06-01 00:17:08.551197	2025-06-01 00:17:08.551197	\N	\N
4289	324	23	Clavos de 2 pulg	kg	1.0000	13.00	material	2025-06-01 00:17:08.584975	2025-06-01 00:17:08.584975	\N	\N
4290	324	\N	Alambre de amarre	kg	0.7500	11.00	material	2025-06-01 00:17:08.620487	2025-06-01 00:17:08.620487	\N	\N
4291	324	\N	Ayudante	hr	38.0000	12.50	labor	2025-06-01 00:17:08.637171	2025-06-01 00:17:08.637171	\N	\N
4292	324	\N	Maestro albañil	hr	44.0000	18.75	labor	2025-06-01 00:17:08.654083	2025-06-01 00:17:08.654083	\N	\N
4534	366	5	Arena Fina	m3	0.0600	70.00	material	2025-06-01 00:17:32.488534	2025-06-01 00:17:32.488534	\N	\N
4293	325	\N	Codo de PVC desague de 1 1/2 pulg	pza	2.0000	3.00	material	2025-06-01 00:17:09.062251	2025-06-01 00:17:09.062251	\N	\N
4294	325	\N	Yee de PVC desague de 4 pulg	pza	1.0000	10.00	material	2025-06-01 00:17:09.097254	2025-06-01 00:17:09.097254	\N	\N
4295	325	\N	Tubo de PVC de 1 1/2 pulg	ml	2.8000	10.00	material	2025-06-01 00:17:09.132084	2025-06-01 00:17:09.132084	\N	\N
4296	325	\N	Tubo de PVC de 4 pulg L=4.00	ml	1.0000	19.13	material	2025-06-01 00:17:09.165803	2025-06-01 00:17:09.165803	\N	\N
4297	325	\N	Adhesivo para P.V.C.	lt	0.0500	25.00	material	2025-06-01 00:17:09.200557	2025-06-01 00:17:09.200557	\N	\N
4298	325	\N	Ayudante (plomero)	hr	2.8100	12.50	labor	2025-06-01 00:17:09.217296	2025-06-01 00:17:09.217296	\N	\N
4299	325	\N	Maestro plomero	hr	2.8100	17.50	labor	2025-06-01 00:17:09.23393	2025-06-01 00:17:09.23393	\N	\N
4300	326	\N	Acero de alta resistencia	kg	7.3500	8.50	material	2025-06-01 00:17:09.724952	2025-06-01 00:17:09.724952	\N	\N
4301	326	\N	Cemento portland IP-30	kg	228.0800	1.20	material	2025-06-01 00:17:09.759438	2025-06-01 00:17:09.759438	\N	\N
4302	326	\N	Arenilla	m3	1.4700	100.00	material	2025-06-01 00:17:09.793785	2025-06-01 00:17:09.793785	\N	\N
4303	326	\N	Ripio rodado	m3	0.0800	170.00	material	2025-06-01 00:17:09.828729	2025-06-01 00:17:09.828729	\N	\N
4304	326	\N	Ladrillo adobito	pza	1.0000	0.65	material	2025-06-01 00:17:09.863459	2025-06-01 00:17:09.863459	\N	\N
4305	326	23	Clavos de 2 pulg	kg	0.1100	13.00	material	2025-06-01 00:17:09.897654	2025-06-01 00:17:09.897654	\N	\N
4306	326	\N	Alambre de amarre	kg	0.1100	11.00	material	2025-06-01 00:17:09.930766	2025-06-01 00:17:09.930766	\N	\N
4307	326	\N	Ayudante	hr	21.1100	12.50	labor	2025-06-01 00:17:09.947341	2025-06-01 00:17:09.947341	\N	\N
4308	326	\N	Maestro albañil	hr	17.3400	18.75	labor	2025-06-01 00:17:09.963967	2025-06-01 00:17:09.963967	\N	\N
4309	327	\N	Rejilla de bronce 4 pulg	pza	1.0000	60.00	material	2025-06-01 00:17:10.353869	2025-06-01 00:17:10.353869	\N	\N
4310	327	\N	Ayudante (plomero)	hr	1.0000	12.50	labor	2025-06-01 00:17:10.370423	2025-06-01 00:17:10.370423	\N	\N
4311	327	\N	Maestro plomero	hr	2.0000	17.50	labor	2025-06-01 00:17:10.387026	2025-06-01 00:17:10.387026	\N	\N
4312	328	\N	Cemento portland IP-30	kg	0.3000	1.20	material	2025-06-01 00:17:10.800556	2025-06-01 00:17:10.800556	\N	\N
4313	328	5	Arena Fina	m3	0.0500	70.00	material	2025-06-01 00:17:10.833588	2025-06-01 00:17:10.833588	\N	\N
4314	328	\N	Tubo cerámico de 6 pulg	ml	1.0200	53.75	material	2025-06-01 00:17:10.869143	2025-06-01 00:17:10.869143	\N	\N
4315	328	\N	Ayudante	hr	0.5000	12.50	labor	2025-06-01 00:17:10.886119	2025-06-01 00:17:10.886119	\N	\N
4316	328	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:17:10.902807	2025-06-01 00:17:10.902807	\N	\N
4317	329	\N	Cemento portland IP-30	kg	0.5000	1.20	material	2025-06-01 00:17:11.504521	2025-06-01 00:17:11.504521	\N	\N
4318	329	\N	Arenilla	m3	0.0500	100.00	material	2025-06-01 00:17:11.539278	2025-06-01 00:17:11.539278	\N	\N
4319	329	\N	Ripio rodado	m3	0.0700	170.00	material	2025-06-01 00:17:11.573962	2025-06-01 00:17:11.573962	\N	\N
4320	329	\N	Tubo de cemento de 8pulg	ml	1.0200	100.00	material	2025-06-01 00:17:11.609425	2025-06-01 00:17:11.609425	\N	\N
4321	329	\N	Ayudante	hr	0.5000	12.50	labor	2025-06-01 00:17:11.626386	2025-06-01 00:17:11.626386	\N	\N
4322	329	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:17:11.643232	2025-06-01 00:17:11.643232	\N	\N
4323	330	\N	Tubo de PVC de 4 pulg L=4.00	ml	1.0200	19.13	material	2025-06-01 00:17:12.2019	2025-06-01 00:17:12.2019	\N	\N
4324	330	\N	Adhesivo para P.V.C.	lt	0.2000	25.00	material	2025-06-01 00:17:12.237178	2025-06-01 00:17:12.237178	\N	\N
4325	330	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:17:12.253958	2025-06-01 00:17:12.253958	\N	\N
4326	330	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:17:12.270666	2025-06-01 00:17:12.270666	\N	\N
4327	331	\N	Tubo de PVC de 1 1/2 pulg	ml	1.0200	10.00	material	2025-06-01 00:17:12.656976	2025-06-01 00:17:12.656976	\N	\N
4328	331	\N	Adhesivo para P.V.C.	lt	0.1500	25.00	material	2025-06-01 00:17:12.698493	2025-06-01 00:17:12.698493	\N	\N
4329	331	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:17:12.715391	2025-06-01 00:17:12.715391	\N	\N
4330	331	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:17:12.73282	2025-06-01 00:17:12.73282	\N	\N
4331	332	\N	Tubo de PVC de 2 1/2 pulg	ml	1.0200	10.00	material	2025-06-01 00:17:13.115456	2025-06-01 00:17:13.115456	\N	\N
4332	332	\N	Adhesivo para P.V.C.	lt	0.1500	25.00	material	2025-06-01 00:17:13.152713	2025-06-01 00:17:13.152713	\N	\N
4333	332	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:17:13.169882	2025-06-01 00:17:13.169882	\N	\N
4334	332	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:17:13.186643	2025-06-01 00:17:13.186643	\N	\N
4335	333	\N	Tubo de PVC de 2 pulg	ml	1.0200	7.80	material	2025-06-01 00:17:13.615573	2025-06-01 00:17:13.615573	\N	\N
4336	333	\N	Adhesivo para P.V.C.	lt	0.1500	25.00	material	2025-06-01 00:17:13.649861	2025-06-01 00:17:13.649861	\N	\N
4337	333	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:17:13.666801	2025-06-01 00:17:13.666801	\N	\N
4338	333	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:17:13.683602	2025-06-01 00:17:13.683602	\N	\N
4339	334	\N	Tubo de PVC de 3 pulg L=4.00	ml	1.0200	13.25	material	2025-06-01 00:17:14.050597	2025-06-01 00:17:14.050597	\N	\N
4340	334	\N	Adhesivo para P.V.C.	lt	0.2000	25.00	material	2025-06-01 00:17:14.086947	2025-06-01 00:17:14.086947	\N	\N
4341	334	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:17:14.103855	2025-06-01 00:17:14.103855	\N	\N
4342	334	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:17:14.15218	2025-06-01 00:17:14.15218	\N	\N
4343	335	\N	Tubo de PVC de 4 pulg L=4.00	ml	1.0200	19.13	material	2025-06-01 00:17:14.527303	2025-06-01 00:17:14.527303	\N	\N
4344	335	\N	Adhesivo para P.V.C.	lt	0.2000	25.00	material	2025-06-01 00:17:14.5618	2025-06-01 00:17:14.5618	\N	\N
4345	335	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:17:14.578701	2025-06-01 00:17:14.578701	\N	\N
4346	335	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:17:14.595437	2025-06-01 00:17:14.595437	\N	\N
4347	336	\N	Tubo de PVC de 5 pulg L=6.00m	ml	1.0200	37.67	material	2025-06-01 00:17:14.95833	2025-06-01 00:17:14.95833	\N	\N
4348	336	\N	Adhesivo para P.V.C.	lt	0.2000	25.00	material	2025-06-01 00:17:14.993727	2025-06-01 00:17:14.993727	\N	\N
4349	336	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:17:15.010325	2025-06-01 00:17:15.010325	\N	\N
4350	336	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:17:15.026923	2025-06-01 00:17:15.026923	\N	\N
4351	337	\N	Tubo de PVC de 6 pulg L=6.00	ml	1.0200	54.16	material	2025-06-01 00:17:15.396676	2025-06-01 00:17:15.396676	\N	\N
4352	337	\N	Adhesivo para P.V.C.	lt	0.2000	25.00	material	2025-06-01 00:17:15.430695	2025-06-01 00:17:15.430695	\N	\N
4353	337	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:17:15.447265	2025-06-01 00:17:15.447265	\N	\N
4354	337	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:17:15.464066	2025-06-01 00:17:15.464066	\N	\N
4355	338	\N	Tubo de PVC de 4 pulg L=4.00	ml	1.0200	19.13	material	2025-06-01 00:17:15.83001	2025-06-01 00:17:15.83001	\N	\N
4356	338	\N	Adhesivo para P.V.C.	lt	0.2000	25.00	material	2025-06-01 00:17:15.864263	2025-06-01 00:17:15.864263	\N	\N
4357	338	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:17:15.880969	2025-06-01 00:17:15.880969	\N	\N
4358	338	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:17:15.897568	2025-06-01 00:17:15.897568	\N	\N
4359	339	\N	Tubo de PVC de 2 pulg	ml	1.0200	7.80	material	2025-06-01 00:17:16.259285	2025-06-01 00:17:16.259285	\N	\N
4360	339	\N	Adhesivo para P.V.C.	lt	0.1500	25.00	material	2025-06-01 00:17:16.292813	2025-06-01 00:17:16.292813	\N	\N
4361	339	\N	Ayudante (plomero)	hr	0.7500	12.50	labor	2025-06-01 00:17:16.309572	2025-06-01 00:17:16.309572	\N	\N
4362	339	\N	Maestro plomero	hr	0.7500	17.50	labor	2025-06-01 00:17:16.326459	2025-06-01 00:17:16.326459	\N	\N
4363	340	\N	Tubo de PVC de 3 pulg L=4.00	ml	1.0200	13.25	material	2025-06-01 00:17:16.693049	2025-06-01 00:17:16.693049	\N	\N
4364	340	\N	Adhesivo para P.V.C.	lt	0.2000	25.00	material	2025-06-01 00:17:16.726568	2025-06-01 00:17:16.726568	\N	\N
4365	340	\N	Ayudante (plomero)	hr	0.8000	12.50	labor	2025-06-01 00:17:16.743355	2025-06-01 00:17:16.743355	\N	\N
4366	340	\N	Maestro plomero	hr	0.8000	17.50	labor	2025-06-01 00:17:16.760084	2025-06-01 00:17:16.760084	\N	\N
4367	341	\N	Tierra negra	m3	0.2000	140.00	material	2025-06-01 00:17:17.191605	2025-06-01 00:17:17.191605	\N	\N
4368	341	\N	Grama para jardinera	m2	1.0000	40.25	material	2025-06-01 00:17:17.226147	2025-06-01 00:17:17.226147	\N	\N
4369	342	\N	Tierra negra	m3	0.2000	140.00	material	2025-06-01 00:17:17.581156	2025-06-01 00:17:17.581156	\N	\N
4370	342	\N	Plantas ornamentales para jardineras	m2	1.0000	48.64	material	2025-06-01 00:17:17.616081	2025-06-01 00:17:17.616081	\N	\N
4371	343	\N	Tierra negra	m3	0.5000	140.00	material	2025-06-01 00:17:17.973769	2025-06-01 00:17:17.973769	\N	\N
4372	343	\N	Plantas ornamentales para jardineras	m2	1.0000	48.64	material	2025-06-01 00:17:18.009139	2025-06-01 00:17:18.009139	\N	\N
4373	344	\N	Tierra negra	m3	1.1000	140.00	material	2025-06-01 00:17:18.37009	2025-06-01 00:17:18.37009	\N	\N
4374	345	\N	Cemento portland IP-30	kg	4.0000	1.20	material	2025-06-01 00:17:18.864059	2025-06-01 00:17:18.864059	\N	\N
4375	345	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:17:18.901342	2025-06-01 00:17:18.901342	\N	\N
4376	345	\N	Ladrillo adobito	pza	16.0000	0.65	material	2025-06-01 00:17:18.935925	2025-06-01 00:17:18.935925	\N	\N
4377	345	\N	Ayudante	hr	0.2000	12.50	labor	2025-06-01 00:17:18.952713	2025-06-01 00:17:18.952713	\N	\N
4378	345	\N	Maestro albañil	hr	0.2000	18.75	labor	2025-06-01 00:17:18.969553	2025-06-01 00:17:18.969553	\N	\N
4379	346	\N	Cemento portland IP-30	kg	8.0000	1.20	material	2025-06-01 00:17:19.381998	2025-06-01 00:17:19.381998	\N	\N
4380	346	5	Arena Fina	m3	0.0600	70.00	material	2025-06-01 00:17:19.415127	2025-06-01 00:17:19.415127	\N	\N
4381	346	\N	Pieza de celosía ceramica	pza	25.0000	1.20	material	2025-06-01 00:17:19.450238	2025-06-01 00:17:19.450238	\N	\N
4382	346	\N	Madera para andamio	p2	0.5000	10.00	material	2025-06-01 00:17:19.484927	2025-06-01 00:17:19.484927	\N	\N
4383	346	22	Agua	lt	4.0000	0.06	material	2025-06-01 00:17:19.519866	2025-06-01 00:17:19.519866	\N	\N
4384	346	\N	Ayudante	hr	0.8000	12.50	labor	2025-06-01 00:17:19.536548	2025-06-01 00:17:19.536548	\N	\N
4385	346	\N	Maestro albañil	hr	0.8500	18.75	labor	2025-06-01 00:17:19.55317	2025-06-01 00:17:19.55317	\N	\N
4386	347	\N	Cemento portland IP-30	kg	60.0000	1.20	material	2025-06-01 00:17:19.99529	2025-06-01 00:17:19.99529	\N	\N
4387	347	5	Arena Fina	m3	0.3500	70.00	material	2025-06-01 00:17:20.028439	2025-06-01 00:17:20.028439	\N	\N
4388	347	\N	Ladrillo adobito	pza	515.0000	0.65	material	2025-06-01 00:17:20.062609	2025-06-01 00:17:20.062609	\N	\N
4389	347	22	Agua	lt	350.0000	0.06	material	2025-06-01 00:17:20.095597	2025-06-01 00:17:20.095597	\N	\N
4390	347	\N	Ayudante	hr	5.7000	12.50	labor	2025-06-01 00:17:20.112697	2025-06-01 00:17:20.112697	\N	\N
4391	347	\N	Maestro albañil	hr	7.1200	18.75	labor	2025-06-01 00:17:20.129526	2025-06-01 00:17:20.129526	\N	\N
4392	348	\N	Cemento portland IP-30	kg	20.0000	1.20	material	2025-06-01 00:17:20.55251	2025-06-01 00:17:20.55251	\N	\N
4393	348	5	Arena Fina	m3	0.1200	70.00	material	2025-06-01 00:17:20.585762	2025-06-01 00:17:20.585762	\N	\N
4394	348	\N	Ladrillo adobito	pza	180.0000	0.65	material	2025-06-01 00:17:20.62042	2025-06-01 00:17:20.62042	\N	\N
4395	348	22	Agua	lt	120.0000	0.06	material	2025-06-01 00:17:20.656534	2025-06-01 00:17:20.656534	\N	\N
4396	348	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:17:20.673261	2025-06-01 00:17:20.673261	\N	\N
4397	348	\N	Maestro albañil	hr	2.5000	18.75	labor	2025-06-01 00:17:20.690031	2025-06-01 00:17:20.690031	\N	\N
4398	349	\N	Cemento portland IP-30	kg	4.0000	1.20	material	2025-06-01 00:17:21.141233	2025-06-01 00:17:21.141233	\N	\N
4399	349	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:17:21.174378	2025-06-01 00:17:21.174378	\N	\N
4400	349	\N	Ladrillo adobito	pza	46.0000	0.65	material	2025-06-01 00:17:21.208916	2025-06-01 00:17:21.208916	\N	\N
4401	349	24	Clavos de 3 pulg	kg	0.0100	13.00	material	2025-06-01 00:17:21.242046	2025-06-01 00:17:21.242046	\N	\N
4402	349	\N	Madera para andamio	p2	0.2000	10.00	material	2025-06-01 00:17:21.276704	2025-06-01 00:17:21.276704	\N	\N
4403	349	\N	Alambre de amarre	kg	0.0100	11.00	material	2025-06-01 00:17:21.310323	2025-06-01 00:17:21.310323	\N	\N
4404	349	22	Agua	lt	5.0000	0.06	material	2025-06-01 00:17:21.34402	2025-06-01 00:17:21.34402	\N	\N
4405	349	\N	Ayudante	hr	0.5000	12.50	labor	2025-06-01 00:17:21.360501	2025-06-01 00:17:21.360501	\N	\N
4406	349	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:17:21.376932	2025-06-01 00:17:21.376932	\N	\N
4407	350	\N	Cemento portland IP-30	kg	4.0000	1.20	material	2025-06-01 00:17:21.822708	2025-06-01 00:17:21.822708	\N	\N
4408	350	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:17:21.856239	2025-06-01 00:17:21.856239	\N	\N
4409	350	\N	Ladrillo adobito	pza	13.0000	0.65	material	2025-06-01 00:17:21.890909	2025-06-01 00:17:21.890909	\N	\N
4410	350	24	Clavos de 3 pulg	kg	0.0100	13.00	material	2025-06-01 00:17:21.923078	2025-06-01 00:17:21.923078	\N	\N
4411	350	13	Madera para encofrado	p2	0.1200	8.00	material	2025-06-01 00:17:21.956161	2025-06-01 00:17:21.956161	\N	\N
4412	350	\N	Alambre de amarre	kg	0.0100	11.00	material	2025-06-01 00:17:21.991651	2025-06-01 00:17:21.991651	\N	\N
4413	350	22	Agua	lt	8.0000	0.06	material	2025-06-01 00:17:22.024504	2025-06-01 00:17:22.024504	\N	\N
4414	350	\N	Ayudante	hr	0.4000	12.50	labor	2025-06-01 00:17:22.041328	2025-06-01 00:17:22.041328	\N	\N
4415	350	\N	Maestro albañil	hr	0.4000	18.75	labor	2025-06-01 00:17:22.057981	2025-06-01 00:17:22.057981	\N	\N
4416	351	\N	Cemento portland IP-30	kg	4.0000	1.20	material	2025-06-01 00:17:22.496538	2025-06-01 00:17:22.496538	\N	\N
4417	351	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:17:22.529418	2025-06-01 00:17:22.529418	\N	\N
4418	351	\N	Ladrillo adobito	pza	18.0000	0.65	material	2025-06-01 00:17:22.562709	2025-06-01 00:17:22.562709	\N	\N
4419	351	24	Clavos de 3 pulg	kg	0.0100	13.00	material	2025-06-01 00:17:22.595737	2025-06-01 00:17:22.595737	\N	\N
4420	351	13	Madera para encofrado	p2	0.1200	8.00	material	2025-06-01 00:17:22.628601	2025-06-01 00:17:22.628601	\N	\N
4421	351	\N	Alambre de amarre	kg	0.0100	11.00	material	2025-06-01 00:17:22.662882	2025-06-01 00:17:22.662882	\N	\N
4422	351	22	Agua	lt	8.0000	0.06	material	2025-06-01 00:17:22.696023	2025-06-01 00:17:22.696023	\N	\N
4423	351	\N	Ayudante	hr	0.4000	12.50	labor	2025-06-01 00:17:22.713048	2025-06-01 00:17:22.713048	\N	\N
4424	351	\N	Maestro albañil	hr	0.4000	18.75	labor	2025-06-01 00:17:22.728773	2025-06-01 00:17:22.728773	\N	\N
4425	352	\N	Cemento portland IP-30	kg	4.0000	1.20	material	2025-06-01 00:17:23.17366	2025-06-01 00:17:23.17366	\N	\N
4426	352	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:17:23.206819	2025-06-01 00:17:23.206819	\N	\N
4427	352	\N	Ladrillo adobito	pza	23.0000	0.65	material	2025-06-01 00:17:23.241087	2025-06-01 00:17:23.241087	\N	\N
4428	352	24	Clavos de 3 pulg	kg	0.0100	13.00	material	2025-06-01 00:17:23.274091	2025-06-01 00:17:23.274091	\N	\N
4429	352	13	Madera para encofrado	p2	0.1200	8.00	material	2025-06-01 00:17:23.307021	2025-06-01 00:17:23.307021	\N	\N
4430	352	\N	Alambre de amarre	kg	0.0100	11.00	material	2025-06-01 00:17:23.342247	2025-06-01 00:17:23.342247	\N	\N
4431	352	22	Agua	lt	8.0000	0.06	material	2025-06-01 00:17:23.375322	2025-06-01 00:17:23.375322	\N	\N
4432	352	\N	Ayudante	hr	0.4000	12.50	labor	2025-06-01 00:17:23.393516	2025-06-01 00:17:23.393516	\N	\N
4433	352	\N	Maestro albañil	hr	0.4000	18.75	labor	2025-06-01 00:17:23.410213	2025-06-01 00:17:23.410213	\N	\N
4434	353	\N	Cemento portland IP-30	kg	4.0000	1.20	material	2025-06-01 00:17:23.955719	2025-06-01 00:17:23.955719	\N	\N
4435	353	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:17:23.989484	2025-06-01 00:17:23.989484	\N	\N
4436	353	\N	Ladrillo adobito	pza	26.0000	0.65	material	2025-06-01 00:17:24.024012	2025-06-01 00:17:24.024012	\N	\N
4437	353	24	Clavos de 3 pulg	kg	0.0100	13.00	material	2025-06-01 00:17:24.057005	2025-06-01 00:17:24.057005	\N	\N
4438	353	\N	Madera para andamio	p2	0.1200	10.00	material	2025-06-01 00:17:24.091248	2025-06-01 00:17:24.091248	\N	\N
4439	353	\N	Alambre de amarre	kg	0.0100	11.00	material	2025-06-01 00:17:24.125878	2025-06-01 00:17:24.125878	\N	\N
4440	353	22	Agua	lt	8.0000	0.06	material	2025-06-01 00:17:24.158785	2025-06-01 00:17:24.158785	\N	\N
4441	353	\N	Ayudante	hr	0.4000	12.50	labor	2025-06-01 00:17:24.17544	2025-06-01 00:17:24.17544	\N	\N
4442	353	\N	Maestro albañil	hr	0.4000	18.75	labor	2025-06-01 00:17:24.192235	2025-06-01 00:17:24.192235	\N	\N
4443	354	\N	Cemento portland IP-30	kg	8.0000	1.20	material	2025-06-01 00:17:24.615211	2025-06-01 00:17:24.615211	\N	\N
4444	354	5	Arena Fina	m3	0.0500	70.00	material	2025-06-01 00:17:24.70446	2025-06-01 00:17:24.70446	\N	\N
4445	354	\N	Ladrillo adobito	pza	20.0000	0.65	material	2025-06-01 00:17:24.739173	2025-06-01 00:17:24.739173	\N	\N
4446	354	22	Agua	lt	60.0000	0.06	material	2025-06-01 00:17:24.779337	2025-06-01 00:17:24.779337	\N	\N
4447	354	\N	Ayudante	hr	0.3000	12.50	labor	2025-06-01 00:17:24.796213	2025-06-01 00:17:24.796213	\N	\N
4448	354	\N	Maestro albañil	hr	0.3000	18.75	labor	2025-06-01 00:17:24.813028	2025-06-01 00:17:24.813028	\N	\N
4449	355	\N	Cemento portland IP-30	kg	3.0000	1.20	material	2025-06-01 00:17:25.247353	2025-06-01 00:17:25.247353	\N	\N
4450	355	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:17:25.284988	2025-06-01 00:17:25.284988	\N	\N
4451	355	\N	Celosía cerámica	pza	35.0000	1.80	material	2025-06-01 00:17:25.31922	2025-06-01 00:17:25.31922	\N	\N
4452	355	24	Clavos de 3 pulg	kg	0.0100	13.00	material	2025-06-01 00:17:25.35204	2025-06-01 00:17:25.35204	\N	\N
4453	355	\N	Madera para andamio	p2	0.6000	10.00	material	2025-06-01 00:17:25.386595	2025-06-01 00:17:25.386595	\N	\N
4454	355	\N	Alambre de amarre	kg	0.0300	11.00	material	2025-06-01 00:17:25.420692	2025-06-01 00:17:25.420692	\N	\N
4455	355	22	Agua	lt	10.0000	0.06	material	2025-06-01 00:17:25.453291	2025-06-01 00:17:25.453291	\N	\N
4456	355	\N	Ayudante	hr	0.8000	12.50	labor	2025-06-01 00:17:25.468681	2025-06-01 00:17:25.468681	\N	\N
4457	355	\N	Maestro albañil	hr	0.8000	18.75	labor	2025-06-01 00:17:25.485124	2025-06-01 00:17:25.485124	\N	\N
4458	356	\N	Acero de alta resistencia	kg	0.4200	8.50	material	2025-06-01 00:17:26.056702	2025-06-01 00:17:26.056702	\N	\N
4459	356	\N	Alambre de amarre	kg	0.1000	11.00	material	2025-06-01 00:17:26.090663	2025-06-01 00:17:26.090663	\N	\N
4460	356	\N	Panel 3D (4\\" 2.44X1.22)	pza	0.3400	257.60	material	2025-06-01 00:17:26.124975	2025-06-01 00:17:26.124975	\N	\N
4461	356	\N	Malla de refuerzo plana y en U	pza	0.4200	2.74	material	2025-06-01 00:17:26.16169	2025-06-01 00:17:26.16169	\N	\N
4462	356	\N	Malla de unión y esquinera 1	pza	1.8200	1.82	material	2025-06-01 00:17:26.195924	2025-06-01 00:17:26.195924	\N	\N
4463	356	\N	Ayudante	hr	0.2300	12.50	labor	2025-06-01 00:17:26.212582	2025-06-01 00:17:26.212582	\N	\N
4464	356	\N	Maestro albañil	hr	0.1500	18.75	labor	2025-06-01 00:17:26.229653	2025-06-01 00:17:26.229653	\N	\N
4465	357	\N	bloque de yeso	m2	1.0000	122.50	material	2025-06-01 00:17:26.624873	2025-06-01 00:17:26.624873	\N	\N
4466	357	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:17:26.641541	2025-06-01 00:17:26.641541	\N	\N
4467	357	\N	Maestro albañil	hr	1.0000	18.75	labor	2025-06-01 00:17:26.658012	2025-06-01 00:17:26.658012	\N	\N
4468	358	\N	Cemento portland IP-30	kg	6.0000	1.20	material	2025-06-01 00:17:27.077796	2025-06-01 00:17:27.077796	\N	\N
4469	358	\N	bloque prefabricado	pza	18.0000	5.30	material	2025-06-01 00:17:27.111962	2025-06-01 00:17:27.111962	\N	\N
4470	358	\N	Ayudante	hr	0.3000	12.50	labor	2025-06-01 00:17:27.128774	2025-06-01 00:17:27.128774	\N	\N
4471	358	\N	Maestro albañil	hr	0.3000	18.75	labor	2025-06-01 00:17:27.145601	2025-06-01 00:17:27.145601	\N	\N
4472	359	\N	Cemento portland IP-30	kg	8.0000	1.20	material	2025-06-01 00:17:27.571319	2025-06-01 00:17:27.571319	\N	\N
4473	359	5	Arena Fina	m3	0.0500	70.00	material	2025-06-01 00:17:27.605208	2025-06-01 00:17:27.605208	\N	\N
4474	359	24	Clavos de 3 pulg	kg	0.0200	13.00	material	2025-06-01 00:17:27.638135	2025-06-01 00:17:27.638135	\N	\N
4475	359	\N	Madera para andamio	p2	0.6000	10.00	material	2025-06-01 00:17:27.672594	2025-06-01 00:17:27.672594	\N	\N
4476	359	\N	Alambre de amarre	kg	0.0300	11.00	material	2025-06-01 00:17:27.705779	2025-06-01 00:17:27.705779	\N	\N
4477	359	22	Agua	lt	15.0000	0.06	material	2025-06-01 00:17:27.738346	2025-06-01 00:17:27.738346	\N	\N
4478	359	\N	Bloque de cemento celosía	m2	1.1000	36.48	material	2025-06-01 00:17:27.772831	2025-06-01 00:17:27.772831	\N	\N
4479	359	\N	Ayudante	hr	0.6000	12.50	labor	2025-06-01 00:17:27.789375	2025-06-01 00:17:27.789375	\N	\N
4480	359	\N	Maestro albañil	hr	0.6000	18.75	labor	2025-06-01 00:17:27.806027	2025-06-01 00:17:27.806027	\N	\N
4481	360	\N	Cemento portland IP-30	kg	10.0000	1.20	material	2025-06-01 00:17:28.245727	2025-06-01 00:17:28.245727	\N	\N
4482	360	5	Arena Fina	m3	0.0800	70.00	material	2025-06-01 00:17:28.279095	2025-06-01 00:17:28.279095	\N	\N
4483	360	\N	Ladrillo adobito	pza	65.0000	0.65	material	2025-06-01 00:17:28.313448	2025-06-01 00:17:28.313448	\N	\N
4484	360	24	Clavos de 3 pulg	kg	0.0200	13.00	material	2025-06-01 00:17:28.346398	2025-06-01 00:17:28.346398	\N	\N
4485	360	\N	Madera para andamio	p2	0.3000	10.00	material	2025-06-01 00:17:28.38099	2025-06-01 00:17:28.38099	\N	\N
4486	360	\N	Alambre de amarre	kg	0.0300	11.00	material	2025-06-01 00:17:28.415159	2025-06-01 00:17:28.415159	\N	\N
4487	360	22	Agua	lt	20.0000	0.06	material	2025-06-01 00:17:28.448008	2025-06-01 00:17:28.448008	\N	\N
4488	360	\N	Ayudante	hr	0.8000	12.50	labor	2025-06-01 00:17:28.46731	2025-06-01 00:17:28.46731	\N	\N
4489	360	\N	Maestro albañil	hr	1.1000	18.75	labor	2025-06-01 00:17:28.487488	2025-06-01 00:17:28.487488	\N	\N
4490	361	\N	Cemento portland IP-30	kg	20.0000	1.20	material	2025-06-01 00:17:28.904867	2025-06-01 00:17:28.904867	\N	\N
4491	361	5	Arena Fina	m3	0.1000	70.00	material	2025-06-01 00:17:28.940903	2025-06-01 00:17:28.940903	\N	\N
4492	361	\N	Ladrillo adobito	pza	130.0000	0.65	material	2025-06-01 00:17:29.057448	2025-06-01 00:17:29.057448	\N	\N
4493	361	\N	Madera para andamio	p2	0.5800	10.00	material	2025-06-01 00:17:29.09499	2025-06-01 00:17:29.09499	\N	\N
4494	361	22	Agua	lt	120.0000	0.06	material	2025-06-01 00:17:29.12814	2025-06-01 00:17:29.12814	\N	\N
4495	361	\N	Ayudante	hr	1.5000	12.50	labor	2025-06-01 00:17:29.144856	2025-06-01 00:17:29.144856	\N	\N
4496	361	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:17:29.162055	2025-06-01 00:17:29.162055	\N	\N
4497	362	\N	Cemento portland IP-30	kg	4.0000	1.20	material	2025-06-01 00:17:29.603102	2025-06-01 00:17:29.603102	\N	\N
4498	362	5	Arena Fina	m3	0.0400	70.00	material	2025-06-01 00:17:29.636294	2025-06-01 00:17:29.636294	\N	\N
4499	362	\N	Ladrillo adobito	pza	22.0000	0.65	material	2025-06-01 00:17:29.670746	2025-06-01 00:17:29.670746	\N	\N
4500	362	24	Clavos de 3 pulg	kg	0.0200	13.00	material	2025-06-01 00:17:29.703678	2025-06-01 00:17:29.703678	\N	\N
4501	362	\N	Madera para andamio	p2	0.3000	10.00	material	2025-06-01 00:17:29.739348	2025-06-01 00:17:29.739348	\N	\N
4502	362	\N	Alambre de amarre	kg	0.0300	11.00	material	2025-06-01 00:17:29.773434	2025-06-01 00:17:29.773434	\N	\N
4503	362	22	Agua	lt	20.0000	0.06	material	2025-06-01 00:17:29.806406	2025-06-01 00:17:29.806406	\N	\N
4504	362	\N	Ayudante	hr	0.4000	12.50	labor	2025-06-01 00:17:29.823113	2025-06-01 00:17:29.823113	\N	\N
4505	362	\N	Maestro albañil	hr	0.6000	18.75	labor	2025-06-01 00:17:29.840594	2025-06-01 00:17:29.840594	\N	\N
4506	363	\N	Cemento portland IP-30	kg	10.0000	1.20	material	2025-06-01 00:17:30.329209	2025-06-01 00:17:30.329209	\N	\N
4507	363	5	Arena Fina	m3	0.0500	70.00	material	2025-06-01 00:17:30.364772	2025-06-01 00:17:30.364772	\N	\N
4508	363	\N	Ladrillo adobito	pza	65.0000	0.65	material	2025-06-01 00:17:30.399177	2025-06-01 00:17:30.399177	\N	\N
4509	363	24	Clavos de 3 pulg	kg	0.0200	13.00	material	2025-06-01 00:17:30.431545	2025-06-01 00:17:30.431545	\N	\N
4510	363	\N	Madera para andamio	p2	0.4000	10.00	material	2025-06-01 00:17:30.465858	2025-06-01 00:17:30.465858	\N	\N
4511	363	\N	Alambre de amarre	kg	0.0200	11.00	material	2025-06-01 00:17:30.50002	2025-06-01 00:17:30.50002	\N	\N
4512	363	22	Agua	lt	20.0000	0.06	material	2025-06-01 00:17:30.533548	2025-06-01 00:17:30.533548	\N	\N
4513	363	\N	Ayudante	hr	0.8000	12.50	labor	2025-06-01 00:17:30.550066	2025-06-01 00:17:30.550066	\N	\N
4514	363	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:17:30.56643	2025-06-01 00:17:30.56643	\N	\N
4515	364	\N	Cemento portland IP-30	kg	10.0000	1.20	material	2025-06-01 00:17:31.090984	2025-06-01 00:17:31.090984	\N	\N
4516	364	5	Arena Fina	m3	0.0500	70.00	material	2025-06-01 00:17:31.124892	2025-06-01 00:17:31.124892	\N	\N
4517	364	\N	Ladrillo adobito	pza	65.0000	0.65	material	2025-06-01 00:17:31.159429	2025-06-01 00:17:31.159429	\N	\N
4518	364	24	Clavos de 3 pulg	kg	0.0200	13.00	material	2025-06-01 00:17:31.192421	2025-06-01 00:17:31.192421	\N	\N
4519	364	\N	Madera para andamio	p2	0.4000	10.00	material	2025-06-01 00:17:31.227138	2025-06-01 00:17:31.227138	\N	\N
4520	364	\N	Alambre de amarre	kg	0.0200	11.00	material	2025-06-01 00:17:31.262356	2025-06-01 00:17:31.262356	\N	\N
4521	364	22	Agua	lt	20.0000	0.06	material	2025-06-01 00:17:31.296887	2025-06-01 00:17:31.296887	\N	\N
4522	364	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:17:31.313832	2025-06-01 00:17:31.313832	\N	\N
4523	364	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:17:31.330754	2025-06-01 00:17:31.330754	\N	\N
4524	365	\N	Cemento portland IP-30	kg	20.0000	1.20	material	2025-06-01 00:17:31.766657	2025-06-01 00:17:31.766657	\N	\N
4525	365	5	Arena Fina	m3	0.1000	70.00	material	2025-06-01 00:17:31.799764	2025-06-01 00:17:31.799764	\N	\N
4526	365	\N	Ladrillo adobito	pza	130.0000	0.65	material	2025-06-01 00:17:31.835036	2025-06-01 00:17:31.835036	\N	\N
4527	365	24	Clavos de 3 pulg	kg	0.0400	13.00	material	2025-06-01 00:17:31.868187	2025-06-01 00:17:31.868187	\N	\N
4528	365	\N	Madera para andamio	p2	0.8000	10.00	material	2025-06-01 00:17:31.90262	2025-06-01 00:17:31.90262	\N	\N
4529	365	\N	Alambre de amarre	kg	0.0400	11.00	material	2025-06-01 00:17:31.942929	2025-06-01 00:17:31.942929	\N	\N
4530	365	22	Agua	lt	40.0000	0.06	material	2025-06-01 00:17:31.976209	2025-06-01 00:17:31.976209	\N	\N
4531	365	\N	Ayudante	hr	1.6000	12.50	labor	2025-06-01 00:17:31.992991	2025-06-01 00:17:31.992991	\N	\N
4532	365	\N	Maestro albañil	hr	3.0000	18.75	labor	2025-06-01 00:17:32.010962	2025-06-01 00:17:32.010962	\N	\N
4533	366	\N	Cemento portland IP-30	kg	8.0000	1.20	material	2025-06-01 00:17:32.453355	2025-06-01 00:17:32.453355	\N	\N
4535	366	\N	Ladrillo Ceramico de 6 H tabique	pza	25.0000	1.20	material	2025-06-01 00:17:32.523477	2025-06-01 00:17:32.523477	\N	\N
4536	366	\N	Madera para andamio	p2	0.5000	10.00	material	2025-06-01 00:17:32.55951	2025-06-01 00:17:32.55951	\N	\N
4537	366	22	Agua	lt	4.0000	0.06	material	2025-06-01 00:17:32.593552	2025-06-01 00:17:32.593552	\N	\N
4538	366	\N	Ayudante	hr	0.3000	12.50	labor	2025-06-01 00:17:32.613248	2025-06-01 00:17:32.613248	\N	\N
4539	366	\N	Maestro albañil	hr	1.2500	18.75	labor	2025-06-01 00:17:32.629908	2025-06-01 00:17:32.629908	\N	\N
4540	367	\N	Cemento portland IP-30	kg	12.0000	1.20	material	2025-06-01 00:17:33.185851	2025-06-01 00:17:33.185851	\N	\N
4541	367	5	Arena Fina	m3	0.0800	70.00	material	2025-06-01 00:17:33.219715	2025-06-01 00:17:33.219715	\N	\N
4542	367	\N	Ladrillo Ceramico de 6 H tabique	pza	45.0000	1.20	material	2025-06-01 00:17:33.255497	2025-06-01 00:17:33.255497	\N	\N
4543	367	\N	Madera para andamio	p2	0.5000	10.00	material	2025-06-01 00:17:33.289739	2025-06-01 00:17:33.289739	\N	\N
4544	367	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:17:33.322635	2025-06-01 00:17:33.322635	\N	\N
4545	367	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:17:33.339284	2025-06-01 00:17:33.339284	\N	\N
4546	367	\N	Maestro albañil	hr	1.0000	18.75	labor	2025-06-01 00:17:33.358029	2025-06-01 00:17:33.358029	\N	\N
4547	368	\N	Cemento portland IP-30	kg	9.0000	1.20	material	2025-06-01 00:17:33.922394	2025-06-01 00:17:33.922394	\N	\N
4548	368	5	Arena Fina	m3	0.0600	70.00	material	2025-06-01 00:17:33.955729	2025-06-01 00:17:33.955729	\N	\N
4549	368	\N	Ladrillo Ceramico de 6 H tabique	pza	19.0000	1.20	material	2025-06-01 00:17:33.990615	2025-06-01 00:17:33.990615	\N	\N
4550	368	\N	Madera para andamio	p2	0.5000	10.00	material	2025-06-01 00:17:34.025419	2025-06-01 00:17:34.025419	\N	\N
4551	368	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:17:34.060362	2025-06-01 00:17:34.060362	\N	\N
4552	368	\N	Ayudante	hr	0.7000	12.50	labor	2025-06-01 00:17:34.077198	2025-06-01 00:17:34.077198	\N	\N
4553	368	\N	Maestro albañil	hr	0.7500	18.75	labor	2025-06-01 00:17:34.094193	2025-06-01 00:17:34.094193	\N	\N
4554	369	\N	Cemento portland IP-30	kg	30.0000	1.20	material	2025-06-01 00:17:34.613346	2025-06-01 00:17:34.613346	\N	\N
4555	369	5	Arena Fina	m3	0.2000	70.00	material	2025-06-01 00:17:34.649389	2025-06-01 00:17:34.649389	\N	\N
4556	369	\N	Ladrillo Ceramico de 21 H esp visto	pza	44.0000	1.31	material	2025-06-01 00:17:34.684799	2025-06-01 00:17:34.684799	\N	\N
4557	369	24	Clavos de 3 pulg	kg	0.0200	13.00	material	2025-06-01 00:17:34.722893	2025-06-01 00:17:34.722893	\N	\N
4558	369	\N	Madera para andamio	p2	0.6000	10.00	material	2025-06-01 00:17:34.75757	2025-06-01 00:17:34.75757	\N	\N
4559	369	\N	Alambre de amarre	kg	0.0300	11.00	material	2025-06-01 00:17:34.792247	2025-06-01 00:17:34.792247	\N	\N
4560	369	22	Agua	lt	35.0000	0.06	material	2025-06-01 00:17:34.826994	2025-06-01 00:17:34.826994	\N	\N
4561	369	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:17:34.845077	2025-06-01 00:17:34.845077	\N	\N
4562	369	\N	Maestro albañil	hr	2.2500	18.75	labor	2025-06-01 00:17:34.861938	2025-06-01 00:17:34.861938	\N	\N
4563	370	\N	Cemento portland IP-30	kg	0.6000	1.20	material	2025-06-01 00:17:35.363924	2025-06-01 00:17:35.363924	\N	\N
4564	370	5	Arena Fina	m3	0.4000	70.00	material	2025-06-01 00:17:35.398352	2025-06-01 00:17:35.398352	\N	\N
4565	370	\N	Ladrillo Ceramico de 21 H esp visto	pza	88.0000	1.31	material	2025-06-01 00:17:35.432808	2025-06-01 00:17:35.432808	\N	\N
4566	370	24	Clavos de 3 pulg	kg	0.0200	13.00	material	2025-06-01 00:17:35.4647	2025-06-01 00:17:35.4647	\N	\N
4567	370	\N	Madera para andamio	p2	0.6000	10.00	material	2025-06-01 00:17:35.49944	2025-06-01 00:17:35.49944	\N	\N
4568	370	\N	Alambre de amarre	kg	0.0300	11.00	material	2025-06-01 00:17:35.535327	2025-06-01 00:17:35.535327	\N	\N
4569	370	22	Agua	lt	70.0000	0.06	material	2025-06-01 00:17:35.569842	2025-06-01 00:17:35.569842	\N	\N
4570	370	\N	Ayudante	hr	3.0000	12.50	labor	2025-06-01 00:17:35.58658	2025-06-01 00:17:35.58658	\N	\N
4571	370	\N	Maestro albañil	hr	3.5000	18.75	labor	2025-06-01 00:17:35.603444	2025-06-01 00:17:35.603444	\N	\N
4572	371	\N	Cemento portland IP-30	kg	12.0000	1.20	material	2025-06-01 00:17:36.050896	2025-06-01 00:17:36.050896	\N	\N
4573	371	5	Arena Fina	m3	0.0800	70.00	material	2025-06-01 00:17:36.084031	2025-06-01 00:17:36.084031	\N	\N
4574	371	\N	Ladrillo adobito	pza	65.0000	0.65	material	2025-06-01 00:17:36.118192	2025-06-01 00:17:36.118192	\N	\N
4575	371	24	Clavos de 3 pulg	kg	0.0200	13.00	material	2025-06-01 00:17:36.151273	2025-06-01 00:17:36.151273	\N	\N
4576	371	\N	Madera para andamio	p2	0.3000	10.00	material	2025-06-01 00:17:36.186191	2025-06-01 00:17:36.186191	\N	\N
4577	371	\N	Alambre de amarre	kg	0.0300	11.00	material	2025-06-01 00:17:36.222215	2025-06-01 00:17:36.222215	\N	\N
4578	371	22	Agua	lt	20.0000	0.06	material	2025-06-01 00:17:36.255349	2025-06-01 00:17:36.255349	\N	\N
4579	371	\N	Ayudante	hr	0.8000	12.50	labor	2025-06-01 00:17:36.27277	2025-06-01 00:17:36.27277	\N	\N
4580	371	\N	Maestro albañil	hr	1.1000	18.75	labor	2025-06-01 00:17:36.289273	2025-06-01 00:17:36.289273	\N	\N
4581	372	\N	Cemento portland IP-30	kg	18.0000	1.20	material	2025-06-01 00:17:36.709407	2025-06-01 00:17:36.709407	\N	\N
4582	372	5	Arena Fina	m3	0.1000	70.00	material	2025-06-01 00:17:36.742984	2025-06-01 00:17:36.742984	\N	\N
4583	372	\N	Ladrillo adobito	pza	130.0000	0.65	material	2025-06-01 00:17:36.776591	2025-06-01 00:17:36.776591	\N	\N
4584	372	22	Agua	lt	120.0000	0.06	material	2025-06-01 00:17:36.810505	2025-06-01 00:17:36.810505	\N	\N
4585	372	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:17:36.827321	2025-06-01 00:17:36.827321	\N	\N
4586	372	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:17:36.844314	2025-06-01 00:17:36.844314	\N	\N
4587	373	\N	Cemento portland IP-30	kg	30.0000	1.20	material	2025-06-01 00:17:37.26494	2025-06-01 00:17:37.26494	\N	\N
4588	373	\N	Arenilla	m3	0.1000	100.00	material	2025-06-01 00:17:37.299887	2025-06-01 00:17:37.299887	\N	\N
4589	373	\N	Ladrillo adobito	pza	126.0000	0.65	material	2025-06-01 00:17:37.3357	2025-06-01 00:17:37.3357	\N	\N
4590	373	\N	Madera para andamio	p2	0.5800	10.00	material	2025-06-01 00:17:37.370611	2025-06-01 00:17:37.370611	\N	\N
4591	373	22	Agua	lt	42.0000	0.06	material	2025-06-01 00:17:37.404703	2025-06-01 00:17:37.404703	\N	\N
4592	373	\N	Ayudante	hr	2.5000	12.50	labor	2025-06-01 00:17:37.422001	2025-06-01 00:17:37.422001	\N	\N
4593	373	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:17:37.439485	2025-06-01 00:17:37.439485	\N	\N
4594	374	\N	Acero de alta resistencia	kg	2.0000	8.50	material	2025-06-01 00:17:37.96726	2025-06-01 00:17:37.96726	\N	\N
4595	374	105	Cemento blanco	kg	6.0000	7.00	material	2025-06-01 00:17:38.000452	2025-06-01 00:17:38.000452	\N	\N
4596	374	\N	Cemento portland IP-30	kg	21.0000	1.20	material	2025-06-01 00:17:38.035637	2025-06-01 00:17:38.035637	\N	\N
4597	374	\N	Arenilla	m3	0.0300	100.00	material	2025-06-01 00:17:38.070272	2025-06-01 00:17:38.070272	\N	\N
4598	374	\N	Ripio rodado	m3	0.0500	170.00	material	2025-06-01 00:17:38.104758	2025-06-01 00:17:38.104758	\N	\N
4599	374	\N	Revestimiento cerámica esmaltada	m2	1.0000	65.00	material	2025-06-01 00:17:38.139462	2025-06-01 00:17:38.139462	\N	\N
4600	374	23	Clavos de 2 pulg	kg	0.0900	13.00	material	2025-06-01 00:17:38.172678	2025-06-01 00:17:38.172678	\N	\N
4601	374	13	Madera para encofrado	p2	8.0000	8.00	material	2025-06-01 00:17:38.205639	2025-06-01 00:17:38.205639	\N	\N
4602	374	\N	Alambre de amarre	kg	0.0900	11.00	material	2025-06-01 00:17:38.240426	2025-06-01 00:17:38.240426	\N	\N
4603	374	22	Agua	lt	12.0000	0.06	material	2025-06-01 00:17:38.273416	2025-06-01 00:17:38.273416	\N	\N
4604	374	\N	Ayudante	hr	5.0000	12.50	labor	2025-06-01 00:17:38.290045	2025-06-01 00:17:38.290045	\N	\N
4605	374	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:17:38.307247	2025-06-01 00:17:38.307247	\N	\N
4606	375	\N	Acero de alta resistencia	kg	2.0000	8.50	material	2025-06-01 00:17:38.765233	2025-06-01 00:17:38.765233	\N	\N
4607	375	105	Cemento blanco	kg	6.0000	7.00	material	2025-06-01 00:17:38.798242	2025-06-01 00:17:38.798242	\N	\N
4608	375	\N	Cemento portland IP-30	kg	21.0000	1.20	material	2025-06-01 00:17:38.834517	2025-06-01 00:17:38.834517	\N	\N
4609	375	\N	Arenilla	m3	0.0300	100.00	material	2025-06-01 00:17:38.86891	2025-06-01 00:17:38.86891	\N	\N
4610	375	\N	Ripio rodado	m3	0.0500	170.00	material	2025-06-01 00:17:38.903022	2025-06-01 00:17:38.903022	\N	\N
4611	375	\N	Azulejo blanco de 15x15cm	m2	1.0000	35.00	material	2025-06-01 00:17:38.938162	2025-06-01 00:17:38.938162	\N	\N
4612	375	23	Clavos de 2 pulg	kg	0.0900	13.00	material	2025-06-01 00:17:38.981612	2025-06-01 00:17:38.981612	\N	\N
4613	375	13	Madera para encofrado	p2	8.0000	8.00	material	2025-06-01 00:17:39.014551	2025-06-01 00:17:39.014551	\N	\N
4614	375	\N	Alambre de amarre	kg	0.0900	11.00	material	2025-06-01 00:17:39.048817	2025-06-01 00:17:39.048817	\N	\N
4615	375	22	Agua	lt	12.0000	0.06	material	2025-06-01 00:17:39.082081	2025-06-01 00:17:39.082081	\N	\N
4616	375	\N	Ayudante	hr	5.0000	12.50	labor	2025-06-01 00:17:39.098945	2025-06-01 00:17:39.098945	\N	\N
4617	375	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:17:39.116556	2025-06-01 00:17:39.116556	\N	\N
4618	376	\N	Acero de alta resistencia	kg	2.0000	8.50	material	2025-06-01 00:17:39.559077	2025-06-01 00:17:39.559077	\N	\N
4619	376	105	Cemento blanco	kg	6.0000	7.00	material	2025-06-01 00:17:39.592264	2025-06-01 00:17:39.592264	\N	\N
4620	376	\N	Cemento portland IP-30	kg	21.0000	1.20	material	2025-06-01 00:17:39.630517	2025-06-01 00:17:39.630517	\N	\N
4621	376	\N	Arenilla	m3	0.0300	100.00	material	2025-06-01 00:17:39.66506	2025-06-01 00:17:39.66506	\N	\N
4622	376	\N	Ripio rodado	m3	0.0500	170.00	material	2025-06-01 00:17:39.700045	2025-06-01 00:17:39.700045	\N	\N
4623	376	\N	Cerámica picada	m2	1.0000	7.30	material	2025-06-01 00:17:39.734724	2025-06-01 00:17:39.734724	\N	\N
4624	376	23	Clavos de 2 pulg	kg	0.0900	13.00	material	2025-06-01 00:17:39.768057	2025-06-01 00:17:39.768057	\N	\N
4625	376	13	Madera para encofrado	p2	8.0000	8.00	material	2025-06-01 00:17:39.801011	2025-06-01 00:17:39.801011	\N	\N
4626	376	\N	Alambre de amarre	kg	0.0900	11.00	material	2025-06-01 00:17:39.834703	2025-06-01 00:17:39.834703	\N	\N
4627	376	22	Agua	lt	12.0000	0.06	material	2025-06-01 00:17:39.867952	2025-06-01 00:17:39.867952	\N	\N
4628	376	\N	Ayudante	hr	5.0000	12.50	labor	2025-06-01 00:17:39.884614	2025-06-01 00:17:39.884614	\N	\N
4629	376	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:17:39.901892	2025-06-01 00:17:39.901892	\N	\N
4630	377	\N	Meson de madera 60cm	ml	1.0000	380.00	material	2025-06-01 00:17:40.277814	2025-06-01 00:17:40.277814	\N	\N
4631	377	\N	Ayudante (carpintero)	hr	1.0000	12.50	labor	2025-06-01 00:17:40.294772	2025-06-01 00:17:40.294772	\N	\N
4632	377	\N	Maestro carpintero	hr	1.0000	15.00	labor	2025-06-01 00:17:40.311576	2025-06-01 00:17:40.311576	\N	\N
4633	378	\N	Cemento portland IP-30	kg	20.0000	1.20	material	2025-06-01 00:17:40.725918	2025-06-01 00:17:40.725918	\N	\N
4634	378	\N	Arenilla	m3	0.0200	100.00	material	2025-06-01 00:17:40.761103	2025-06-01 00:17:40.761103	\N	\N
4635	378	\N	Ladrillo adobito	pza	65.0000	0.65	material	2025-06-01 00:17:40.795916	2025-06-01 00:17:40.795916	\N	\N
4636	378	\N	Meson marmol reconstituido 60cm	ml	1.0000	520.00	material	2025-06-01 00:17:40.831605	2025-06-01 00:17:40.831605	\N	\N
4637	378	22	Agua	lt	12.0000	0.06	material	2025-06-01 00:17:40.865068	2025-06-01 00:17:40.865068	\N	\N
4638	378	\N	Ayudante	hr	8.0000	12.50	labor	2025-06-01 00:17:40.881836	2025-06-01 00:17:40.881836	\N	\N
4639	378	\N	Maestro albañil	hr	8.0000	18.75	labor	2025-06-01 00:17:40.898771	2025-06-01 00:17:40.898771	\N	\N
4640	379	\N	Cemento portland IP-30	kg	20.0000	1.20	material	2025-06-01 00:17:41.440438	2025-06-01 00:17:41.440438	\N	\N
4641	379	\N	Arenilla	m3	0.0200	100.00	material	2025-06-01 00:17:41.482907	2025-06-01 00:17:41.482907	\N	\N
4642	379	\N	Ladrillo adobito	pza	50.0000	0.65	material	2025-06-01 00:17:41.517756	2025-06-01 00:17:41.517756	\N	\N
4643	379	\N	Meson de granito 60cm	ml	1.0000	706.50	material	2025-06-01 00:17:41.551748	2025-06-01 00:17:41.551748	\N	\N
4644	379	22	Agua	lt	12.0000	0.06	material	2025-06-01 00:17:41.585076	2025-06-01 00:17:41.585076	\N	\N
4645	379	\N	Ayudante	hr	3.0000	12.50	labor	2025-06-01 00:17:41.601815	2025-06-01 00:17:41.601815	\N	\N
4646	379	\N	Maestro albañil	hr	3.0000	18.75	labor	2025-06-01 00:17:41.618935	2025-06-01 00:17:41.618935	\N	\N
4647	380	\N	Rejilla metálica para división interior de roperos (prof. 50cm)	ml	2.0000	213.00	material	2025-06-01 00:17:42.054485	2025-06-01 00:17:42.054485	\N	\N
4648	381	\N	Tinglado metálico	m2	1.0000	350.00	material	2025-06-01 00:17:42.41951	2025-06-01 00:17:42.41951	\N	\N
4649	382	\N	Retro-excavadora	hr	0.0500	241.50	equipment	2025-06-01 00:17:42.848217	2025-06-01 00:17:42.848217	\N	\N
4650	382	\N	Volquete de 5 m3	hr	0.0500	80.50	equipment	2025-06-01 00:17:42.86743	2025-06-01 00:17:42.86743	\N	\N
4651	383	\N	Ayudante 6	hr	3.0000	12.50	labor	2025-06-01 00:17:43.217317	2025-06-01 00:17:43.217317	\N	\N
4652	383	\N	Operador de Retro-excavadora	hr	0.0500	23.10	labor	2025-06-01 00:17:43.23442	2025-06-01 00:17:43.23442	\N	\N
4653	383	\N	Operador de Volquete	hr	0.3200	12.16	labor	2025-06-01 00:17:43.251428	2025-06-01 00:17:43.251428	\N	\N
4654	383	\N	Retro-excavadora	hr	0.0500	241.50	equipment	2025-06-01 00:17:43.268679	2025-06-01 00:17:43.268679	\N	\N
4655	383	\N	Volquete de 5 m3	hr	0.3200	80.50	equipment	2025-06-01 00:17:43.285829	2025-06-01 00:17:43.285829	\N	\N
4656	384	\N	Ayudante 6	hr	3.0000	12.50	labor	2025-06-01 00:17:43.666548	2025-06-01 00:17:43.666548	\N	\N
4657	384	\N	Operador de Retro-excavadora	hr	0.0500	23.10	labor	2025-06-01 00:17:43.683283	2025-06-01 00:17:43.683283	\N	\N
4658	384	\N	Operador de Volquete	hr	0.3200	12.16	labor	2025-06-01 00:17:43.700199	2025-06-01 00:17:43.700199	\N	\N
4659	384	\N	Retro-excavadora	hr	0.0500	241.50	equipment	2025-06-01 00:17:43.717257	2025-06-01 00:17:43.717257	\N	\N
4660	384	\N	Volquete de 5 m3	hr	0.3200	80.50	equipment	2025-06-01 00:17:43.734116	2025-06-01 00:17:43.734116	\N	\N
4661	385	\N	Ayudante	hr	2.2000	12.50	labor	2025-06-01 00:17:44.106046	2025-06-01 00:17:44.106046	\N	\N
4662	385	\N	Maestro albañil	hr	0.2000	18.75	labor	2025-06-01 00:17:44.126818	2025-06-01 00:17:44.126818	\N	\N
4663	386	\N	Personal para limpieza	gbl	1.0000	300.00	labor	2025-06-01 00:17:44.628328	2025-06-01 00:17:44.628328	\N	\N
4664	386	\N	Maquinaria para limpieza	gbl	1.0000	3.88	equipment	2025-06-01 00:17:44.645188	2025-06-01 00:17:44.645188	\N	\N
4665	387	\N	Cemento portland IP-30	kg	20.0000	1.20	material	2025-06-01 00:17:45.082326	2025-06-01 00:17:45.082326	\N	\N
4666	387	5	Arena Fina	m3	0.0700	70.00	material	2025-06-01 00:17:45.119397	2025-06-01 00:17:45.119397	\N	\N
4667	387	\N	Ladrillo adobito	pza	130.0000	0.65	material	2025-06-01 00:17:45.153975	2025-06-01 00:17:45.153975	\N	\N
4668	387	\N	Placa de entrega de obra	pza	1.0000	324.00	material	2025-06-01 00:17:45.212119	2025-06-01 00:17:45.212119	\N	\N
4669	387	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:17:45.228875	2025-06-01 00:17:45.228875	\N	\N
4670	387	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:17:45.24567	2025-06-01 00:17:45.24567	\N	\N
4671	388	\N	Materiales para instalación de obrador	gbl	0.5000	200.00	material	2025-06-01 00:17:45.685246	2025-06-01 00:17:45.685246	\N	\N
4672	388	\N	Personal para instalación de obrador	gbl	0.5000	200.00	labor	2025-06-01 00:17:45.701816	2025-06-01 00:17:45.701816	\N	\N
4673	389	\N	Letrero de obra	pza	1.0000	250.00	material	2025-06-01 00:17:46.14857	2025-06-01 00:17:46.14857	\N	\N
4674	389	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:17:46.165277	2025-06-01 00:17:46.165277	\N	\N
4675	389	\N	Maestro albañil	hr	1.0000	18.75	labor	2025-06-01 00:17:46.183039	2025-06-01 00:17:46.183039	\N	\N
4676	390	\N	Personal para limpieza	gbl	1.0000	300.00	labor	2025-06-01 00:17:46.521358	2025-06-01 00:17:46.521358	\N	\N
4677	390	\N	Maquinaria para limpieza	gbl	1.0000	3.88	equipment	2025-06-01 00:17:46.53824	2025-06-01 00:17:46.53824	\N	\N
4678	391	\N	Arenilla	m3	1.2000	100.00	material	2025-06-01 00:17:46.915745	2025-06-01 00:17:46.915745	\N	\N
4679	391	22	Agua	lt	60.0000	0.06	material	2025-06-01 00:17:46.950097	2025-06-01 00:17:46.950097	\N	\N
4680	391	\N	Maestro albañil	hr	0.1000	18.75	labor	2025-06-01 00:17:46.966994	2025-06-01 00:17:46.966994	\N	\N
4681	392	\N	Tierra de relleno	m3	1.2000	60.00	material	2025-06-01 00:17:47.421008	2025-06-01 00:17:47.421008	\N	\N
4682	392	22	Agua	lt	60.0000	0.06	material	2025-06-01 00:17:47.459163	2025-06-01 00:17:47.459163	\N	\N
4683	392	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:17:47.476179	2025-06-01 00:17:47.476179	\N	\N
4684	392	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:17:47.492916	2025-06-01 00:17:47.492916	\N	\N
4685	393	22	Agua	lt	60.0000	0.06	material	2025-06-01 00:17:47.88938	2025-06-01 00:17:47.88938	\N	\N
4686	393	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:17:47.906469	2025-06-01 00:17:47.906469	\N	\N
4687	393	\N	Maestro albañil	hr	0.4100	18.75	labor	2025-06-01 00:17:47.923173	2025-06-01 00:17:47.923173	\N	\N
4688	394	\N	Cal de blanqueo	kg	0.2000	0.90	material	2025-06-01 00:17:48.323275	2025-06-01 00:17:48.323275	\N	\N
4689	394	23	Clavos de 2 pulg	kg	0.0100	13.00	material	2025-06-01 00:17:48.356394	2025-06-01 00:17:48.356394	\N	\N
4690	394	\N	Listón de 1x2 pulg	ml	0.1000	8.00	material	2025-06-01 00:17:48.391002	2025-06-01 00:17:48.391002	\N	\N
4691	394	\N	Listón de 2x2 pulg	ml	0.1200	12.00	material	2025-06-01 00:17:48.426846	2025-06-01 00:17:48.426846	\N	\N
4692	394	\N	Hilo Nylon	pza	0.0100	14.00	material	2025-06-01 00:17:48.46134	2025-06-01 00:17:48.46134	\N	\N
4693	394	\N	Ayudante	hr	0.2000	12.50	labor	2025-06-01 00:17:48.478145	2025-06-01 00:17:48.478145	\N	\N
4694	394	\N	Maestro albañil	hr	0.2000	18.75	labor	2025-06-01 00:17:48.495088	2025-06-01 00:17:48.495088	\N	\N
4695	394	\N	Topógrafo	hr	0.2100	20.00	labor	2025-06-01 00:17:48.511992	2025-06-01 00:17:48.511992	\N	\N
4696	394	\N	Teodolito	hr	0.2500	50.00	equipment	2025-06-01 00:17:48.528707	2025-06-01 00:17:48.528707	\N	\N
4697	395	\N	Cal de blanqueo	kg	0.2000	0.90	material	2025-06-01 00:17:48.941675	2025-06-01 00:17:48.941675	\N	\N
4698	395	23	Clavos de 2 pulg	kg	0.0100	13.00	material	2025-06-01 00:17:48.974524	2025-06-01 00:17:48.974524	\N	\N
4699	395	\N	Listón de 1x2 pulg	ml	0.1000	8.00	material	2025-06-01 00:17:49.008776	2025-06-01 00:17:49.008776	\N	\N
4700	395	\N	Listón de 2x2 pulg	ml	0.1200	12.00	material	2025-06-01 00:17:49.046433	2025-06-01 00:17:49.046433	\N	\N
4701	395	\N	Hilo Nylon	pza	0.0100	14.00	material	2025-06-01 00:17:49.080991	2025-06-01 00:17:49.080991	\N	\N
4702	395	\N	Ayudante	hr	0.2000	12.50	labor	2025-06-01 00:17:49.097495	2025-06-01 00:17:49.097495	\N	\N
4703	395	\N	Maestro albañil	hr	0.2000	18.75	labor	2025-06-01 00:17:49.175755	2025-06-01 00:17:49.175755	\N	\N
4704	396	\N	Barniz filtrosolar	lt	0.0500	24.00	material	2025-06-01 00:17:49.640518	2025-06-01 00:17:49.640518	\N	\N
4705	396	\N	Brocha de 4 pulg	pza	0.0200	45.00	material	2025-06-01 00:17:49.675504	2025-06-01 00:17:49.675504	\N	\N
4706	396	\N	Lija	ml	0.0400	7.00	material	2025-06-01 00:17:49.710489	2025-06-01 00:17:49.710489	\N	\N
4707	396	\N	Ayudante (pintor)	hr	0.1500	12.50	labor	2025-06-01 00:17:49.727386	2025-06-01 00:17:49.727386	\N	\N
4708	396	\N	Maestro pintor	hr	0.3000	25.00	labor	2025-06-01 00:17:49.744082	2025-06-01 00:17:49.744082	\N	\N
4709	397	\N	Barniz filtrosolar	lt	0.1000	24.00	material	2025-06-01 00:17:50.114748	2025-06-01 00:17:50.114748	\N	\N
4710	397	\N	Brocha de 4 pulg	pza	0.0400	45.00	material	2025-06-01 00:17:50.151546	2025-06-01 00:17:50.151546	\N	\N
4711	397	\N	Lija	ml	0.1000	7.00	material	2025-06-01 00:17:50.185583	2025-06-01 00:17:50.185583	\N	\N
4712	397	\N	Ayudante (pintor)	hr	0.4000	12.50	labor	2025-06-01 00:17:50.202255	2025-06-01 00:17:50.202255	\N	\N
4713	397	\N	Maestro pintor	hr	0.4000	25.00	labor	2025-06-01 00:17:50.219171	2025-06-01 00:17:50.219171	\N	\N
4714	398	\N	Brocha de 4 pulg	pza	0.0300	45.00	material	2025-06-01 00:17:50.611446	2025-06-01 00:17:50.611446	\N	\N
4715	398	\N	Lija	ml	0.1500	7.00	material	2025-06-01 00:17:50.646247	2025-06-01 00:17:50.646247	\N	\N
4716	398	\N	Pintura acrílica	lt	0.3000	39.32	material	2025-06-01 00:17:50.680893	2025-06-01 00:17:50.680893	\N	\N
4717	398	\N	Sellador fijador	lt	0.1200	18.00	material	2025-06-01 00:17:50.71571	2025-06-01 00:17:50.71571	\N	\N
4718	398	\N	Ayudante (pintor)	hr	0.1500	12.50	labor	2025-06-01 00:17:50.732531	2025-06-01 00:17:50.732531	\N	\N
4719	398	\N	Maestro pintor	hr	0.4000	25.00	labor	2025-06-01 00:17:50.749158	2025-06-01 00:17:50.749158	\N	\N
4720	399	\N	Brocha de 4 pulg	pza	0.0400	45.00	material	2025-06-01 00:17:51.124494	2025-06-01 00:17:51.124494	\N	\N
4721	399	\N	Lija	ml	0.1000	7.00	material	2025-06-01 00:17:51.158959	2025-06-01 00:17:51.158959	\N	\N
4722	399	\N	Pintura al óleo	lt	0.4000	39.89	material	2025-06-01 00:17:51.193488	2025-06-01 00:17:51.193488	\N	\N
4723	399	\N	Ayudante (pintor)	hr	0.4000	12.50	labor	2025-06-01 00:17:51.211067	2025-06-01 00:17:51.211067	\N	\N
4724	399	\N	Maestro pintor	hr	0.4000	25.00	labor	2025-06-01 00:17:51.227855	2025-06-01 00:17:51.227855	\N	\N
4725	400	\N	Acuacolor	lt	0.1000	10.94	material	2025-06-01 00:17:51.623427	2025-06-01 00:17:51.623427	\N	\N
4726	400	\N	Barniz filtrosolar	lt	0.1000	24.00	material	2025-06-01 00:17:51.658959	2025-06-01 00:17:51.658959	\N	\N
4727	400	\N	Brocha de 4 pulg	pza	0.0400	45.00	material	2025-06-01 00:17:51.693296	2025-06-01 00:17:51.693296	\N	\N
4728	400	\N	Lija	ml	0.1000	7.00	material	2025-06-01 00:17:51.728032	2025-06-01 00:17:51.728032	\N	\N
4729	400	\N	Pintura al óleo	lt	0.4000	39.89	material	2025-06-01 00:17:51.762322	2025-06-01 00:17:51.762322	\N	\N
4730	400	\N	Sellador fijador	lt	0.1000	18.00	material	2025-06-01 00:17:51.796739	2025-06-01 00:17:51.796739	\N	\N
4731	400	\N	Ayudante (pintor)	hr	0.4000	12.50	labor	2025-06-01 00:17:51.813784	2025-06-01 00:17:51.813784	\N	\N
4732	400	\N	Maestro pintor	hr	0.4000	25.00	labor	2025-06-01 00:17:51.830968	2025-06-01 00:17:51.830968	\N	\N
4733	401	\N	Brocha de 4 pulg	pza	0.0100	45.00	material	2025-06-01 00:17:52.222551	2025-06-01 00:17:52.222551	\N	\N
4734	401	\N	Lija	ml	0.1000	7.00	material	2025-06-01 00:17:52.257456	2025-06-01 00:17:52.257456	\N	\N
4735	401	\N	Pintura al óleo	lt	0.2500	39.89	material	2025-06-01 00:17:52.29185	2025-06-01 00:17:52.29185	\N	\N
4736	401	\N	Rodillo	pza	0.0200	25.00	material	2025-06-01 00:17:52.325956	2025-06-01 00:17:52.325956	\N	\N
4737	401	\N	Sellador fijador	lt	0.1200	18.00	material	2025-06-01 00:17:52.360463	2025-06-01 00:17:52.360463	\N	\N
4738	401	\N	Ayudante (pintor)	hr	0.1200	12.50	labor	2025-06-01 00:17:52.377401	2025-06-01 00:17:52.377401	\N	\N
4739	401	\N	Maestro pintor	hr	0.2500	25.00	labor	2025-06-01 00:17:52.394443	2025-06-01 00:17:52.394443	\N	\N
4740	401	\N	Andamio metálico (2 módulos)	hr	0.2500	0.16	equipment	2025-06-01 00:17:52.411267	2025-06-01 00:17:52.411267	\N	\N
4741	402	\N	Brocha de 4 pulg	pza	0.0400	45.00	material	2025-06-01 00:17:52.783191	2025-06-01 00:17:52.783191	\N	\N
4742	402	\N	Lija	ml	1.0000	7.00	material	2025-06-01 00:17:52.817348	2025-06-01 00:17:52.817348	\N	\N
4743	402	\N	Pintura al óleo	lt	0.4000	39.89	material	2025-06-01 00:17:52.851468	2025-06-01 00:17:52.851468	\N	\N
4744	402	\N	Ayudante (pintor)	hr	0.4000	12.50	labor	2025-06-01 00:17:52.868331	2025-06-01 00:17:52.868331	\N	\N
4745	402	\N	Maestro pintor	hr	0.4000	25.00	labor	2025-06-01 00:17:52.884967	2025-06-01 00:17:52.884967	\N	\N
4746	403	\N	Brocha de 4 pulg	pza	0.0100	45.00	material	2025-06-01 00:17:53.262504	2025-06-01 00:17:53.262504	\N	\N
4747	403	\N	Lija	ml	0.1000	7.00	material	2025-06-01 00:17:53.298028	2025-06-01 00:17:53.298028	\N	\N
4748	403	17	Pintura latex	lt	0.2000	30.00	material	2025-06-01 00:17:53.331517	2025-06-01 00:17:53.331517	\N	\N
4749	403	\N	Rodillo	pza	0.0200	25.00	material	2025-06-01 00:17:53.36657	2025-06-01 00:17:53.36657	\N	\N
4750	403	\N	Sellador fijador	lt	0.1200	18.00	material	2025-06-01 00:17:53.401973	2025-06-01 00:17:53.401973	\N	\N
4751	403	\N	Ayudante (pintor)	hr	0.1500	12.50	labor	2025-06-01 00:17:53.418891	2025-06-01 00:17:53.418891	\N	\N
4752	403	\N	Maestro pintor	hr	0.3000	25.00	labor	2025-06-01 00:17:53.436191	2025-06-01 00:17:53.436191	\N	\N
4753	403	\N	Andamio metálico (2 módulos)	hr	0.3000	0.16	equipment	2025-06-01 00:17:53.454154	2025-06-01 00:17:53.454154	\N	\N
4754	404	\N	Brocha de 4 pulg	pza	0.0100	45.00	material	2025-06-01 00:17:53.916528	2025-06-01 00:17:53.916528	\N	\N
4755	404	\N	Lija	ml	0.1000	7.00	material	2025-06-01 00:17:53.950923	2025-06-01 00:17:53.950923	\N	\N
4756	404	17	Pintura latex	lt	0.2000	30.00	material	2025-06-01 00:17:53.983093	2025-06-01 00:17:53.983093	\N	\N
4757	404	\N	Rodillo	pza	0.0200	25.00	material	2025-06-01 00:17:54.017505	2025-06-01 00:17:54.017505	\N	\N
4758	404	\N	Sellador fijador	lt	0.1200	18.00	material	2025-06-01 00:17:54.051846	2025-06-01 00:17:54.051846	\N	\N
4759	404	\N	Ayudante (pintor)	hr	0.2000	12.50	labor	2025-06-01 00:17:54.068501	2025-06-01 00:17:54.068501	\N	\N
4760	404	\N	Maestro pintor	hr	0.5000	25.00	labor	2025-06-01 00:17:54.085097	2025-06-01 00:17:54.085097	\N	\N
4761	404	\N	Andamio metálico (2 módulos)	hr	0.3000	0.16	equipment	2025-06-01 00:17:54.101642	2025-06-01 00:17:54.101642	\N	\N
4762	405	\N	Brocha de 4 pulg	pza	0.0100	45.00	material	2025-06-01 00:17:54.4784	2025-06-01 00:17:54.4784	\N	\N
4763	405	\N	Lija	ml	0.1000	7.00	material	2025-06-01 00:17:54.512557	2025-06-01 00:17:54.512557	\N	\N
4764	405	17	Pintura latex	lt	0.2000	30.00	material	2025-06-01 00:17:54.545703	2025-06-01 00:17:54.545703	\N	\N
4765	405	\N	Rodillo	pza	0.0200	25.00	material	2025-06-01 00:17:54.580275	2025-06-01 00:17:54.580275	\N	\N
4766	405	\N	Sellador fijador	lt	0.1200	18.00	material	2025-06-01 00:17:54.614381	2025-06-01 00:17:54.614381	\N	\N
4767	405	\N	Ayudante (pintor)	hr	0.1500	12.50	labor	2025-06-01 00:17:54.631549	2025-06-01 00:17:54.631549	\N	\N
4768	405	\N	Maestro pintor	hr	0.2000	25.00	labor	2025-06-01 00:17:54.648539	2025-06-01 00:17:54.648539	\N	\N
4769	405	\N	Andamio metálico (2 módulos)	hr	0.2000	0.16	equipment	2025-06-01 00:17:54.666085	2025-06-01 00:17:54.666085	\N	\N
4770	406	\N	Brocha de 4 pulg	pza	0.0300	45.00	material	2025-06-01 00:17:55.071016	2025-06-01 00:17:55.071016	\N	\N
4771	406	\N	Lija	ml	0.1000	7.00	material	2025-06-01 00:17:55.104996	2025-06-01 00:17:55.104996	\N	\N
4772	406	17	Pintura latex	lt	0.3000	30.00	material	2025-06-01 00:17:55.137842	2025-06-01 00:17:55.137842	\N	\N
4773	406	\N	Sellador fijador	lt	0.1200	18.00	material	2025-06-01 00:17:55.172167	2025-06-01 00:17:55.172167	\N	\N
4774	406	\N	Ayudante (pintor)	hr	0.2500	12.50	labor	2025-06-01 00:17:55.188853	2025-06-01 00:17:55.188853	\N	\N
4775	406	\N	Maestro pintor	hr	0.3000	25.00	labor	2025-06-01 00:17:55.206086	2025-06-01 00:17:55.206086	\N	\N
4776	407	\N	Brocha de 4 pulg	pza	0.0100	45.00	material	2025-06-01 00:17:55.600421	2025-06-01 00:17:55.600421	\N	\N
4777	407	\N	Lija	ml	0.1000	7.00	material	2025-06-01 00:17:55.635137	2025-06-01 00:17:55.635137	\N	\N
4778	407	17	Pintura latex	lt	0.2000	30.00	material	2025-06-01 00:17:55.667998	2025-06-01 00:17:55.667998	\N	\N
4779	407	\N	Rodillo	pza	0.0200	25.00	material	2025-06-01 00:17:55.702024	2025-06-01 00:17:55.702024	\N	\N
4780	407	\N	Sellador fijador	lt	0.1200	18.00	material	2025-06-01 00:17:55.779047	2025-06-01 00:17:55.779047	\N	\N
4781	407	\N	Ayudante (pintor)	hr	0.1500	12.50	labor	2025-06-01 00:17:55.795697	2025-06-01 00:17:55.795697	\N	\N
4782	407	\N	Maestro pintor	hr	0.3000	25.00	labor	2025-06-01 00:17:55.812636	2025-06-01 00:17:55.812636	\N	\N
4783	407	\N	Andamio metálico (2 módulos)	hr	0.3000	0.16	equipment	2025-06-01 00:17:55.829458	2025-06-01 00:17:55.829458	\N	\N
4784	408	\N	Brocha de 2 pulg	pza	0.1000	25.00	material	2025-06-01 00:17:56.331083	2025-06-01 00:17:56.331083	\N	\N
4785	408	\N	Lija	ml	1.0000	7.00	material	2025-06-01 00:17:56.364991	2025-06-01 00:17:56.364991	\N	\N
4786	408	17	Pintura latex	lt	0.3000	30.00	material	2025-06-01 00:17:56.398721	2025-06-01 00:17:56.398721	\N	\N
4787	408	\N	Sellador fijador	lt	0.1200	18.00	material	2025-06-01 00:17:56.437964	2025-06-01 00:17:56.437964	\N	\N
4788	408	\N	Ayudante (pintor)	hr	0.5000	12.50	labor	2025-06-01 00:17:56.454629	2025-06-01 00:17:56.454629	\N	\N
4789	408	\N	Maestro pintor	hr	0.2000	25.00	labor	2025-06-01 00:17:56.471234	2025-06-01 00:17:56.471234	\N	\N
4790	409	\N	Brocha de 4 pulg	pza	0.0100	45.00	material	2025-06-01 00:17:56.867204	2025-06-01 00:17:56.867204	\N	\N
4791	409	\N	Lija	ml	0.1000	7.00	material	2025-06-01 00:17:56.901541	2025-06-01 00:17:56.901541	\N	\N
4792	409	17	Pintura latex	lt	0.2500	30.00	material	2025-06-01 00:17:56.934025	2025-06-01 00:17:56.934025	\N	\N
4793	409	\N	Rodillo	pza	0.0200	25.00	material	2025-06-01 00:17:56.967975	2025-06-01 00:17:56.967975	\N	\N
4794	409	\N	Sellador fijador	lt	0.1200	18.00	material	2025-06-01 00:17:57.001814	2025-06-01 00:17:57.001814	\N	\N
4795	409	\N	Ayudante (pintor)	hr	0.2000	12.50	labor	2025-06-01 00:17:57.018686	2025-06-01 00:17:57.018686	\N	\N
4796	409	\N	Maestro pintor	hr	0.5000	25.00	labor	2025-06-01 00:17:57.035387	2025-06-01 00:17:57.035387	\N	\N
4797	409	\N	Andamio metálico (2 módulos)	hr	0.3000	0.16	equipment	2025-06-01 00:17:57.052306	2025-06-01 00:17:57.052306	\N	\N
4798	410	\N	Lija	ml	0.1000	7.00	material	2025-06-01 00:17:57.43508	2025-06-01 00:17:57.43508	\N	\N
4799	410	17	Pintura latex	lt	0.2500	30.00	material	2025-06-01 00:17:57.468867	2025-06-01 00:17:57.468867	\N	\N
4800	410	\N	Masa corrida	lt	0.1000	15.00	material	2025-06-01 00:17:57.503278	2025-06-01 00:17:57.503278	\N	\N
4801	410	\N	Sellador de paredes	gl	0.0100	19.50	material	2025-06-01 00:17:57.539115	2025-06-01 00:17:57.539115	\N	\N
4802	410	\N	Ayudante de pintor	hr	0.3000	12.50	labor	2025-06-01 00:17:57.555757	2025-06-01 00:17:57.555757	\N	\N
4803	410	\N	Maestro pintor	hr	0.3000	18.75	labor	2025-06-01 00:17:57.572739	2025-06-01 00:17:57.572739	\N	\N
4804	411	\N	Cemento portland IP-30	kg	2.5000	1.20	material	2025-06-01 00:17:58.087086	2025-06-01 00:17:58.087086	\N	\N
4805	411	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:17:58.120495	2025-06-01 00:17:58.120495	\N	\N
4806	411	\N	Ladrillo adobito	pza	35.0000	0.65	material	2025-06-01 00:17:58.154711	2025-06-01 00:17:58.154711	\N	\N
4807	411	22	Agua	lt	30.0000	0.06	material	2025-06-01 00:17:58.188553	2025-06-01 00:17:58.188553	\N	\N
4808	411	\N	Ayudante	hr	0.5000	12.50	labor	2025-06-01 00:17:58.20516	2025-06-01 00:17:58.20516	\N	\N
4809	411	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:17:58.223493	2025-06-01 00:17:58.223493	\N	\N
4810	412	\N	Cemento portland IP-30	kg	14.0000	1.20	material	2025-06-01 00:17:58.646779	2025-06-01 00:17:58.646779	\N	\N
4811	412	\N	Arenilla	m3	0.0700	100.00	material	2025-06-01 00:17:58.681632	2025-06-01 00:17:58.681632	\N	\N
4812	412	\N	Ripio bruto	m3	0.0700	180.00	material	2025-06-01 00:17:58.719101	2025-06-01 00:17:58.719101	\N	\N
4813	412	22	Agua	lt	15.0000	0.06	material	2025-06-01 00:17:58.754119	2025-06-01 00:17:58.754119	\N	\N
4814	412	\N	Ayudante	hr	0.8000	12.50	labor	2025-06-01 00:17:58.770942	2025-06-01 00:17:58.770942	\N	\N
4815	412	\N	Maestro albañil	hr	0.8000	18.75	labor	2025-06-01 00:17:58.787235	2025-06-01 00:17:58.787235	\N	\N
4816	413	\N	Cemento portland IP-30	kg	18.0000	1.20	material	2025-06-01 00:17:59.192148	2025-06-01 00:17:59.192148	\N	\N
4817	413	\N	Ripio bruto	m3	0.0900	180.00	material	2025-06-01 00:17:59.226335	2025-06-01 00:17:59.226335	\N	\N
4818	413	22	Agua	lt	16.0000	0.06	material	2025-06-01 00:17:59.259132	2025-06-01 00:17:59.259132	\N	\N
4819	413	\N	Ayudante	hr	0.9000	12.50	labor	2025-06-01 00:17:59.275914	2025-06-01 00:17:59.275914	\N	\N
4820	413	\N	Maestro albañil	hr	0.9000	18.75	labor	2025-06-01 00:17:59.292728	2025-06-01 00:17:59.292728	\N	\N
4821	414	\N	Cemento portland IP-30	kg	12.0000	1.20	material	2025-06-01 00:17:59.801966	2025-06-01 00:17:59.801966	\N	\N
4822	414	\N	Arenilla	m3	0.0400	100.00	material	2025-06-01 00:17:59.836492	2025-06-01 00:17:59.836492	\N	\N
4823	414	\N	Piedra manzana	m3	0.1000	250.00	material	2025-06-01 00:17:59.872069	2025-06-01 00:17:59.872069	\N	\N
4824	414	\N	Ripio rodado	m3	0.0500	170.00	material	2025-06-01 00:17:59.906128	2025-06-01 00:17:59.906128	\N	\N
4825	414	22	Agua	lt	22.0000	0.06	material	2025-06-01 00:17:59.937816	2025-06-01 00:17:59.937816	\N	\N
4826	414	\N	Ayudante	hr	0.5000	12.50	labor	2025-06-01 00:17:59.954594	2025-06-01 00:17:59.954594	\N	\N
4827	414	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:17:59.971332	2025-06-01 00:17:59.971332	\N	\N
4828	415	105	Cemento blanco	kg	0.5000	7.00	material	2025-06-01 00:18:00.359528	2025-06-01 00:18:00.359528	\N	\N
4829	415	\N	Cemento cola	kg	4.5000	1.25	material	2025-06-01 00:18:00.393967	2025-06-01 00:18:00.393967	\N	\N
4830	415	\N	Cerámica nacional 32x32	m2	1.0500	45.00	material	2025-06-01 00:18:00.428401	2025-06-01 00:18:00.428401	\N	\N
4831	415	\N	Ayudante 2	hr	0.7500	12.50	labor	2025-06-01 00:18:00.445076	2025-06-01 00:18:00.445076	\N	\N
4832	415	\N	Maestro albañil	hr	0.7500	18.75	labor	2025-06-01 00:18:00.460795	2025-06-01 00:18:00.460795	\N	\N
4833	416	\N	Alfombra de alto tráfico	m2	1.1000	70.65	material	2025-06-01 00:18:00.830863	2025-06-01 00:18:00.830863	\N	\N
4834	416	\N	Colocador de alfombras	hr	0.2000	20.00	labor	2025-06-01 00:18:00.847727	2025-06-01 00:18:00.847727	\N	\N
4835	417	\N	Cemento portland IP-30	kg	10.0000	1.20	material	2025-06-01 00:18:01.270617	2025-06-01 00:18:01.270617	\N	\N
4836	417	5	Arena Fina	m3	0.0500	70.00	material	2025-06-01 00:18:01.30338	2025-06-01 00:18:01.30338	\N	\N
4837	417	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:18:01.319999	2025-06-01 00:18:01.319999	\N	\N
4838	417	\N	Maestro albañil	hr	1.0000	18.75	labor	2025-06-01 00:18:01.336685	2025-06-01 00:18:01.336685	\N	\N
4839	418	\N	Cemento portland IP-30	kg	10.0000	1.20	material	2025-06-01 00:18:01.756251	2025-06-01 00:18:01.756251	\N	\N
4840	418	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:18:01.789169	2025-06-01 00:18:01.789169	\N	\N
4841	418	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:01.845566	2025-06-01 00:18:01.845566	\N	\N
4842	418	\N	Ayudante	hr	0.7000	12.50	labor	2025-06-01 00:18:01.863075	2025-06-01 00:18:01.863075	\N	\N
4843	418	\N	Maestro albañil	hr	0.7000	18.75	labor	2025-06-01 00:18:01.880055	2025-06-01 00:18:01.880055	\N	\N
4844	419	\N	Cemento portland IP-30	kg	10.0000	1.20	material	2025-06-01 00:18:02.297219	2025-06-01 00:18:02.297219	\N	\N
4845	419	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:18:02.336763	2025-06-01 00:18:02.336763	\N	\N
4846	419	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:02.369979	2025-06-01 00:18:02.369979	\N	\N
4847	419	\N	Ocre	kg	0.2000	25.00	material	2025-06-01 00:18:02.404095	2025-06-01 00:18:02.404095	\N	\N
4848	419	\N	Ayudante	hr	0.9500	12.50	labor	2025-06-01 00:18:02.421714	2025-06-01 00:18:02.421714	\N	\N
4849	419	\N	Maestro albañil	hr	0.9500	18.75	labor	2025-06-01 00:18:02.438327	2025-06-01 00:18:02.438327	\N	\N
4850	420	\N	Cemento portland IP-30	kg	11.2000	1.20	material	2025-06-01 00:18:02.853421	2025-06-01 00:18:02.853421	\N	\N
4851	420	5	Arena Fina	m3	0.0400	70.00	material	2025-06-01 00:18:02.887701	2025-06-01 00:18:02.887701	\N	\N
4852	420	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:02.920545	2025-06-01 00:18:02.920545	\N	\N
4853	420	\N	Piso de cerámica esmaltada	m2	1.0500	45.00	material	2025-06-01 00:18:02.955001	2025-06-01 00:18:02.955001	\N	\N
4854	420	\N	Ayudante	hr	1.9000	12.50	labor	2025-06-01 00:18:02.971745	2025-06-01 00:18:02.971745	\N	\N
4855	420	\N	Maestro albañil	hr	1.9000	18.75	labor	2025-06-01 00:18:02.988775	2025-06-01 00:18:02.988775	\N	\N
4856	421	\N	Cemento cola	kg	6.0000	1.25	material	2025-06-01 00:18:03.419751	2025-06-01 00:18:03.419751	\N	\N
4857	421	\N	Ceramica Esmaltada P/ Piso (40x40cm)	m2	1.0500	70.00	material	2025-06-01 00:18:03.459	2025-06-01 00:18:03.459	\N	\N
4858	421	\N	Maestro albañil	hr	1.0000	18.75	labor	2025-06-01 00:18:03.475835	2025-06-01 00:18:03.475835	\N	\N
4859	421	\N	Ayudante De Albañil	hr	1.0000	12.50	labor	2025-06-01 00:18:03.492517	2025-06-01 00:18:03.492517	\N	\N
4860	421	\N	Amoladora	hr	0.5000	2.50	equipment	2025-06-01 00:18:03.509316	2025-06-01 00:18:03.509316	\N	\N
4861	422	\N	Cemento portland IP-30	kg	11.2000	1.20	material	2025-06-01 00:18:04.022312	2025-06-01 00:18:04.022312	\N	\N
4862	422	5	Arena Fina	m3	0.0400	70.00	material	2025-06-01 00:18:04.055389	2025-06-01 00:18:04.055389	\N	\N
4863	422	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:04.088446	2025-06-01 00:18:04.088446	\N	\N
4864	422	\N	Piso de cerámica española	m2	1.0000	175.00	material	2025-06-01 00:18:04.123053	2025-06-01 00:18:04.123053	\N	\N
4865	422	\N	Ayudante	hr	1.9000	12.50	labor	2025-06-01 00:18:04.140277	2025-06-01 00:18:04.140277	\N	\N
4866	422	\N	Maestro albañil	hr	1.9000	18.75	labor	2025-06-01 00:18:04.156978	2025-06-01 00:18:04.156978	\N	\N
4867	423	\N	Cemento portland IP-30	kg	11.2000	1.20	material	2025-06-01 00:18:04.729004	2025-06-01 00:18:04.729004	\N	\N
4868	423	5	Arena Fina	m3	0.0400	70.00	material	2025-06-01 00:18:04.762684	2025-06-01 00:18:04.762684	\N	\N
4869	423	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:04.796964	2025-06-01 00:18:04.796964	\N	\N
4870	423	\N	Ceramica exterior	m2	1.0000	58.75	material	2025-06-01 00:18:04.831538	2025-06-01 00:18:04.831538	\N	\N
4871	423	\N	Ayudante	hr	1.9000	12.50	labor	2025-06-01 00:18:04.848413	2025-06-01 00:18:04.848413	\N	\N
4872	423	\N	Maestro albañil	hr	1.9000	18.75	labor	2025-06-01 00:18:04.865207	2025-06-01 00:18:04.865207	\N	\N
4873	424	\N	Cemento portland IP-30	kg	12.0000	1.20	material	2025-06-01 00:18:05.425633	2025-06-01 00:18:05.425633	\N	\N
4874	424	5	Arena Fina	m3	0.0400	70.00	material	2025-06-01 00:18:05.458449	2025-06-01 00:18:05.458449	\N	\N
4875	424	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:05.491766	2025-06-01 00:18:05.491766	\N	\N
4876	424	\N	Ocre	kg	0.1000	25.00	material	2025-06-01 00:18:05.525882	2025-06-01 00:18:05.525882	\N	\N
4877	424	\N	Piso de cerámica gres 15x15cm	m2	1.0500	56.00	material	2025-06-01 00:18:05.561835	2025-06-01 00:18:05.561835	\N	\N
4878	424	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:18:05.578548	2025-06-01 00:18:05.578548	\N	\N
4879	424	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:18:05.595356	2025-06-01 00:18:05.595356	\N	\N
4880	425	\N	Cemento cola	kg	1.0000	1.25	material	2025-06-01 00:18:06.135553	2025-06-01 00:18:06.135553	\N	\N
4881	425	\N	Piso cerámica roja nacional 15x15	m2	1.0000	25.00	material	2025-06-01 00:18:06.177499	2025-06-01 00:18:06.177499	\N	\N
4882	425	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:18:06.212218	2025-06-01 00:18:06.212218	\N	\N
4883	425	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:18:06.233133	2025-06-01 00:18:06.233133	\N	\N
4884	426	\N	Cemento portland IP-30	kg	10.0000	1.20	material	2025-06-01 00:18:06.741752	2025-06-01 00:18:06.741752	\N	\N
4885	426	5	Arena Fina	m3	0.0400	70.00	material	2025-06-01 00:18:06.774968	2025-06-01 00:18:06.774968	\N	\N
4886	426	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:06.808681	2025-06-01 00:18:06.808681	\N	\N
4887	426	\N	Ocre	kg	0.1000	25.00	material	2025-06-01 00:18:06.843808	2025-06-01 00:18:06.843808	\N	\N
4888	426	\N	Piso de cerámica roja natural	m2	1.0500	42.00	material	2025-06-01 00:18:06.878731	2025-06-01 00:18:06.878731	\N	\N
4889	426	\N	Ayudante	hr	1.5000	12.50	labor	2025-06-01 00:18:06.895498	2025-06-01 00:18:06.895498	\N	\N
4890	426	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:18:06.912302	2025-06-01 00:18:06.912302	\N	\N
4891	427	\N	Cemento portland IP-30	kg	12.0000	1.20	material	2025-06-01 00:18:07.423006	2025-06-01 00:18:07.423006	\N	\N
4892	427	5	Arena Fina	m3	0.0400	70.00	material	2025-06-01 00:18:07.456435	2025-06-01 00:18:07.456435	\N	\N
4893	427	\N	Ladrillo adobito	pza	35.0000	0.65	material	2025-06-01 00:18:07.490931	2025-06-01 00:18:07.490931	\N	\N
4894	427	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:07.523129	2025-06-01 00:18:07.523129	\N	\N
4895	427	\N	Ocre	kg	0.1000	25.00	material	2025-06-01 00:18:07.556769	2025-06-01 00:18:07.556769	\N	\N
4896	427	\N	Ayudante	hr	1.8000	12.50	labor	2025-06-01 00:18:07.574921	2025-06-01 00:18:07.574921	\N	\N
4897	427	\N	Maestro albañil	hr	1.8000	18.75	labor	2025-06-01 00:18:07.591779	2025-06-01 00:18:07.591779	\N	\N
4898	428	\N	Alquitran	kg	1.6000	12.60	material	2025-06-01 00:18:08.042439	2025-06-01 00:18:08.042439	\N	\N
4899	428	\N	Tierra de relleno	m3	0.0500	60.00	material	2025-06-01 00:18:08.076747	2025-06-01 00:18:08.076747	\N	\N
4900	428	\N	Loseta de Ho	m2	1.0000	90.00	material	2025-06-01 00:18:08.11123	2025-06-01 00:18:08.11123	\N	\N
4901	428	\N	Ayudante	hr	0.1000	12.50	labor	2025-06-01 00:18:08.128256	2025-06-01 00:18:08.128256	\N	\N
4902	428	\N	Maestro albañil	hr	1.0600	18.75	labor	2025-06-01 00:18:08.145166	2025-06-01 00:18:08.145166	\N	\N
4903	429	\N	Cemento portland IP-30	kg	10.0000	1.20	material	2025-06-01 00:18:08.628509	2025-06-01 00:18:08.628509	\N	\N
4904	429	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:18:08.6628	2025-06-01 00:18:08.6628	\N	\N
4905	429	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:08.696577	2025-06-01 00:18:08.696577	\N	\N
4906	429	\N	Ayudante	hr	0.9500	12.50	labor	2025-06-01 00:18:08.713701	2025-06-01 00:18:08.713701	\N	\N
4907	429	\N	Maestro albañil	hr	0.9500	18.75	labor	2025-06-01 00:18:08.730524	2025-06-01 00:18:08.730524	\N	\N
4908	430	\N	Cemento portland IP-30	kg	12.0000	1.20	material	2025-06-01 00:18:09.396063	2025-06-01 00:18:09.396063	\N	\N
4909	430	5	Arena Fina	m3	0.0400	70.00	material	2025-06-01 00:18:09.430253	2025-06-01 00:18:09.430253	\N	\N
4910	430	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:09.463432	2025-06-01 00:18:09.463432	\N	\N
4911	430	\N	Ocre	kg	0.1000	25.00	material	2025-06-01 00:18:09.498638	2025-06-01 00:18:09.498638	\N	\N
4912	430	\N	Mosaico común	m2	1.0500	42.00	material	2025-06-01 00:18:09.533516	2025-06-01 00:18:09.533516	\N	\N
4913	430	\N	Ayudante	hr	1.8000	12.50	labor	2025-06-01 00:18:09.55021	2025-06-01 00:18:09.55021	\N	\N
4914	430	\N	Maestro albañil	hr	1.8000	18.75	labor	2025-06-01 00:18:09.566951	2025-06-01 00:18:09.566951	\N	\N
4915	431	\N	Cemento portland IP-30	kg	12.0000	1.20	material	2025-06-01 00:18:10.140279	2025-06-01 00:18:10.140279	\N	\N
4916	431	5	Arena Fina	m3	0.0500	70.00	material	2025-06-01 00:18:10.173359	2025-06-01 00:18:10.173359	\N	\N
4917	431	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:10.206727	2025-06-01 00:18:10.206727	\N	\N
4918	431	\N	Mosaico granito	m2	1.0500	98.50	material	2025-06-01 00:18:10.24155	2025-06-01 00:18:10.24155	\N	\N
4919	431	\N	Ayudante	hr	2.2000	12.50	labor	2025-06-01 00:18:10.258732	2025-06-01 00:18:10.258732	\N	\N
4920	431	\N	Maestro albañil	hr	2.2000	18.75	labor	2025-06-01 00:18:10.275529	2025-06-01 00:18:10.275529	\N	\N
4921	432	\N	Parket para piso	m2	1.0000	154.00	material	2025-06-01 00:18:10.670186	2025-06-01 00:18:10.670186	\N	\N
4922	432	\N	Maestro carpintero	hr	3.0000	15.00	labor	2025-06-01 00:18:10.68686	2025-06-01 00:18:10.68686	\N	\N
4923	433	\N	Cemento portland IP-30	kg	7.0000	1.20	material	2025-06-01 00:18:11.245066	2025-06-01 00:18:11.245066	\N	\N
4924	433	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:18:11.278373	2025-06-01 00:18:11.278373	\N	\N
4925	433	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:11.311768	2025-06-01 00:18:11.311768	\N	\N
4926	433	\N	Piedra Laja	m2	0.8000	90.00	material	2025-06-01 00:18:11.345847	2025-06-01 00:18:11.345847	\N	\N
4927	433	\N	Ayudante	hr	4.0000	12.50	labor	2025-06-01 00:18:11.36236	2025-06-01 00:18:11.36236	\N	\N
4928	433	\N	Maestro albañil	hr	4.0000	18.75	labor	2025-06-01 00:18:11.378953	2025-06-01 00:18:11.378953	\N	\N
4929	434	\N	Cemento portland IP-30	kg	12.0000	1.20	material	2025-06-01 00:18:12.069574	2025-06-01 00:18:12.069574	\N	\N
4930	434	5	Arena Fina	m3	0.0400	70.00	material	2025-06-01 00:18:12.10385	2025-06-01 00:18:12.10385	\N	\N
4931	434	\N	Piedra pequeña seleccionada 1"	m3	0.0500	100.00	material	2025-06-01 00:18:12.138702	2025-06-01 00:18:12.138702	\N	\N
4932	434	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:12.172648	2025-06-01 00:18:12.172648	\N	\N
4933	434	\N	Piso de cerámica roja natural	m2	1.0500	42.00	material	2025-06-01 00:18:12.207085	2025-06-01 00:18:12.207085	\N	\N
4934	434	\N	Ayudante	hr	2.2000	12.50	labor	2025-06-01 00:18:12.223714	2025-06-01 00:18:12.223714	\N	\N
4935	434	\N	Maestro albañil	hr	2.2000	18.75	labor	2025-06-01 00:18:12.240446	2025-06-01 00:18:12.240446	\N	\N
4936	435	\N	Pegamento (clefa)	lt	0.2200	35.00	material	2025-06-01 00:18:12.799131	2025-06-01 00:18:12.799131	\N	\N
4937	435	\N	\\"flexiplast\\"	pz	1.0500	64.03	material	2025-06-01 00:18:12.833779	2025-06-01 00:18:12.833779	\N	\N
4938	435	\N	Ayudante	hr	0.7000	12.50	labor	2025-06-01 00:18:12.850484	2025-06-01 00:18:12.850484	\N	\N
4939	435	\N	Maestro albañil	hr	0.7000	18.75	labor	2025-06-01 00:18:12.867275	2025-06-01 00:18:12.867275	\N	\N
4940	436	\N	Cemento cola	kg	2.0000	1.25	material	2025-06-01 00:18:13.852681	2025-06-01 00:18:13.852681	\N	\N
4941	436	\N	Arenilla	m3	0.0500	100.00	material	2025-06-01 00:18:13.887655	2025-06-01 00:18:13.887655	\N	\N
4942	436	\N	Piso de porcelanato	m2	1.4400	140.00	material	2025-06-01 00:18:13.922716	2025-06-01 00:18:13.922716	\N	\N
4943	436	22	Agua	Lt	0.0600	60.00	material	2025-06-01 00:18:13.956349	2025-06-01 00:18:13.956349	\N	\N
4944	436	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:18:13.973223	2025-06-01 00:18:13.973223	\N	\N
4945	436	\N	Peón	hr	1.0000	6.25	labor	2025-06-01 00:18:13.991466	2025-06-01 00:18:13.991466	\N	\N
4946	436	\N	Capataz	hr	0.5000	18.75	labor	2025-06-01 00:18:14.008481	2025-06-01 00:18:14.008481	\N	\N
4947	436	\N	Maestro albañil	hr	1.0000	18.75	labor	2025-06-01 00:18:14.025195	2025-06-01 00:18:14.025195	\N	\N
4948	437	\N	Arenilla	m3	0.0300	100.00	material	2025-06-01 00:18:15.086816	2025-06-01 00:18:15.086816	\N	\N
4949	437	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:15.119967	2025-06-01 00:18:15.119967	\N	\N
4950	437	\N	Piso de baldosa tipo rejilla de Ho prefabricado	m2	1.0000	83.00	material	2025-06-01 00:18:15.154926	2025-06-01 00:18:15.154926	\N	\N
4951	437	\N	Ayudante	hr	1.4000	12.50	labor	2025-06-01 00:18:15.171664	2025-06-01 00:18:15.171664	\N	\N
4952	437	\N	Maestro albañil	hr	1.4000	18.75	labor	2025-06-01 00:18:15.188222	2025-06-01 00:18:15.188222	\N	\N
4953	438	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:18:16.820197	2025-06-01 00:18:16.820197	\N	\N
4954	438	5	Arena Fina	m3	0.0100	70.00	material	2025-06-01 00:18:16.853513	2025-06-01 00:18:16.853513	\N	\N
4955	438	\N	Zócalo calcáreo	ml	1.1000	4.86	material	2025-06-01 00:18:16.889194	2025-06-01 00:18:16.889194	\N	\N
4956	438	\N	Ayudante	hr	1.3000	12.50	labor	2025-06-01 00:18:16.905934	2025-06-01 00:18:16.905934	\N	\N
4957	438	\N	Maestro albañil	hr	1.3000	18.75	labor	2025-06-01 00:18:16.922902	2025-06-01 00:18:16.922902	\N	\N
4958	439	\N	Cemento portland IP-30	kg	0.8000	1.20	material	2025-06-01 00:18:17.89908	2025-06-01 00:18:17.89908	\N	\N
4959	439	22	Agua	lt	0.3000	0.06	material	2025-06-01 00:18:17.933413	2025-06-01 00:18:17.933413	\N	\N
4960	439	\N	Ayudante	hr	0.2500	12.50	labor	2025-06-01 00:18:17.950446	2025-06-01 00:18:17.950446	\N	\N
4961	439	\N	Maestro albañil	hr	0.2500	18.75	labor	2025-06-01 00:18:17.967546	2025-06-01 00:18:17.967546	\N	\N
4962	440	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:18:19.07149	2025-06-01 00:18:19.07149	\N	\N
4963	440	5	Arena Fina	m3	0.0100	70.00	material	2025-06-01 00:18:19.104595	2025-06-01 00:18:19.104595	\N	\N
4964	440	\N	Zócalo de cerámica	ml	1.1000	11.55	material	2025-06-01 00:18:19.138605	2025-06-01 00:18:19.138605	\N	\N
4965	440	\N	Ayudante	hr	0.6000	12.50	labor	2025-06-01 00:18:19.155531	2025-06-01 00:18:19.155531	\N	\N
4966	440	\N	Maestro albañil	hr	0.6000	18.75	labor	2025-06-01 00:18:19.172351	2025-06-01 00:18:19.172351	\N	\N
4967	441	\N	Cemento portland IP-30	kg	8.0000	1.20	material	2025-06-01 00:18:20.093434	2025-06-01 00:18:20.093434	\N	\N
4968	441	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:18:20.126294	2025-06-01 00:18:20.126294	\N	\N
4969	441	\N	Cerámica roja 7x15	m2	0.0700	35.00	material	2025-06-01 00:18:20.162354	2025-06-01 00:18:20.162354	\N	\N
4970	441	22	Agua	lt	4.0000	0.06	material	2025-06-01 00:18:20.198768	2025-06-01 00:18:20.198768	\N	\N
4971	441	\N	Ocre	kg	0.0200	25.00	material	2025-06-01 00:18:20.234084	2025-06-01 00:18:20.234084	\N	\N
4972	441	\N	Ayudante	hr	0.3000	12.50	labor	2025-06-01 00:18:20.251331	2025-06-01 00:18:20.251331	\N	\N
4973	441	\N	Maestro albañil	hr	0.3000	18.75	labor	2025-06-01 00:18:20.268469	2025-06-01 00:18:20.268469	\N	\N
4974	442	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:18:21.177283	2025-06-01 00:18:21.177283	\N	\N
4975	442	5	Arena Fina	m3	0.0100	70.00	material	2025-06-01 00:18:21.210439	2025-06-01 00:18:21.210439	\N	\N
4976	442	\N	Zócalo de ceramico	ml	1.1000	11.67	material	2025-06-01 00:18:21.245605	2025-06-01 00:18:21.245605	\N	\N
4977	442	\N	Ayudante	hr	0.9000	12.50	labor	2025-06-01 00:18:21.262745	2025-06-01 00:18:21.262745	\N	\N
4978	442	\N	Maestro albañil	hr	0.9000	18.75	labor	2025-06-01 00:18:21.27971	2025-06-01 00:18:21.27971	\N	\N
4979	443	\N	Cemento cola	kg	1.0000	1.25	material	2025-06-01 00:18:21.974148	2025-06-01 00:18:21.974148	\N	\N
4980	443	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:22.014567	2025-06-01 00:18:22.014567	\N	\N
4981	443	\N	Piso de porcelanato	m2	0.1000	140.00	material	2025-06-01 00:18:22.049601	2025-06-01 00:18:22.049601	\N	\N
4982	443	\N	Ayudante	hr	0.6000	12.50	labor	2025-06-01 00:18:22.066616	2025-06-01 00:18:22.066616	\N	\N
4983	443	\N	Maestro albañil	hr	0.6000	18.75	labor	2025-06-01 00:18:22.083472	2025-06-01 00:18:22.083472	\N	\N
4984	444	\N	Pegamento (clefa)	lt	0.0300	35.00	material	2025-06-01 00:18:22.746303	2025-06-01 00:18:22.746303	\N	\N
4985	444	\N	\\"flexiplast\\"	pz	0.1100	64.03	material	2025-06-01 00:18:22.781375	2025-06-01 00:18:22.781375	\N	\N
4986	444	\N	Ayudante	hr	0.5000	12.50	labor	2025-06-01 00:18:22.798232	2025-06-01 00:18:22.798232	\N	\N
4987	444	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:18:22.815201	2025-06-01 00:18:22.815201	\N	\N
4988	445	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:18:23.626492	2025-06-01 00:18:23.626492	\N	\N
4989	445	5	Arena Fina	m3	0.0100	70.00	material	2025-06-01 00:18:23.658807	2025-06-01 00:18:23.658807	\N	\N
4990	445	\N	Zócalo granítico	ml	1.1000	21.28	material	2025-06-01 00:18:23.693252	2025-06-01 00:18:23.693252	\N	\N
4991	445	\N	Ayudante	hr	1.3000	12.50	labor	2025-06-01 00:18:23.709997	2025-06-01 00:18:23.709997	\N	\N
4992	445	\N	Maestro albañil	hr	1.3000	18.75	labor	2025-06-01 00:18:23.727283	2025-06-01 00:18:23.727283	\N	\N
4993	446	\N	Bisagra de 3 pulg	pza	1.0000	12.00	material	2025-06-01 00:18:24.211008	2025-06-01 00:18:24.211008	\N	\N
4994	446	\N	Maestro carpintero	hr	1.0000	15.00	labor	2025-06-01 00:18:24.228025	2025-06-01 00:18:24.228025	\N	\N
4995	447	\N	Bisagra de 4 pulg	pza	1.0000	25.00	material	2025-06-01 00:18:24.655767	2025-06-01 00:18:24.655767	\N	\N
4996	447	\N	Maestro carpintero	hr	1.0000	15.00	labor	2025-06-01 00:18:24.672822	2025-06-01 00:18:24.672822	\N	\N
4997	448	\N	Chapa para puerta de servicio	pza	1.0000	251.20	material	2025-06-01 00:18:25.091099	2025-06-01 00:18:25.091099	\N	\N
4998	448	\N	Maestro carpintero	hr	4.0000	15.00	labor	2025-06-01 00:18:25.108437	2025-06-01 00:18:25.108437	\N	\N
4999	449	\N	Chapa para baño	pza	1.0000	249.07	material	2025-06-01 00:18:25.509537	2025-06-01 00:18:25.509537	\N	\N
5000	449	\N	Maestro carpintero	hr	4.0000	15.00	labor	2025-06-01 00:18:25.526328	2025-06-01 00:18:25.526328	\N	\N
5001	450	\N	Chapa para exteriores	pza	1.0000	410.75	material	2025-06-01 00:18:25.931901	2025-06-01 00:18:25.931901	\N	\N
5002	450	\N	Maestro carpintero	hr	4.0000	15.00	labor	2025-06-01 00:18:25.949482	2025-06-01 00:18:25.949482	\N	\N
5003	451	\N	Chapa para interiores	pza	1.0000	215.87	material	2025-06-01 00:18:26.404773	2025-06-01 00:18:26.404773	\N	\N
5004	451	\N	Maestro carpintero	hr	4.0000	15.00	labor	2025-06-01 00:18:26.420842	2025-06-01 00:18:26.420842	\N	\N
5005	452	\N	Jaladores	pza	1.0000	8.00	material	2025-06-01 00:18:26.864426	2025-06-01 00:18:26.864426	\N	\N
5006	452	\N	Maestro carpintero	hr	0.8000	15.00	labor	2025-06-01 00:18:26.881617	2025-06-01 00:18:26.881617	\N	\N
5007	453	\N	Perno de 1/2x4 pulg	pza	1.0000	6.01	material	2025-06-01 00:18:27.310168	2025-06-01 00:18:27.310168	\N	\N
5008	453	\N	Maestro carpintero	hr	0.5000	15.00	labor	2025-06-01 00:18:27.327102	2025-06-01 00:18:27.327102	\N	\N
5009	454	\N	Picaporte	pza	1.0000	6.00	material	2025-06-01 00:18:27.78708	2025-06-01 00:18:27.78708	\N	\N
5010	454	\N	Maestro carpintero	hr	0.5000	15.00	labor	2025-06-01 00:18:27.804411	2025-06-01 00:18:27.804411	\N	\N
5011	455	\N	Cemento portland IP-30	kg	1.0000	1.20	material	2025-06-01 00:18:28.632764	2025-06-01 00:18:28.632764	\N	\N
5012	455	5	Arena Fina	m3	0.0400	70.00	material	2025-06-01 00:18:28.666457	2025-06-01 00:18:28.666457	\N	\N
5013	455	\N	Clavos de 1 1/2 pulg	kg	0.0900	13.00	material	2025-06-01 00:18:28.701562	2025-06-01 00:18:28.701562	\N	\N
5014	455	22	Agua	lt	0.0100	0.06	material	2025-06-01 00:18:28.734844	2025-06-01 00:18:28.734844	\N	\N
5015	455	\N	Ayudante	hr	0.8000	12.50	labor	2025-06-01 00:18:28.752482	2025-06-01 00:18:28.752482	\N	\N
5016	455	\N	Maestro albañil	hr	0.8000	18.75	labor	2025-06-01 00:18:28.769276	2025-06-01 00:18:28.769276	\N	\N
5017	456	\N	Cemento portland IP-30	kg	1.2000	1.20	material	2025-06-01 00:18:29.243228	2025-06-01 00:18:29.243228	\N	\N
5018	456	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:18:29.279295	2025-06-01 00:18:29.279295	\N	\N
5019	456	\N	Ayudante	hr	0.1000	12.50	labor	2025-06-01 00:18:29.296706	2025-06-01 00:18:29.296706	\N	\N
5020	456	\N	Maestro albañil	hr	0.2000	18.75	labor	2025-06-01 00:18:29.313672	2025-06-01 00:18:29.313672	\N	\N
5021	457	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:18:29.718431	2025-06-01 00:18:29.718431	\N	\N
5022	457	5	Arena Fina	m3	0.0100	70.00	material	2025-06-01 00:18:29.7569	2025-06-01 00:18:29.7569	\N	\N
5023	457	\N	Ayudante	hr	0.1000	12.50	labor	2025-06-01 00:18:29.774952	2025-06-01 00:18:29.774952	\N	\N
5024	457	\N	Maestro albañil	hr	0.1500	18.75	labor	2025-06-01 00:18:29.792466	2025-06-01 00:18:29.792466	\N	\N
5025	458	\N	Cemento portland IP-30	kg	0.5000	1.20	material	2025-06-01 00:18:30.280558	2025-06-01 00:18:30.280558	\N	\N
5026	458	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:18:30.315128	2025-06-01 00:18:30.315128	\N	\N
5027	458	\N	Clavos de 1 1/2 pulg	kg	0.0900	13.00	material	2025-06-01 00:18:30.3487	2025-06-01 00:18:30.3487	\N	\N
5028	458	22	Agua	lt	0.0100	0.06	material	2025-06-01 00:18:30.383041	2025-06-01 00:18:30.383041	\N	\N
5029	458	\N	Ayudante	hr	0.5000	12.50	labor	2025-06-01 00:18:30.398728	2025-06-01 00:18:30.398728	\N	\N
5030	458	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:18:30.415261	2025-06-01 00:18:30.415261	\N	\N
5031	459	\N	Cemento portland IP-30	kg	0.7500	1.20	material	2025-06-01 00:18:30.879923	2025-06-01 00:18:30.879923	\N	\N
5032	459	\N	Ayudante	hr	0.2200	12.50	labor	2025-06-01 00:18:30.896668	2025-06-01 00:18:30.896668	\N	\N
5033	459	\N	Maestro albañil	hr	0.3500	18.75	labor	2025-06-01 00:18:30.913539	2025-06-01 00:18:30.913539	\N	\N
5034	460	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:18:31.380998	2025-06-01 00:18:31.380998	\N	\N
5035	460	5	Arena Fina	m3	0.0100	70.00	material	2025-06-01 00:18:31.414779	2025-06-01 00:18:31.414779	\N	\N
5036	460	\N	Ayudante	hr	0.1000	12.50	labor	2025-06-01 00:18:31.431558	2025-06-01 00:18:31.431558	\N	\N
5037	460	\N	Maestro albañil	hr	0.1500	18.75	labor	2025-06-01 00:18:31.448183	2025-06-01 00:18:31.448183	\N	\N
5038	461	\N	Cemento cola	kg	1.0000	1.25	material	2025-06-01 00:18:31.882543	2025-06-01 00:18:31.882543	\N	\N
5039	461	\N	Revestimiento cerámica esmaltada	m2	1.0300	65.00	material	2025-06-01 00:18:31.917319	2025-06-01 00:18:31.917319	\N	\N
5040	461	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:31.950578	2025-06-01 00:18:31.950578	\N	\N
5041	461	\N	Ayudante	hr	0.5000	12.50	labor	2025-06-01 00:18:31.967501	2025-06-01 00:18:31.967501	\N	\N
5042	461	\N	Maestro albañil	hr	1.4000	18.75	labor	2025-06-01 00:18:31.984224	2025-06-01 00:18:31.984224	\N	\N
5043	462	\N	Cemento portland IP-30	kg	5.0000	1.20	material	2025-06-01 00:18:32.462596	2025-06-01 00:18:32.462596	\N	\N
5044	462	5	Arena Fina	m3	0.0400	70.00	material	2025-06-01 00:18:32.496261	2025-06-01 00:18:32.496261	\N	\N
5237	115	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.673322	2025-06-01 09:40:55.673322	9	\N
5238	115	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.693124	2025-06-01 09:40:55.693124	3	\N
5239	112	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.712707	2025-06-01 09:40:55.712707	\N	4
5240	112	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.730788	2025-06-01 09:40:55.730788	9	\N
5241	112	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.750112	2025-06-01 09:40:55.750112	3	\N
5242	108	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.770673	2025-06-01 09:40:55.770673	\N	4
5243	108	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.788886	2025-06-01 09:40:55.788886	9	\N
5244	108	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.808429	2025-06-01 09:40:55.808429	3	\N
5245	124	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.828487	2025-06-01 09:40:55.828487	\N	4
5246	124	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.846847	2025-06-01 09:40:55.846847	9	\N
5247	124	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.866676	2025-06-01 09:40:55.866676	3	\N
5248	102	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.886525	2025-06-01 09:40:55.886525	\N	4
5249	102	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.905373	2025-06-01 09:40:55.905373	9	\N
5250	102	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.924764	2025-06-01 09:40:55.924764	3	\N
5251	118	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.944723	2025-06-01 09:40:55.944723	\N	4
5252	118	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.964176	2025-06-01 09:40:55.964176	9	\N
5253	118	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.984256	2025-06-01 09:40:55.984256	3	\N
5254	100	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:56.003839	2025-06-01 09:40:56.003839	\N	4
5255	100	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:56.023601	2025-06-01 09:40:56.023601	9	\N
5256	100	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:56.043356	2025-06-01 09:40:56.043356	3	\N
5257	122	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:56.063623	2025-06-01 09:40:56.063623	\N	4
5258	122	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:56.083222	2025-06-01 09:40:56.083222	9	\N
5259	122	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:56.102919	2025-06-01 09:40:56.102919	3	\N
5260	128	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:56.122564	2025-06-01 09:40:56.122564	\N	4
5261	128	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:56.142528	2025-06-01 09:40:56.142528	9	\N
5262	128	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:56.162525	2025-06-01 09:40:56.162525	3	\N
5263	148	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:56.182744	2025-06-01 09:40:56.182744	\N	4
5264	148	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:56.202625	2025-06-01 09:40:56.202625	9	\N
5265	148	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:56.222576	2025-06-01 09:40:56.222576	3	\N
5266	149	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:56.242021	2025-06-01 09:40:56.242021	\N	4
5267	149	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:56.261336	2025-06-01 09:40:56.261336	9	\N
5268	149	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:56.280569	2025-06-01 09:40:56.280569	3	\N
5269	132	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:56.300344	2025-06-01 09:40:56.300344	\N	4
5270	132	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:56.319764	2025-06-01 09:40:56.319764	9	\N
5271	132	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:56.339169	2025-06-01 09:40:56.339169	3	\N
5272	136	\N	Herramienta: EQUIPO DE SOLDADURA	HR.	0.3000	27.62	tool	2025-06-01 09:40:56.359512	2025-06-01 09:40:56.359512	\N	3
5273	136	\N	Herramienta: HERRAMIENTAS MENORES	%	0.3000	9.72	tool	2025-06-01 09:40:56.378988	2025-06-01 09:40:56.378988	\N	4
5274	136	\N	Mano de obra: ESPECIALISTA CERRAJERO	HR	1.0000	15.61	labor	2025-06-01 09:40:56.398431	2025-06-01 09:40:56.398431	10	\N
5275	136	\N	Mano de obra: AYUDANTE	HR	1.0000	6.25	labor	2025-06-01 09:40:56.42119	2025-06-01 09:40:56.42119	3	\N
5276	141	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:56.440873	2025-06-01 09:40:56.440873	\N	4
5277	141	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:56.460221	2025-06-01 09:40:56.460221	9	\N
5278	141	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:56.47965	2025-06-01 09:40:56.47965	3	\N
5279	180	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:56.499381	2025-06-01 09:40:56.499381	\N	4
5280	180	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:56.517836	2025-06-01 09:40:56.517836	9	\N
5281	180	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:56.537187	2025-06-01 09:40:56.537187	3	\N
5282	170	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:56.557304	2025-06-01 09:40:56.557304	\N	4
5283	170	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:56.576885	2025-06-01 09:40:56.576885	9	\N
5284	170	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:56.597426	2025-06-01 09:40:56.597426	3	\N
5285	181	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:56.617463	2025-06-01 09:40:56.617463	\N	4
5286	181	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:56.637529	2025-06-01 09:40:56.637529	9	\N
5287	181	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:56.657134	2025-06-01 09:40:56.657134	3	\N
5045	462	\N	Ladrillo refractario	m2	1.0500	120.00	material	2025-06-01 00:18:32.531033	2025-06-01 00:18:32.531033	\N	\N
5046	462	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:32.563201	2025-06-01 00:18:32.563201	\N	\N
5047	462	\N	Ayudante	hr	4.5000	12.50	labor	2025-06-01 00:18:32.579937	2025-06-01 00:18:32.579937	\N	\N
5048	462	\N	Maestro albañil	hr	4.5000	18.75	labor	2025-06-01 00:18:32.597023	2025-06-01 00:18:32.597023	\N	\N
5049	463	\N	Cemento portland IP-30	kg	5.0000	1.20	material	2025-06-01 00:18:33.017542	2025-06-01 00:18:33.017542	\N	\N
5050	463	5	Arena Fina	m3	0.0400	70.00	material	2025-06-01 00:18:33.050762	2025-06-01 00:18:33.050762	\N	\N
5051	463	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:33.084174	2025-06-01 00:18:33.084174	\N	\N
5052	463	\N	Piedra pirka	m2	1.1000	80.00	material	2025-06-01 00:18:33.118911	2025-06-01 00:18:33.118911	\N	\N
5053	463	\N	Ayudante	hr	4.5000	12.50	labor	2025-06-01 00:18:33.135739	2025-06-01 00:18:33.135739	\N	\N
5054	463	\N	Maestro albañil	hr	4.5000	18.75	labor	2025-06-01 00:18:33.152749	2025-06-01 00:18:33.152749	\N	\N
5055	464	\N	Cemento portland IP-30	kg	10.0000	1.20	material	2025-06-01 00:18:33.566573	2025-06-01 00:18:33.566573	\N	\N
5056	464	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:18:33.609066	2025-06-01 00:18:33.609066	\N	\N
5057	464	\N	Azulejo blanco de 15x15cm	m2	1.1000	35.00	material	2025-06-01 00:18:33.64403	2025-06-01 00:18:33.64403	\N	\N
5058	464	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:18:33.661157	2025-06-01 00:18:33.661157	\N	\N
5059	464	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:18:33.678234	2025-06-01 00:18:33.678234	\N	\N
5060	465	\N	Cemento portland IP-30	kg	0.1000	1.20	material	2025-06-01 00:18:34.092234	2025-06-01 00:18:34.092234	\N	\N
5061	465	\N	Azulejo decorado	m2	1.0500	125.00	material	2025-06-01 00:18:34.125712	2025-06-01 00:18:34.125712	\N	\N
5062	465	\N	Ayudante	hr	0.3000	12.50	labor	2025-06-01 00:18:34.143474	2025-06-01 00:18:34.143474	\N	\N
5063	465	\N	Maestro albañil	hr	0.3000	18.75	labor	2025-06-01 00:18:34.160257	2025-06-01 00:18:34.160257	\N	\N
5064	466	\N	Cemento portland IP-30	kg	10.0000	1.20	material	2025-06-01 00:18:34.589949	2025-06-01 00:18:34.589949	\N	\N
5065	466	5	Arena Fina	m3	0.0500	70.00	material	2025-06-01 00:18:34.625186	2025-06-01 00:18:34.625186	\N	\N
5066	466	\N	Enchape corto Incerpaz	m2	1.1000	71.00	material	2025-06-01 00:18:34.662373	2025-06-01 00:18:34.662373	\N	\N
5067	466	\N	Ayudante	hr	2.9000	12.50	labor	2025-06-01 00:18:34.680475	2025-06-01 00:18:34.680475	\N	\N
5068	466	\N	Maestro albañil	hr	2.9000	18.75	labor	2025-06-01 00:18:34.697547	2025-06-01 00:18:34.697547	\N	\N
5069	467	\N	Cemento portland IP-30	kg	5.0000	1.20	material	2025-06-01 00:18:35.108088	2025-06-01 00:18:35.108088	\N	\N
5070	467	5	Arena Fina	m3	0.0400	70.00	material	2025-06-01 00:18:35.141559	2025-06-01 00:18:35.141559	\N	\N
5071	467	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:35.1755	2025-06-01 00:18:35.1755	\N	\N
5072	467	\N	Piedra Laja	m2	1.1000	90.00	material	2025-06-01 00:18:35.211009	2025-06-01 00:18:35.211009	\N	\N
5073	467	\N	Ayudante	hr	4.2000	12.50	labor	2025-06-01 00:18:35.227969	2025-06-01 00:18:35.227969	\N	\N
5074	467	\N	Maestro albañil	hr	4.2000	18.75	labor	2025-06-01 00:18:35.243837	2025-06-01 00:18:35.243837	\N	\N
5075	468	\N	Cemento portland IP-30	kg	7.0000	1.20	material	2025-06-01 00:18:35.650171	2025-06-01 00:18:35.650171	\N	\N
5076	468	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:18:35.683887	2025-06-01 00:18:35.683887	\N	\N
5077	468	22	Agua	lt	6.0000	0.06	material	2025-06-01 00:18:35.717424	2025-06-01 00:18:35.717424	\N	\N
5078	468	\N	Piedra listón	m2	1.1000	100.00	material	2025-06-01 00:18:35.75208	2025-06-01 00:18:35.75208	\N	\N
5079	468	\N	Ayudante	hr	1.4000	12.50	labor	2025-06-01 00:18:35.768792	2025-06-01 00:18:35.768792	\N	\N
5080	468	\N	Maestro albañil	hr	1.4000	18.75	labor	2025-06-01 00:18:35.786353	2025-06-01 00:18:35.786353	\N	\N
5081	469	\N	Cemento portland IP-30	kg	8.0000	1.20	material	2025-06-01 00:18:36.335859	2025-06-01 00:18:36.335859	\N	\N
5082	469	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:18:36.369607	2025-06-01 00:18:36.369607	\N	\N
5083	469	22	Agua	lt	3.0000	0.06	material	2025-06-01 00:18:36.403261	2025-06-01 00:18:36.403261	\N	\N
5084	469	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:18:36.420935	2025-06-01 00:18:36.420935	\N	\N
5085	469	\N	Maestro albañil	hr	1.0000	18.75	labor	2025-06-01 00:18:36.444663	2025-06-01 00:18:36.444663	\N	\N
5086	470	\N	Cemento portland IP-30	kg	6.5000	1.20	material	2025-06-01 00:18:36.865583	2025-06-01 00:18:36.865583	\N	\N
5087	470	\N	Estuco	kg	17.5000	0.75	material	2025-06-01 00:18:36.900119	2025-06-01 00:18:36.900119	\N	\N
5088	470	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:18:36.937042	2025-06-01 00:18:36.937042	\N	\N
5089	470	22	Agua	lt	4.2000	0.06	material	2025-06-01 00:18:36.973045	2025-06-01 00:18:36.973045	\N	\N
5090	470	\N	Ayudante	hr	1.1000	12.50	labor	2025-06-01 00:18:36.99001	2025-06-01 00:18:36.99001	\N	\N
5091	470	\N	Maestro albañil	hr	1.1000	18.75	labor	2025-06-01 00:18:37.006917	2025-06-01 00:18:37.006917	\N	\N
5092	471	\N	Cemento portland IP-30	kg	8.2000	1.20	material	2025-06-01 00:18:37.414689	2025-06-01 00:18:37.414689	\N	\N
5093	471	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:18:37.448138	2025-06-01 00:18:37.448138	\N	\N
5094	471	\N	Ayudante	hr	1.5000	12.50	labor	2025-06-01 00:18:37.465255	2025-06-01 00:18:37.465255	\N	\N
5095	471	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:18:37.483749	2025-06-01 00:18:37.483749	\N	\N
5096	472	\N	Cemento portland IP-30	kg	8.0000	1.20	material	2025-06-01 00:18:37.93889	2025-06-01 00:18:37.93889	\N	\N
5097	472	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:18:37.97268	2025-06-01 00:18:37.97268	\N	\N
5098	472	22	Agua	lt	3.0000	0.06	material	2025-06-01 00:18:38.006769	2025-06-01 00:18:38.006769	\N	\N
5099	472	\N	Ayudante	hr	0.2200	12.50	labor	2025-06-01 00:18:38.025092	2025-06-01 00:18:38.025092	\N	\N
5100	472	\N	Maestro albañil	hr	1.2000	18.75	labor	2025-06-01 00:18:38.041995	2025-06-01 00:18:38.041995	\N	\N
5101	473	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:18:38.542257	2025-06-01 00:18:38.542257	\N	\N
5102	473	5	Arena Fina	m3	0.0100	70.00	material	2025-06-01 00:18:38.575547	2025-06-01 00:18:38.575547	\N	\N
5103	473	\N	Zócalo de ceramica esmaltada	ml	1.1000	11.00	material	2025-06-01 00:18:38.611019	2025-06-01 00:18:38.611019	\N	\N
5104	473	\N	Ayudante	hr	0.6000	12.50	labor	2025-06-01 00:18:38.627706	2025-06-01 00:18:38.627706	\N	\N
5105	473	\N	Maestro albañil	hr	0.6000	18.75	labor	2025-06-01 00:18:38.647551	2025-06-01 00:18:38.647551	\N	\N
5106	474	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:18:39.082849	2025-06-01 00:18:39.082849	\N	\N
5107	474	5	Arena Fina	m3	0.0100	70.00	material	2025-06-01 00:18:39.117379	2025-06-01 00:18:39.117379	\N	\N
5108	474	\N	Zócalo de cerámica española	ml	1.1000	12.16	material	2025-06-01 00:18:39.15221	2025-06-01 00:18:39.15221	\N	\N
5109	474	\N	Ayudante	hr	0.6000	12.50	labor	2025-06-01 00:18:39.168917	2025-06-01 00:18:39.168917	\N	\N
5110	474	\N	Maestro albañil	hr	0.6000	18.75	labor	2025-06-01 00:18:39.186133	2025-06-01 00:18:39.186133	\N	\N
5111	475	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:18:39.605326	2025-06-01 00:18:39.605326	\N	\N
5112	475	5	Arena Fina	m3	0.0100	70.00	material	2025-06-01 00:18:39.639576	2025-06-01 00:18:39.639576	\N	\N
5113	475	\N	Zócalo de cerámica gres	ml	1.0500	3.04	material	2025-06-01 00:18:39.675617	2025-06-01 00:18:39.675617	\N	\N
5114	475	\N	Ayudante	hr	1.3000	12.50	labor	2025-06-01 00:18:39.692357	2025-06-01 00:18:39.692357	\N	\N
5115	475	\N	Maestro albañil	hr	1.3000	18.75	labor	2025-06-01 00:18:39.709262	2025-06-01 00:18:39.709262	\N	\N
5116	476	\N	Tornillo de encarne de 1 1/2 pulg	pza	2.0000	1.22	material	2025-06-01 00:18:40.100531	2025-06-01 00:18:40.100531	\N	\N
5117	476	\N	Tarugo plástico para tornillo de encarne	pza	0.6000	0.91	material	2025-06-01 00:18:40.13633	2025-06-01 00:18:40.13633	\N	\N
5118	476	\N	Zócalo de madera roble de 3 pulg	ml	1.1000	9.12	material	2025-06-01 00:18:40.171168	2025-06-01 00:18:40.171168	\N	\N
5119	476	\N	Ayudante (carpintero)	hr	0.6000	12.50	labor	2025-06-01 00:18:40.188076	2025-06-01 00:18:40.188076	\N	\N
5120	476	\N	Maestro carpintero	hr	0.5000	15.00	labor	2025-06-01 00:18:40.204607	2025-06-01 00:18:40.204607	\N	\N
5121	477	\N	Espejo 3mm	m2	1.0000	85.12	material	2025-06-01 00:18:40.786273	2025-06-01 00:18:40.786273	\N	\N
5122	477	\N	Maestro vidriero	hr	1.0000	18.75	labor	2025-06-01 00:18:40.802949	2025-06-01 00:18:40.802949	\N	\N
5123	478	\N	Espejo 8mm	m2	1.0000	158.08	material	2025-06-01 00:18:41.163814	2025-06-01 00:18:41.163814	\N	\N
5124	478	\N	Maestro vidriero	hr	1.0000	18.75	labor	2025-06-01 00:18:41.180544	2025-06-01 00:18:41.180544	\N	\N
5125	479	\N	Domus de aluminio y vidrio	gbl	1.0000	1.00	material	2025-06-01 00:18:41.532261	2025-06-01 00:18:41.532261	\N	\N
5126	480	\N	Vidrio de 4mm	m2	1.0000	100.63	material	2025-06-01 00:18:41.891297	2025-06-01 00:18:41.891297	\N	\N
5127	480	\N	Maestro vidriero	hr	1.0000	18.75	labor	2025-06-01 00:18:41.908092	2025-06-01 00:18:41.908092	\N	\N
5288	184	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:56.676713	2025-06-01 09:40:56.676713	\N	4
5289	184	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:56.696591	2025-06-01 09:40:56.696591	9	\N
5130	481	\N	Silicona p/vidrio	tbo	0.0200	17.52	material	2025-06-01 00:18:42.640124	2025-06-01 00:18:42.640124	\N	\N
5131	481	\N	Vidrio acanalado	p2	1.0000	7.56	material	2025-06-01 00:18:42.673876	2025-06-01 00:18:42.673876	\N	\N
5132	481	\N	Maestro vidriero	hr	0.0200	18.75	labor	2025-06-01 00:18:42.695655	2025-06-01 00:18:42.695655	\N	\N
5133	482	\N	Vidrio templado de 10 mm	m2	1.0000	500.00	material	2025-06-01 00:18:43.053878	2025-06-01 00:18:43.053878	\N	\N
5134	483	\N	Vidrio templado de 10 mm	m2	1.0000	500.00	material	2025-06-01 00:18:43.412633	2025-06-01 00:18:43.412633	\N	\N
5135	484	\N	Vidrio catedral	p2	10.9000	10.00	material	2025-06-01 00:18:43.769052	2025-06-01 00:18:43.769052	\N	\N
5136	484	\N	Maestro vidriero	hr	1.0000	18.75	labor	2025-06-01 00:18:43.786399	2025-06-01 00:18:43.786399	\N	\N
5137	485	\N	Vidrio doble	p2	10.9000	8.00	material	2025-06-01 00:18:44.151359	2025-06-01 00:18:44.151359	\N	\N
5138	485	\N	Maestro vidriero	hr	1.0000	18.75	labor	2025-06-01 00:18:44.168423	2025-06-01 00:18:44.168423	\N	\N
5290	184	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:56.717533	2025-06-01 09:40:56.717533	3	\N
5291	281	\N	Herramienta: HERRAMIENTAS MENORES	%	0.1000	9.72	tool	2025-06-01 09:40:56.738419	2025-06-01 09:40:56.738419	\N	4
5292	281	\N	Mano de obra: ELECTRICISTA	HR	0.8000	15.01	labor	2025-06-01 09:40:56.758399	2025-06-01 09:40:56.758399	12	\N
5293	281	\N	Mano de obra: AYUDANTE	HR	0.8000	6.25	labor	2025-06-01 09:40:56.778761	2025-06-01 09:40:56.778761	3	\N
5294	381	\N	Herramienta: EQUIPO DE SOLDADURA	HR.	0.3000	27.62	tool	2025-06-01 09:40:56.802913	2025-06-01 09:40:56.802913	\N	3
5295	381	\N	Herramienta: HERRAMIENTAS MENORES	%	0.3000	9.72	tool	2025-06-01 09:40:56.825672	2025-06-01 09:40:56.825672	\N	4
5296	381	\N	Mano de obra: ESPECIALISTA CERRAJERO	HR	1.0000	15.61	labor	2025-06-01 09:40:56.845343	2025-06-01 09:40:56.845343	10	\N
5297	381	\N	Mano de obra: AYUDANTE	HR	1.0000	6.25	labor	2025-06-01 09:40:56.864964	2025-06-01 09:40:56.864964	3	\N
5298	359	\N	Herramienta: MEZCLADORA	HR.	0.5000	39.00	tool	2025-06-01 09:40:56.884793	2025-06-01 09:40:56.884793	\N	5
5299	359	\N	Herramienta: VIBRADORA	HR.	0.5000	21.12	tool	2025-06-01 09:40:56.904187	2025-06-01 09:40:56.904187	\N	7
5300	359	\N	Mano de obra: ALBAÑIL	HR	1.5000	10.00	labor	2025-06-01 09:40:56.923631	2025-06-01 09:40:56.923631	2	\N
5301	359	\N	Mano de obra: PEON	HR	1.5000	4.50	labor	2025-06-01 09:40:56.943307	2025-06-01 09:40:56.943307	1	\N
5302	377	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:56.962863	2025-06-01 09:40:56.962863	\N	4
5303	377	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:56.983205	2025-06-01 09:40:56.983205	9	\N
5304	377	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:57.002431	2025-06-01 09:40:57.002431	3	\N
5305	382	\N	Herramienta: RETROEXCAVADORA	HR.	0.2500	299.00	tool	2025-06-01 09:40:57.020838	2025-06-01 09:40:57.020838	\N	6
5306	382	\N	Herramienta: VOLQUETA	M3	0.2500	24.38	tool	2025-06-01 09:40:57.04051	2025-06-01 09:40:57.04051	\N	8
5307	382	\N	Mano de obra: PEON	HR	2.0000	4.50	labor	2025-06-01 09:40:57.058863	2025-06-01 09:40:57.058863	1	\N
5308	382	\N	Mano de obra: AYUDANTE	HR	2.0000	6.25	labor	2025-06-01 09:40:57.077805	2025-06-01 09:40:57.077805	3	\N
5309	396	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:57.09751	2025-06-01 09:40:57.09751	\N	4
5310	396	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:57.119896	2025-06-01 09:40:57.119896	9	\N
5311	396	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:57.13938	2025-06-01 09:40:57.13938	3	\N
5312	392	\N	Herramienta: COMPACTADORAS	%	0.3000	32.50	tool	2025-06-01 09:40:57.160292	2025-06-01 09:40:57.160292	\N	2
5313	392	\N	Herramienta: VIBRADORA	HR.	0.3000	21.12	tool	2025-06-01 09:40:57.179946	2025-06-01 09:40:57.179946	\N	7
5314	392	\N	Mano de obra: ESPECIALISTA	HR	1.0000	18.01	labor	2025-06-01 09:40:57.199554	2025-06-01 09:40:57.199554	4	\N
5315	392	\N	Mano de obra: PEON	HR	1.0000	4.50	labor	2025-06-01 09:40:57.219698	2025-06-01 09:40:57.219698	1	\N
5316	385	\N	Herramienta: RETROEXCAVADORA	HR.	0.2500	299.00	tool	2025-06-01 09:40:57.239456	2025-06-01 09:40:57.239456	\N	6
5317	385	\N	Herramienta: VOLQUETA	M3	0.2500	24.38	tool	2025-06-01 09:40:57.258824	2025-06-01 09:40:57.258824	\N	8
5318	385	\N	Mano de obra: PEON	HR	2.0000	4.50	labor	2025-06-01 09:40:57.279187	2025-06-01 09:40:57.279187	1	\N
5319	385	\N	Mano de obra: AYUDANTE	HR	2.0000	6.25	labor	2025-06-01 09:40:57.298621	2025-06-01 09:40:57.298621	3	\N
5320	402	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:57.318219	2025-06-01 09:40:57.318219	\N	4
5321	402	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:57.33754	2025-06-01 09:40:57.33754	9	\N
5322	402	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:57.355827	2025-06-01 09:40:57.355827	3	\N
5323	393	\N	Herramienta: COMPACTADORAS	%	0.3000	32.50	tool	2025-06-01 09:40:57.375336	2025-06-01 09:40:57.375336	\N	2
5324	393	\N	Herramienta: VIBRADORA	HR.	0.3000	21.12	tool	2025-06-01 09:40:57.393972	2025-06-01 09:40:57.393972	\N	7
5325	393	\N	Mano de obra: ESPECIALISTA	HR	1.0000	18.01	labor	2025-06-01 09:40:57.413411	2025-06-01 09:40:57.413411	4	\N
5326	393	\N	Mano de obra: PEON	HR	1.0000	4.50	labor	2025-06-01 09:40:57.431821	2025-06-01 09:40:57.431821	1	\N
5327	449	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:57.451444	2025-06-01 09:40:57.451444	\N	4
5328	449	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:57.471521	2025-06-01 09:40:57.471521	9	\N
5329	449	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:57.491541	2025-06-01 09:40:57.491541	3	\N
5330	437	\N	Herramienta: MEZCLADORA	HR.	0.5000	39.00	tool	2025-06-01 09:40:57.511013	2025-06-01 09:40:57.511013	\N	5
5331	437	\N	Herramienta: VIBRADORA	HR.	0.5000	21.12	tool	2025-06-01 09:40:57.530789	2025-06-01 09:40:57.530789	\N	7
5332	437	\N	Mano de obra: ALBAÑIL	HR	1.5000	10.00	labor	2025-06-01 09:40:57.550975	2025-06-01 09:40:57.550975	2	\N
5333	437	\N	Mano de obra: PEON	HR	1.5000	4.50	labor	2025-06-01 09:40:57.57069	2025-06-01 09:40:57.57069	1	\N
5334	454	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:57.590081	2025-06-01 09:40:57.590081	\N	4
5335	454	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:57.609558	2025-06-01 09:40:57.609558	9	\N
5336	454	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:57.62913	2025-06-01 09:40:57.62913	3	\N
5337	451	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:57.648701	2025-06-01 09:40:57.648701	\N	4
5338	451	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:57.670393	2025-06-01 09:40:57.670393	9	\N
5339	451	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:57.690227	2025-06-01 09:40:57.690227	3	\N
5340	448	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:57.710113	2025-06-01 09:40:57.710113	\N	4
5341	448	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:57.729858	2025-06-01 09:40:57.729858	9	\N
5342	448	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:57.749153	2025-06-01 09:40:57.749153	3	\N
5343	450	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:57.770616	2025-06-01 09:40:57.770616	\N	4
5344	450	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:57.790442	2025-06-01 09:40:57.790442	9	\N
5345	450	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:57.810899	2025-06-01 09:40:57.810899	3	\N
5346	131	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:57.830164	2025-06-01 09:40:57.830164	\N	4
5155	92	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:53.978896	2025-06-01 09:40:53.978896	\N	4
5156	92	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:53.998526	2025-06-01 09:40:53.998526	9	\N
5157	92	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.016859	2025-06-01 09:40:54.016859	3	\N
5158	86	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.036646	2025-06-01 09:40:54.036646	\N	4
5159	86	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.056309	2025-06-01 09:40:54.056309	9	\N
5160	86	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.076117	2025-06-01 09:40:54.076117	3	\N
5161	87	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.096437	2025-06-01 09:40:54.096437	\N	4
5162	87	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.116734	2025-06-01 09:40:54.116734	9	\N
5163	87	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.136193	2025-06-01 09:40:54.136193	3	\N
5164	81	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.154797	2025-06-01 09:40:54.154797	\N	4
5165	81	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.175214	2025-06-01 09:40:54.175214	9	\N
5166	81	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.193856	2025-06-01 09:40:54.193856	3	\N
5167	89	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.213399	2025-06-01 09:40:54.213399	\N	4
5168	89	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.232602	2025-06-01 09:40:54.232602	9	\N
5169	89	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.259286	2025-06-01 09:40:54.259286	3	\N
5170	78	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.27984	2025-06-01 09:40:54.27984	\N	4
5171	78	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.299845	2025-06-01 09:40:54.299845	9	\N
5172	78	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.319586	2025-06-01 09:40:54.319586	3	\N
5173	80	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.339545	2025-06-01 09:40:54.339545	\N	4
5174	80	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.359169	2025-06-01 09:40:54.359169	9	\N
5175	80	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.381755	2025-06-01 09:40:54.381755	3	\N
5176	84	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.401645	2025-06-01 09:40:54.401645	\N	4
5177	84	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.421424	2025-06-01 09:40:54.421424	9	\N
5178	84	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.44128	2025-06-01 09:40:54.44128	3	\N
5179	82	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.465331	2025-06-01 09:40:54.465331	\N	4
5180	82	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.485884	2025-06-01 09:40:54.485884	9	\N
5181	82	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.505444	2025-06-01 09:40:54.505444	3	\N
5182	79	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.537688	2025-06-01 09:40:54.537688	\N	4
5183	79	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.562045	2025-06-01 09:40:54.562045	9	\N
5184	79	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.581893	2025-06-01 09:40:54.581893	3	\N
5185	83	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.603137	2025-06-01 09:40:54.603137	\N	4
5186	83	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.626816	2025-06-01 09:40:54.626816	9	\N
5187	83	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.646951	2025-06-01 09:40:54.646951	3	\N
5188	107	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.666824	2025-06-01 09:40:54.666824	\N	4
5189	107	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.692318	2025-06-01 09:40:54.692318	9	\N
5190	107	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.712618	2025-06-01 09:40:54.712618	3	\N
5191	110	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.732423	2025-06-01 09:40:54.732423	\N	4
5192	110	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.754368	2025-06-01 09:40:54.754368	9	\N
5193	110	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.774289	2025-06-01 09:40:54.774289	3	\N
5194	93	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.798673	2025-06-01 09:40:54.798673	\N	4
5195	93	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.818539	2025-06-01 09:40:54.818539	9	\N
5196	93	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.83874	2025-06-01 09:40:54.83874	3	\N
5197	106	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.85823	2025-06-01 09:40:54.85823	\N	4
5198	106	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.883297	2025-06-01 09:40:54.883297	9	\N
5199	106	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.901874	2025-06-01 09:40:54.901874	3	\N
5200	101	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.921773	2025-06-01 09:40:54.921773	\N	4
5201	101	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:54.94213	2025-06-01 09:40:54.94213	9	\N
5202	101	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:54.962641	2025-06-01 09:40:54.962641	3	\N
5203	123	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:54.983887	2025-06-01 09:40:54.983887	\N	4
5204	123	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.004792	2025-06-01 09:40:55.004792	9	\N
5205	123	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.033401	2025-06-01 09:40:55.033401	3	\N
5206	114	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.05703	2025-06-01 09:40:55.05703	\N	4
5207	114	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.081779	2025-06-01 09:40:55.081779	9	\N
2570	32	105	Cemento blanco	kg	0.5000	7.00	material	2025-06-01 00:14:28.667193	2025-06-01 00:14:28.667193	\N	\N
2571	32	\N	Cemento portland IP-30	kg	5.0000	1.20	material	2025-06-01 00:14:28.736465	2025-06-01 00:14:28.736465	\N	\N
2572	32	\N	Accesorios de baño (jabonero, toallero, papelero, perchero)	jgo	1.0000	196.25	material	2025-06-01 00:14:28.772572	2025-06-01 00:14:28.772572	\N	\N
2573	32	\N	Ayudante	hr	3.5000	12.50	labor	2025-06-01 00:14:28.789758	2025-06-01 00:14:28.789758	\N	\N
2574	32	\N	Maestro albañil	hr	3.5000	18.75	labor	2025-06-01 00:14:28.807801	2025-06-01 00:14:28.807801	\N	\N
2575	33	105	Cemento blanco	kg	0.4500	7.00	material	2025-06-01 00:14:29.234296	2025-06-01 00:14:29.234296	\N	\N
2576	33	\N	Cemento portland IP-30	kg	8.0000	1.20	material	2025-06-01 00:14:29.274352	2025-06-01 00:14:29.274352	\N	\N
2577	33	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:14:29.308037	2025-06-01 00:14:29.308037	\N	\N
2578	33	\N	Bacha para ducha	pza	1.0000	420.00	material	2025-06-01 00:14:29.344113	2025-06-01 00:14:29.344113	\N	\N
2579	33	\N	Ayudante (plomero)	hr	4.0000	12.50	labor	2025-06-01 00:14:29.361553	2025-06-01 00:14:29.361553	\N	\N
2580	33	\N	Maestro plomero	hr	4.0000	17.50	labor	2025-06-01 00:14:29.37871	2025-06-01 00:14:29.37871	\N	\N
2581	34	\N	Bañera de hidromasaje de fibra de vidrio 1.60x0.95	pza	1.0000	5.00	material	2025-06-01 00:14:29.762178	2025-06-01 00:14:29.762178	\N	\N
2582	34	\N	Maestro albañil	hr	10.0000	18.75	labor	2025-06-01 00:14:29.779222	2025-06-01 00:14:29.779222	\N	\N
2583	34	\N	Maestro plomero	hr	10.0000	17.50	labor	2025-06-01 00:14:29.796284	2025-06-01 00:14:29.796284	\N	\N
2584	34	\N	Instalación de tina de hidromasaje	gbl	1.0000	1.50	labor	2025-06-01 00:14:29.813895	2025-06-01 00:14:29.813895	\N	\N
2585	35	105	Cemento blanco	kg	0.4000	7.00	material	2025-06-01 00:14:30.200314	2025-06-01 00:14:30.200314	\N	\N
2586	35	\N	Bidet standar blanco	pza	1.0000	382.00	material	2025-06-01 00:14:30.237064	2025-06-01 00:14:30.237064	\N	\N
2587	35	\N	Tirafondo 4 1/2x1/4	pza	4.0000	2.50	material	2025-06-01 00:14:30.271707	2025-06-01 00:14:30.271707	\N	\N
2588	35	\N	Ayudante (plomero)	hr	3.4000	12.50	labor	2025-06-01 00:14:30.288605	2025-06-01 00:14:30.288605	\N	\N
2589	35	\N	Maestro plomero	hr	3.4000	17.50	labor	2025-06-01 00:14:30.305557	2025-06-01 00:14:30.305557	\N	\N
2590	36	105	Cemento blanco	kg	0.4000	7.00	material	2025-06-01 00:14:30.675683	2025-06-01 00:14:30.675683	\N	\N
2591	36	\N	Bidet standar de color	pza	1.0000	420.00	material	2025-06-01 00:14:30.710416	2025-06-01 00:14:30.710416	\N	\N
2592	36	\N	Tirafondo 4 1/2x1/4	pza	4.0000	2.50	material	2025-06-01 00:14:30.745189	2025-06-01 00:14:30.745189	\N	\N
2593	36	\N	Ayudante (plomero)	hr	3.4000	12.50	labor	2025-06-01 00:14:30.762714	2025-06-01 00:14:30.762714	\N	\N
2594	36	\N	Maestro plomero	hr	3.4000	17.50	labor	2025-06-01 00:14:30.77962	2025-06-01 00:14:30.77962	\N	\N
2595	37	\N	Botiquin 1 cuerpo c/espejo	pza	1.0000	131.15	material	2025-06-01 00:14:31.226607	2025-06-01 00:14:31.226607	\N	\N
2596	37	\N	Ayudante	hr	0.3000	12.50	labor	2025-06-01 00:14:31.243985	2025-06-01 00:14:31.243985	\N	\N
2597	37	\N	Maestro albañil	hr	0.3000	18.75	labor	2025-06-01 00:14:31.260999	2025-06-01 00:14:31.260999	\N	\N
2598	38	\N	Box de baño con aluminio y acrílico	m2	1.0000	418.00	material	2025-06-01 00:14:31.641979	2025-06-01 00:14:31.641979	\N	\N
2599	39	\N	Ducha eléctrica	pza	1.0000	90.00	material	2025-06-01 00:14:32.03465	2025-06-01 00:14:32.03465	\N	\N
2600	39	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:32.071927	2025-06-01 00:14:32.071927	\N	\N
2601	39	\N	Cinta aislante	pza	0.1000	6.00	material	2025-06-01 00:14:32.106872	2025-06-01 00:14:32.106872	\N	\N
2602	39	\N	Cañería de aluminio de 1/2 pulg	pza	1.0000	18.00	material	2025-06-01 00:14:32.142489	2025-06-01 00:14:32.142489	\N	\N
2603	39	\N	Ayudante (plomero)	hr	2.5000	12.50	labor	2025-06-01 00:14:32.159433	2025-06-01 00:14:32.159433	\N	\N
2604	39	\N	Maestro plomero	hr	2.5000	17.50	labor	2025-06-01 00:14:32.176534	2025-06-01 00:14:32.176534	\N	\N
2605	40	\N	Ducha sanitaria	pza	1.0000	280.00	material	2025-06-01 00:14:32.548475	2025-06-01 00:14:32.548475	\N	\N
2606	40	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:32.587222	2025-06-01 00:14:32.587222	\N	\N
2607	40	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:32.623388	2025-06-01 00:14:32.623388	\N	\N
2608	40	\N	Ayudante (plomero)	hr	2.8000	12.50	labor	2025-06-01 00:14:32.640266	2025-06-01 00:14:32.640266	\N	\N
2609	40	\N	Maestro plomero	hr	2.8000	17.50	labor	2025-06-01 00:14:32.657231	2025-06-01 00:14:32.657231	\N	\N
2610	41	\N	Espejo doble	m2	1.0000	200.00	material	2025-06-01 00:14:33.012399	2025-06-01 00:14:33.012399	\N	\N
2611	42	\N	Chicotillo plástico	pza	1.0000	20.00	material	2025-06-01 00:14:33.386475	2025-06-01 00:14:33.386475	\N	\N
2612	42	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:33.424982	2025-06-01 00:14:33.424982	\N	\N
2613	42	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:33.460138	2025-06-01 00:14:33.460138	\N	\N
2614	42	\N	Grifería lavamanos simple	pza	1.0000	185.00	material	2025-06-01 00:14:33.495342	2025-06-01 00:14:33.495342	\N	\N
2615	42	\N	Ayudante (plomero)	hr	2.5000	12.50	labor	2025-06-01 00:14:33.512697	2025-06-01 00:14:33.512697	\N	\N
2616	42	\N	Maestro plomero	hr	2.5000	17.50	labor	2025-06-01 00:14:33.529512	2025-06-01 00:14:33.529512	\N	\N
2617	43	\N	Chicotillo plástico	pza	1.0000	20.00	material	2025-06-01 00:14:33.906147	2025-06-01 00:14:33.906147	\N	\N
2618	43	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:33.941264	2025-06-01 00:14:33.941264	\N	\N
2619	43	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:33.975608	2025-06-01 00:14:33.975608	\N	\N
2620	43	\N	Grifería lavamanos mezcladora	jgo	1.0000	264.80	material	2025-06-01 00:14:34.010356	2025-06-01 00:14:34.010356	\N	\N
2621	43	\N	Ayudante (plomero)	hr	2.5000	12.50	labor	2025-06-01 00:14:34.027341	2025-06-01 00:14:34.027341	\N	\N
2622	43	\N	Maestro plomero	hr	2.5000	17.50	labor	2025-06-01 00:14:34.044467	2025-06-01 00:14:34.044467	\N	\N
2623	44	\N	Chicotillo plástico	pza	2.0000	20.00	material	2025-06-01 00:14:34.440313	2025-06-01 00:14:34.440313	\N	\N
2624	44	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:34.475225	2025-06-01 00:14:34.475225	\N	\N
2625	44	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:34.509852	2025-06-01 00:14:34.509852	\N	\N
2626	44	\N	Grifería lavamanos simple	pza	1.0000	185.00	material	2025-06-01 00:14:34.545405	2025-06-01 00:14:34.545405	\N	\N
2627	44	\N	Ayudante (plomero)	hr	2.5000	12.50	labor	2025-06-01 00:14:34.562798	2025-06-01 00:14:34.562798	\N	\N
2628	44	\N	Maestro plomero	hr	2.5000	17.50	labor	2025-06-01 00:14:34.579538	2025-06-01 00:14:34.579538	\N	\N
2629	45	\N	Chicotillo plástico	pza	1.0000	20.00	material	2025-06-01 00:14:34.952828	2025-06-01 00:14:34.952828	\N	\N
2630	45	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:34.987837	2025-06-01 00:14:34.987837	\N	\N
2631	45	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:35.022895	2025-06-01 00:14:35.022895	\N	\N
2632	45	\N	Grifería lavaplatos (pico móvil)	pza	1.0000	245.00	material	2025-06-01 00:14:35.058347	2025-06-01 00:14:35.058347	\N	\N
2633	45	\N	Ayudante (plomero)	hr	2.5000	12.50	labor	2025-06-01 00:14:35.075446	2025-06-01 00:14:35.075446	\N	\N
2634	45	\N	Maestro plomero	hr	2.5000	17.50	labor	2025-06-01 00:14:35.092232	2025-06-01 00:14:35.092232	\N	\N
2635	46	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:35.464947	2025-06-01 00:14:35.464947	\N	\N
2636	46	\N	Grifería lavarropa	pza	1.0000	52.58	material	2025-06-01 00:14:35.502618	2025-06-01 00:14:35.502618	\N	\N
2637	46	\N	Ayudante (plomero)	hr	1.8000	12.50	labor	2025-06-01 00:14:35.519656	2025-06-01 00:14:35.519656	\N	\N
2638	46	\N	Maestro plomero	hr	2.5000	17.50	labor	2025-06-01 00:14:35.53834	2025-06-01 00:14:35.53834	\N	\N
2639	47	\N	Teflón 3/4 pulg	pza	0.1500	3.00	material	2025-06-01 00:14:35.917028	2025-06-01 00:14:35.917028	\N	\N
2640	47	\N	Grifería ducha	jgo	1.0000	312.32	material	2025-06-01 00:14:35.952871	2025-06-01 00:14:35.952871	\N	\N
2641	47	\N	Ayudante (plomero)	hr	2.5000	12.50	labor	2025-06-01 00:14:35.970149	2025-06-01 00:14:35.970149	\N	\N
2642	47	\N	Maestro plomero	hr	2.5000	17.50	labor	2025-06-01 00:14:35.987819	2025-06-01 00:14:35.987819	\N	\N
2643	48	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:36.361363	2025-06-01 00:14:36.361363	\N	\N
2644	48	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:36.401118	2025-06-01 00:14:36.401118	\N	\N
2645	48	\N	Grifería para tina	pza	1.0000	666.50	material	2025-06-01 00:14:36.436699	2025-06-01 00:14:36.436699	\N	\N
2646	48	\N	Ayudante (plomero)	hr	3.2000	12.50	labor	2025-06-01 00:14:36.453593	2025-06-01 00:14:36.453593	\N	\N
2647	48	\N	Maestro plomero	hr	3.2000	17.50	labor	2025-06-01 00:14:36.473089	2025-06-01 00:14:36.473089	\N	\N
2648	49	\N	Chicotillo plástico	pza	1.0000	20.00	material	2025-06-01 00:14:36.842585	2025-06-01 00:14:36.842585	\N	\N
2649	49	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:36.877957	2025-06-01 00:14:36.877957	\N	\N
2650	49	\N	Grifería urinario	jgo	1.0000	163.86	material	2025-06-01 00:14:36.921107	2025-06-01 00:14:36.921107	\N	\N
2651	49	\N	Ayudante (plomero)	hr	2.5000	12.50	labor	2025-06-01 00:14:36.93797	2025-06-01 00:14:36.93797	\N	\N
2652	49	\N	Maestro plomero	hr	2.5000	17.50	labor	2025-06-01 00:14:36.95606	2025-06-01 00:14:36.95606	\N	\N
2653	50	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:37.330214	2025-06-01 00:14:37.330214	\N	\N
2654	50	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:37.365751	2025-06-01 00:14:37.365751	\N	\N
2655	50	\N	Grifo móvil niquelado	pza	1.0000	238.00	material	2025-06-01 00:14:37.401545	2025-06-01 00:14:37.401545	\N	\N
2656	50	\N	Ayudante (plomero)	hr	2.5000	12.50	labor	2025-06-01 00:14:37.418568	2025-06-01 00:14:37.418568	\N	\N
2657	50	\N	Maestro plomero	hr	2.5000	17.50	labor	2025-06-01 00:14:37.435551	2025-06-01 00:14:37.435551	\N	\N
2658	51	\N	Chicotillo plástico	pza	1.0000	20.00	material	2025-06-01 00:14:37.806036	2025-06-01 00:14:37.806036	\N	\N
2659	51	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:37.841325	2025-06-01 00:14:37.841325	\N	\N
2660	51	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:37.877059	2025-06-01 00:14:37.877059	\N	\N
2661	51	\N	Inodoro de tanque bajo color blanco	pza	1.0000	1.00	material	2025-06-01 00:14:37.912475	2025-06-01 00:14:37.912475	\N	\N
2662	51	\N	Ayudante (plomero)	hr	3.4000	12.50	labor	2025-06-01 00:14:37.929716	2025-06-01 00:14:37.929716	\N	\N
2663	51	\N	Maestro plomero	hr	3.4000	17.50	labor	2025-06-01 00:14:37.947612	2025-06-01 00:14:37.947612	\N	\N
2664	52	\N	Chicotillo plástico	pza	1.0000	20.00	material	2025-06-01 00:14:38.380191	2025-06-01 00:14:38.380191	\N	\N
2665	52	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:38.41551	2025-06-01 00:14:38.41551	\N	\N
2666	52	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:38.451394	2025-06-01 00:14:38.451394	\N	\N
2667	52	\N	Inodoro de tanque bajo color blanco	pza	1.0000	1.00	material	2025-06-01 00:14:38.498955	2025-06-01 00:14:38.498955	\N	\N
2668	52	\N	Ayudante (plomero)	hr	3.4000	12.50	labor	2025-06-01 00:14:38.51931	2025-06-01 00:14:38.51931	\N	\N
2669	52	\N	Maestro plomero	hr	3.4000	17.50	labor	2025-06-01 00:14:38.537255	2025-06-01 00:14:38.537255	\N	\N
2670	53	\N	Chicotillo plástico	pza	1.0000	20.00	material	2025-06-01 00:14:38.99718	2025-06-01 00:14:38.99718	\N	\N
2671	53	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:39.033816	2025-06-01 00:14:39.033816	\N	\N
2672	53	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:39.070909	2025-06-01 00:14:39.070909	\N	\N
2673	53	\N	Inodoro de tanque alto	pza	1.0000	980.00	material	2025-06-01 00:14:39.106999	2025-06-01 00:14:39.106999	\N	\N
2674	53	\N	Ayudante (plomero)	hr	3.4000	12.50	labor	2025-06-01 00:14:39.125203	2025-06-01 00:14:39.125203	\N	\N
2675	53	\N	Maestro plomero	hr	3.4000	17.50	labor	2025-06-01 00:14:39.142319	2025-06-01 00:14:39.142319	\N	\N
2676	54	105	Cemento blanco	kg	0.2000	7.00	material	2025-06-01 00:14:39.654105	2025-06-01 00:14:39.654105	\N	\N
2677	54	\N	Jabonero	pza	1.0000	26.14	material	2025-06-01 00:14:39.695433	2025-06-01 00:14:39.695433	\N	\N
2678	54	\N	Ayudante	hr	1.5000	12.50	labor	2025-06-01 00:14:39.713373	2025-06-01 00:14:39.713373	\N	\N
2679	54	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:14:39.731478	2025-06-01 00:14:39.731478	\N	\N
2680	55	\N	Chicotillo plástico	pza	2.0000	20.00	material	2025-06-01 00:14:40.330166	2025-06-01 00:14:40.330166	\N	\N
2681	55	\N	Teflón 3/4 pulg	pza	1.0000	3.00	material	2025-06-01 00:14:40.365225	2025-06-01 00:14:40.365225	\N	\N
2682	55	105	Cemento blanco	kg	2.0000	7.00	material	2025-06-01 00:14:40.399345	2025-06-01 00:14:40.399345	\N	\N
2683	55	\N	Cemento portland IP-30	kg	5.0000	1.20	material	2025-06-01 00:14:40.434559	2025-06-01 00:14:40.434559	\N	\N
2684	55	\N	Inodoro de tanque bajo de color	pza	1.0000	2.00	material	2025-06-01 00:14:40.470441	2025-06-01 00:14:40.470441	\N	\N
2685	55	\N	Lavamanos de color con pedestal	pza	1.0000	480.00	material	2025-06-01 00:14:40.506735	2025-06-01 00:14:40.506735	\N	\N
2686	55	\N	Ayudante	hr	8.0000	12.50	labor	2025-06-01 00:14:40.523532	2025-06-01 00:14:40.523532	\N	\N
2687	55	\N	Ayudante (plomero)	hr	1.0000	12.50	labor	2025-06-01 00:14:40.540448	2025-06-01 00:14:40.540448	\N	\N
2688	55	\N	Maestro albañil	hr	8.0000	18.75	labor	2025-06-01 00:14:40.557387	2025-06-01 00:14:40.557387	\N	\N
2689	55	\N	Maestro plomero	hr	1.0000	17.50	labor	2025-06-01 00:14:40.574064	2025-06-01 00:14:40.574064	\N	\N
2690	56	\N	Chicotillo plástico	pza	1.0000	20.00	material	2025-06-01 00:14:41.045607	2025-06-01 00:14:41.045607	\N	\N
2691	56	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:41.081387	2025-06-01 00:14:41.081387	\N	\N
2692	56	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:41.116993	2025-06-01 00:14:41.116993	\N	\N
2693	56	105	Cemento blanco	kg	0.2000	7.00	material	2025-06-01 00:14:41.151237	2025-06-01 00:14:41.151237	\N	\N
2694	56	\N	Lavamanos blanco con pedestal	pza	1.0000	390.00	material	2025-06-01 00:14:41.187435	2025-06-01 00:14:41.187435	\N	\N
2695	56	\N	Ayudante (plomero)	hr	3.4000	12.50	labor	2025-06-01 00:14:41.204447	2025-06-01 00:14:41.204447	\N	\N
2696	56	\N	Maestro plomero	hr	3.4000	17.50	labor	2025-06-01 00:14:41.22192	2025-06-01 00:14:41.22192	\N	\N
2697	57	\N	Chicotillo plástico	pza	1.0000	20.00	material	2025-06-01 00:14:41.708688	2025-06-01 00:14:41.708688	\N	\N
2698	57	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:41.743386	2025-06-01 00:14:41.743386	\N	\N
2699	57	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:41.778506	2025-06-01 00:14:41.778506	\N	\N
2700	57	105	Cemento blanco	kg	0.1500	7.00	material	2025-06-01 00:14:41.812648	2025-06-01 00:14:41.812648	\N	\N
2701	57	\N	Lavamanos blanco sin pedestal	pza	1.0000	370.00	material	2025-06-01 00:14:41.846868	2025-06-01 00:14:41.846868	\N	\N
2702	57	\N	Ayudante (plomero)	hr	3.0000	12.50	labor	2025-06-01 00:14:41.863767	2025-06-01 00:14:41.863767	\N	\N
2703	57	\N	Maestro albañil	hr	0.8000	18.75	labor	2025-06-01 00:14:41.881063	2025-06-01 00:14:41.881063	\N	\N
2704	57	\N	Maestro plomero	hr	3.0000	17.50	labor	2025-06-01 00:14:41.898178	2025-06-01 00:14:41.898178	\N	\N
2705	58	\N	Chicotillo plástico	pza	1.0000	20.00	material	2025-06-01 00:14:42.303136	2025-06-01 00:14:42.303136	\N	\N
2706	58	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:42.339171	2025-06-01 00:14:42.339171	\N	\N
2707	58	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:42.374169	2025-06-01 00:14:42.374169	\N	\N
2708	58	\N	Lavamanos de color sin pedestal	pza	1.0000	420.00	material	2025-06-01 00:14:42.409382	2025-06-01 00:14:42.409382	\N	\N
2709	58	\N	Ayudante (plomero)	hr	3.4000	12.50	labor	2025-06-01 00:14:42.426523	2025-06-01 00:14:42.426523	\N	\N
2710	58	\N	Maestro plomero	hr	3.4000	17.50	labor	2025-06-01 00:14:42.443439	2025-06-01 00:14:42.443439	\N	\N
2711	59	\N	Chicotillo plástico	pza	1.0000	20.00	material	2025-06-01 00:14:42.915987	2025-06-01 00:14:42.915987	\N	\N
2712	59	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:42.951211	2025-06-01 00:14:42.951211	\N	\N
2713	59	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:42.98748	2025-06-01 00:14:42.98748	\N	\N
2714	59	\N	Lavamanos de color sin pedestal	pza	1.0000	420.00	material	2025-06-01 00:14:43.022829	2025-06-01 00:14:43.022829	\N	\N
2715	59	\N	Ayudante (plomero)	hr	3.0000	12.50	labor	2025-06-01 00:14:43.039776	2025-06-01 00:14:43.039776	\N	\N
2716	59	\N	Maestro albañil	hr	0.8000	18.75	labor	2025-06-01 00:14:43.056648	2025-06-01 00:14:43.056648	\N	\N
2717	59	\N	Maestro plomero	hr	3.0000	17.50	labor	2025-06-01 00:14:43.073353	2025-06-01 00:14:43.073353	\N	\N
2718	60	\N	Chicotillo plástico	pza	1.0000	20.00	material	2025-06-01 00:14:43.486876	2025-06-01 00:14:43.486876	\N	\N
2719	60	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:43.52152	2025-06-01 00:14:43.52152	\N	\N
2720	60	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:43.556401	2025-06-01 00:14:43.556401	\N	\N
2721	60	\N	Lavamanos de color para mesón	pza	1.0000	400.00	material	2025-06-01 00:14:43.592032	2025-06-01 00:14:43.592032	\N	\N
2722	60	\N	Silicona p/vidrio	tbo	0.1000	17.52	material	2025-06-01 00:14:43.626541	2025-06-01 00:14:43.626541	\N	\N
2723	60	\N	Ayudante (plomero)	hr	3.4000	12.50	labor	2025-06-01 00:14:43.643398	2025-06-01 00:14:43.643398	\N	\N
2724	60	\N	Maestro plomero	hr	3.4000	17.50	labor	2025-06-01 00:14:43.660454	2025-06-01 00:14:43.660454	\N	\N
2725	61	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:44.121079	2025-06-01 00:14:44.121079	\N	\N
2726	61	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:44.160699	2025-06-01 00:14:44.160699	\N	\N
2727	61	\N	Lavaplatos 1 bacha	pza	1.0000	250.00	material	2025-06-01 00:14:44.195687	2025-06-01 00:14:44.195687	\N	\N
2728	61	\N	Sifón para lavaplato simple	pza	1.0000	20.00	material	2025-06-01 00:14:44.24122	2025-06-01 00:14:44.24122	\N	\N
2729	61	\N	Ayudante (plomero)	hr	4.0000	12.50	labor	2025-06-01 00:14:44.258171	2025-06-01 00:14:44.258171	\N	\N
2730	61	\N	Maestro plomero	hr	4.0000	17.50	labor	2025-06-01 00:14:44.276863	2025-06-01 00:14:44.276863	\N	\N
2731	62	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:44.736735	2025-06-01 00:14:44.736735	\N	\N
2732	62	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:44.771333	2025-06-01 00:14:44.771333	\N	\N
2733	62	\N	Lavaplatos de 2 bachas	pza	1.0000	415.00	material	2025-06-01 00:14:44.806028	2025-06-01 00:14:44.806028	\N	\N
2734	62	\N	Sifón para lavaplato doble	pza	1.0000	27.50	material	2025-06-01 00:14:44.838768	2025-06-01 00:14:44.838768	\N	\N
2735	62	\N	Ayudante (plomero)	hr	4.0000	12.50	labor	2025-06-01 00:14:44.855619	2025-06-01 00:14:44.855619	\N	\N
2736	62	\N	Maestro plomero	hr	4.0000	17.50	labor	2025-06-01 00:14:44.872881	2025-06-01 00:14:44.872881	\N	\N
2737	63	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:45.299613	2025-06-01 00:14:45.299613	\N	\N
2738	63	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:45.334562	2025-06-01 00:14:45.334562	\N	\N
2739	63	\N	Lavaplatos 2 bachas 1 escurridero	pza	1.0000	318.15	material	2025-06-01 00:14:45.369968	2025-06-01 00:14:45.369968	\N	\N
2740	63	\N	Sifón para lavaplato doble	pza	1.0000	27.50	material	2025-06-01 00:14:45.405001	2025-06-01 00:14:45.405001	\N	\N
2741	63	\N	Ayudante (plomero)	hr	4.0000	12.50	labor	2025-06-01 00:14:45.420769	2025-06-01 00:14:45.420769	\N	\N
2742	63	\N	Maestro plomero	hr	4.0000	17.50	labor	2025-06-01 00:14:45.437727	2025-06-01 00:14:45.437727	\N	\N
2743	64	\N	Reducción de Fe 3/4x1/2 pulg	pza	1.0000	4.00	material	2025-06-01 00:14:45.827805	2025-06-01 00:14:45.827805	\N	\N
2744	64	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:45.863981	2025-06-01 00:14:45.863981	\N	\N
2745	64	\N	Lavaplatos 2 bachas 2 escurrideras	pza	1.0000	608.00	material	2025-06-01 00:14:45.901559	2025-06-01 00:14:45.901559	\N	\N
2746	64	\N	Sifón para lavaplato doble	pza	1.0000	27.50	material	2025-06-01 00:14:45.945815	2025-06-01 00:14:45.945815	\N	\N
2747	64	\N	Ayudante (plomero)	hr	4.0000	12.50	labor	2025-06-01 00:14:45.964735	2025-06-01 00:14:45.964735	\N	\N
2748	64	\N	Maestro plomero	hr	4.0000	17.50	labor	2025-06-01 00:14:45.981506	2025-06-01 00:14:45.981506	\N	\N
2749	65	\N	Cemento portland IP-30	kg	20.0000	1.20	material	2025-06-01 00:14:46.476103	2025-06-01 00:14:46.476103	\N	\N
2750	65	5	Arena Fina	m3	0.0500	70.00	material	2025-06-01 00:14:46.509677	2025-06-01 00:14:46.509677	\N	\N
2751	65	\N	Lavanderia de cemento	pza	1.0000	240.00	material	2025-06-01 00:14:46.544017	2025-06-01 00:14:46.544017	\N	\N
2752	65	\N	Ladrillo adobito	pza	58.0000	0.65	material	2025-06-01 00:14:46.578674	2025-06-01 00:14:46.578674	\N	\N
2753	65	22	Agua	lt	16.0000	0.06	material	2025-06-01 00:14:46.611768	2025-06-01 00:14:46.611768	\N	\N
2754	65	\N	Ayudante	hr	7.0000	12.50	labor	2025-06-01 00:14:46.628485	2025-06-01 00:14:46.628485	\N	\N
2755	65	\N	Maestro albañil	hr	7.0000	18.75	labor	2025-06-01 00:14:46.64571	2025-06-01 00:14:46.64571	\N	\N
2756	66	\N	Teflón 3/4 pulg	pza	0.1000	3.00	material	2025-06-01 00:14:47.062352	2025-06-01 00:14:47.062352	\N	\N
2757	66	\N	Cemento portland IP-30	kg	20.0000	1.20	material	2025-06-01 00:14:47.097658	2025-06-01 00:14:47.097658	\N	\N
2758	66	5	Arena Fina	m3	0.0500	70.00	material	2025-06-01 00:14:47.13066	2025-06-01 00:14:47.13066	\N	\N
2759	66	\N	Lavarropa de porcelana blanca	pza	1.0000	362.00	material	2025-06-01 00:14:47.165442	2025-06-01 00:14:47.165442	\N	\N
2760	66	\N	Ladrillo adobito	pza	58.0000	0.65	material	2025-06-01 00:14:47.200735	2025-06-01 00:14:47.200735	\N	\N
2761	66	22	Agua	lt	16.0000	0.06	material	2025-06-01 00:14:47.234457	2025-06-01 00:14:47.234457	\N	\N
2762	66	\N	Ayudante	hr	7.0000	12.50	labor	2025-06-01 00:14:47.251303	2025-06-01 00:14:47.251303	\N	\N
2763	66	\N	Maestro albañil	hr	7.0000	18.75	labor	2025-06-01 00:14:47.269344	2025-06-01 00:14:47.269344	\N	\N
2764	67	105	Cemento blanco	kg	0.2000	7.00	material	2025-06-01 00:14:47.653547	2025-06-01 00:14:47.653547	\N	\N
2765	67	\N	Papelero	pza	1.0000	36.00	material	2025-06-01 00:14:47.688773	2025-06-01 00:14:47.688773	\N	\N
2766	67	\N	Ayudante	hr	1.5000	12.50	labor	2025-06-01 00:14:47.708449	2025-06-01 00:14:47.708449	\N	\N
2767	67	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:14:47.725532	2025-06-01 00:14:47.725532	\N	\N
2768	68	105	Cemento blanco	kg	0.2000	7.00	material	2025-06-01 00:14:48.157596	2025-06-01 00:14:48.157596	\N	\N
2769	68	\N	Papelero	pza	1.0000	36.00	material	2025-06-01 00:14:48.19228	2025-06-01 00:14:48.19228	\N	\N
2770	68	\N	Ayudante	hr	1.5000	12.50	labor	2025-06-01 00:14:48.209138	2025-06-01 00:14:48.209138	\N	\N
2771	68	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:14:48.225935	2025-06-01 00:14:48.225935	\N	\N
2772	69	105	Cemento blanco	kg	0.2000	7.00	material	2025-06-01 00:14:48.650163	2025-06-01 00:14:48.650163	\N	\N
2773	69	\N	Toallero	pza	1.0000	27.36	material	2025-06-01 00:14:48.684547	2025-06-01 00:14:48.684547	\N	\N
2774	69	\N	Ayudante	hr	1.5000	12.50	labor	2025-06-01 00:14:48.70156	2025-06-01 00:14:48.70156	\N	\N
2775	69	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:14:48.718343	2025-06-01 00:14:48.718343	\N	\N
2776	70	105	Cemento blanco	kg	0.4000	7.00	material	2025-06-01 00:14:49.189773	2025-06-01 00:14:49.189773	\N	\N
2777	70	\N	Cemento portland IP-30	kg	5.0000	1.20	material	2025-06-01 00:14:49.225048	2025-06-01 00:14:49.225048	\N	\N
2778	70	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:14:49.258467	2025-06-01 00:14:49.258467	\N	\N
2779	70	\N	Receptáculo para ducha 80x80 de fibra de vidrio	pza	1.0000	850.00	material	2025-06-01 00:14:49.294505	2025-06-01 00:14:49.294505	\N	\N
2780	70	\N	Ayudante (plomero)	hr	3.0000	12.50	labor	2025-06-01 00:14:49.311537	2025-06-01 00:14:49.311537	\N	\N
2781	70	\N	Maestro albañil	hr	0.8000	18.75	labor	2025-06-01 00:14:49.328388	2025-06-01 00:14:49.328388	\N	\N
2782	70	\N	Maestro plomero	hr	3.0000	17.50	labor	2025-06-01 00:14:49.345242	2025-06-01 00:14:49.345242	\N	\N
2783	71	105	Cemento blanco	kg	0.4000	7.00	material	2025-06-01 00:14:49.8819	2025-06-01 00:14:49.8819	\N	\N
2784	71	\N	Cemento portland IP-30	kg	5.0000	1.20	material	2025-06-01 00:14:49.916234	2025-06-01 00:14:49.916234	\N	\N
2785	71	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:14:49.949603	2025-06-01 00:14:49.949603	\N	\N
2786	71	\N	Receptáculo para ducha 90x90 de fibra de vidrio	pza	1.0000	1.00	material	2025-06-01 00:14:49.985008	2025-06-01 00:14:49.985008	\N	\N
2787	71	\N	Ayudante (plomero)	hr	3.0000	12.50	labor	2025-06-01 00:14:50.000712	2025-06-01 00:14:50.000712	\N	\N
2788	71	\N	Maestro albañil	hr	0.8000	18.75	labor	2025-06-01 00:14:50.017217	2025-06-01 00:14:50.017217	\N	\N
2789	71	\N	Maestro plomero	hr	3.0000	17.50	labor	2025-06-01 00:14:50.033663	2025-06-01 00:14:50.033663	\N	\N
2790	72	\N	Tina de fibra de vidrio 1.60x0.95	pza	1.0000	1.00	material	2025-06-01 00:14:50.488414	2025-06-01 00:14:50.488414	\N	\N
2791	72	\N	Ayudante	hr	5.0000	12.50	labor	2025-06-01 00:14:50.505071	2025-06-01 00:14:50.505071	\N	\N
2792	72	\N	Ayudante (plomero)	hr	5.0000	12.50	labor	2025-06-01 00:14:50.582656	2025-06-01 00:14:50.582656	\N	\N
2793	72	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:14:50.599464	2025-06-01 00:14:50.599464	\N	\N
2794	72	\N	Maestro plomero	hr	5.0000	17.50	labor	2025-06-01 00:14:50.616294	2025-06-01 00:14:50.616294	\N	\N
2795	73	\N	Bañera de hidromasaje  D=2.30 con equipo completo	pza	1.0000	7.00	material	2025-06-01 00:14:51.11535	2025-06-01 00:14:51.11535	\N	\N
2796	73	\N	Ayudante	hr	5.0000	12.50	labor	2025-06-01 00:14:51.132079	2025-06-01 00:14:51.132079	\N	\N
2797	73	\N	Ayudante (plomero)	hr	5.0000	12.50	labor	2025-06-01 00:14:51.149055	2025-06-01 00:14:51.149055	\N	\N
2798	73	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:14:51.164775	2025-06-01 00:14:51.164775	\N	\N
2799	73	\N	Maestro plomero	hr	5.0000	17.50	labor	2025-06-01 00:14:51.181837	2025-06-01 00:14:51.181837	\N	\N
2800	74	105	Cemento blanco	kg	0.2000	7.00	material	2025-06-01 00:14:51.580558	2025-06-01 00:14:51.580558	\N	\N
2801	74	\N	Toallero	pza	1.0000	27.36	material	2025-06-01 00:14:51.62069	2025-06-01 00:14:51.62069	\N	\N
2802	74	\N	Ayudante	hr	1.5000	12.50	labor	2025-06-01 00:14:51.637708	2025-06-01 00:14:51.637708	\N	\N
2803	74	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:14:51.654645	2025-06-01 00:14:51.654645	\N	\N
2804	75	\N	Chicotillo plástico	pza	1.0000	20.00	material	2025-06-01 00:14:52.044154	2025-06-01 00:14:52.044154	\N	\N
2805	75	\N	Urinario blanco	pza	1.0000	395.20	material	2025-06-01 00:14:52.078734	2025-06-01 00:14:52.078734	\N	\N
2806	75	\N	Ayudante (plomero)	hr	3.4000	12.50	labor	2025-06-01 00:14:52.095611	2025-06-01 00:14:52.095611	\N	\N
2807	75	\N	Maestro plomero	hr	3.4000	17.50	labor	2025-06-01 00:14:52.112334	2025-06-01 00:14:52.112334	\N	\N
2808	76	\N	Cemento portland IP-30	kg	8.0000	1.20	material	2025-06-01 00:14:52.542482	2025-06-01 00:14:52.542482	\N	\N
2809	76	\N	Arenilla	m3	0.0500	100.00	material	2025-06-01 00:14:52.577834	2025-06-01 00:14:52.577834	\N	\N
2810	76	\N	Azulejo blanco de 15x15cm	m2	1.0000	35.00	material	2025-06-01 00:14:52.612126	2025-06-01 00:14:52.612126	\N	\N
2811	76	\N	Ladrillo adobito	pza	35.0000	0.65	material	2025-06-01 00:14:52.64695	2025-06-01 00:14:52.64695	\N	\N
2812	76	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:14:52.665424	2025-06-01 00:14:52.665424	\N	\N
2813	76	\N	Ayudante (plomero)	hr	1.0000	12.50	labor	2025-06-01 00:14:52.68241	2025-06-01 00:14:52.68241	\N	\N
2814	76	\N	Maestro albañil	hr	1.0000	18.75	labor	2025-06-01 00:14:52.704898	2025-06-01 00:14:52.704898	\N	\N
2815	76	\N	Maestro plomero	hr	1.0000	17.50	labor	2025-06-01 00:14:52.72637	2025-06-01 00:14:52.72637	\N	\N
2816	77	\N	Box de baño con aluminio y acrílico	m2	1.0000	418.00	material	2025-06-01 00:14:53.159929	2025-06-01 00:14:53.159929	\N	\N
2817	78	\N	Ventana de aluminio	m2	1.0000	350.00	material	2025-06-01 00:14:53.52549	2025-06-01 00:14:53.52549	\N	\N
2818	78	\N	Vidrio de 4mm	m2	1.0000	100.63	material	2025-06-01 00:14:53.561391	2025-06-01 00:14:53.561391	\N	\N
2819	79	\N	Ventana de aluminio basculante	m2	1.0000	364.80	material	2025-06-01 00:14:53.921364	2025-06-01 00:14:53.921364	\N	\N
2820	79	\N	Vidrio doble	p2	10.8000	8.00	material	2025-06-01 00:14:53.956137	2025-06-01 00:14:53.956137	\N	\N
2821	80	\N	Baranda de madera mara h=0.90	ml	1.0000	182.40	material	2025-06-01 00:14:54.415985	2025-06-01 00:14:54.415985	\N	\N
2822	80	\N	Ayudante (carpintero)	hr	4.0000	12.50	labor	2025-06-01 00:14:54.434062	2025-06-01 00:14:54.434062	\N	\N
2823	80	\N	Maestro carpintero	hr	4.0000	15.00	labor	2025-06-01 00:14:54.450963	2025-06-01 00:14:54.450963	\N	\N
2824	81	\N	Columna circular de madera labrada (8" 3.00m)	pza	1.0000	1.00	material	2025-06-01 00:14:54.95154	2025-06-01 00:14:54.95154	\N	\N
2825	81	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:14:54.968363	2025-06-01 00:14:54.968363	\N	\N
2826	81	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:14:54.984971	2025-06-01 00:14:54.984971	\N	\N
2827	82	\N	Columna de madera 10x10 plg. 3.00 m	pza	1.0000	1.00	material	2025-06-01 00:14:55.516398	2025-06-01 00:14:55.516398	\N	\N
2828	82	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:14:55.533328	2025-06-01 00:14:55.533328	\N	\N
2829	82	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:14:55.550283	2025-06-01 00:14:55.550283	\N	\N
2830	82	\N	Guinche	hr	0.5000	42.00	equipment	2025-06-01 00:14:55.567424	2025-06-01 00:14:55.567424	\N	\N
2831	83	\N	Columna de madera 6x6 pulg. 3.00 m	pza	1.0000	600.00	material	2025-06-01 00:14:56.011931	2025-06-01 00:14:56.011931	\N	\N
2832	83	\N	Ayudante (carpintero)	hr	1.8000	12.50	labor	2025-06-01 00:14:56.028923	2025-06-01 00:14:56.028923	\N	\N
2833	83	\N	Maestro carpintero	hr	0.9000	15.00	labor	2025-06-01 00:14:56.053251	2025-06-01 00:14:56.053251	\N	\N
2834	84	\N	Columna de madera 8x8 plg. 3.00 m	pza	1.0000	1.00	material	2025-06-01 00:14:56.473993	2025-06-01 00:14:56.473993	\N	\N
2835	84	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:14:56.491032	2025-06-01 00:14:56.491032	\N	\N
2836	84	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:14:56.507675	2025-06-01 00:14:56.507675	\N	\N
2837	84	\N	Guinche	hr	0.5000	42.00	equipment	2025-06-01 00:14:56.524588	2025-06-01 00:14:56.524588	\N	\N
2838	85	\N	Divisiones y cajonería de vestidor en melamínico	m2	1.0000	240.00	material	2025-06-01 00:14:56.882557	2025-06-01 00:14:56.882557	\N	\N
2839	86	\N	Escalera de madera	pza	1.0000	8.00	material	2025-06-01 00:14:57.248951	2025-06-01 00:14:57.248951	\N	\N
2840	86	\N	Ayudante (carpintero)	hr	40.0000	12.50	labor	2025-06-01 00:14:57.26574	2025-06-01 00:14:57.26574	\N	\N
2841	86	\N	Maestro carpintero	hr	40.0000	15.00	labor	2025-06-01 00:14:57.283286	2025-06-01 00:14:57.283286	\N	\N
2842	87	\N	Guia L	pza	2.0000	10.00	material	2025-06-01 00:14:57.664178	2025-06-01 00:14:57.664178	\N	\N
2843	87	\N	Jaladores	pza	1.0000	8.00	material	2025-06-01 00:14:57.698578	2025-06-01 00:14:57.698578	\N	\N
2844	87	\N	Picaporte	pza	1.0000	6.00	material	2025-06-01 00:14:57.733889	2025-06-01 00:14:57.733889	\N	\N
2845	87	\N	Rulemanes para ventanas	pza	1.6000	4.00	material	2025-06-01 00:14:57.769049	2025-06-01 00:14:57.769049	\N	\N
2846	87	\N	Vidrio doble	p2	11.1300	8.00	material	2025-06-01 00:14:57.804361	2025-06-01 00:14:57.804361	\N	\N
2847	87	\N	Ayudante (carpintero)	hr	6.8400	12.50	labor	2025-06-01 00:14:57.820923	2025-06-01 00:14:57.820923	\N	\N
2848	87	\N	Maestro carpintero	hr	6.8400	15.00	labor	2025-06-01 00:14:57.83746	2025-06-01 00:14:57.83746	\N	\N
2849	88	\N	Madera cuchi 7x7 4.5m	pza	1.0000	875.00	material	2025-06-01 00:14:58.303221	2025-06-01 00:14:58.303221	\N	\N
2850	88	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:14:58.320316	2025-06-01 00:14:58.320316	\N	\N
2851	88	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:14:58.33842	2025-06-01 00:14:58.33842	\N	\N
2852	89	\N	Peldaño de madera tajibo de 3x12pulg	ml	1.0100	72.96	material	2025-06-01 00:14:58.737874	2025-06-01 00:14:58.737874	\N	\N
2853	89	\N	Ayudante (carpintero)	hr	0.7000	12.50	labor	2025-06-01 00:14:58.755129	2025-06-01 00:14:58.755129	\N	\N
2854	89	\N	Maestro carpintero	hr	0.7000	15.00	labor	2025-06-01 00:14:58.772285	2025-06-01 00:14:58.772285	\N	\N
2855	90	\N	Machimbre tajibo	m2	1.0000	195.80	material	2025-06-01 00:14:59.137794	2025-06-01 00:14:59.137794	\N	\N
2856	90	\N	Maestro carpintero	hr	2.0000	15.00	labor	2025-06-01 00:14:59.155218	2025-06-01 00:14:59.155218	\N	\N
2857	91	\N	Machimbre tajibo	m2	1.0000	195.80	material	2025-06-01 00:14:59.514072	2025-06-01 00:14:59.514072	\N	\N
2858	91	\N	Maestro carpintero	hr	3.0000	15.00	labor	2025-06-01 00:14:59.530901	2025-06-01 00:14:59.530901	\N	\N
2859	92	\N	Madera de 2x4 pulg	p2	5.0000	18.00	material	2025-06-01 00:14:59.890084	2025-06-01 00:14:59.890084	\N	\N
2860	92	\N	Maestro carpintero	hr	2.0000	15.00	labor	2025-06-01 00:14:59.907133	2025-06-01 00:14:59.907133	\N	\N
2861	93	\N	Marco de 2x2 pulg	ml	1.0000	21.20	material	2025-06-01 00:15:00.272217	2025-06-01 00:15:00.272217	\N	\N
2862	93	\N	Malla milimétrica	m2	1.1000	2.92	material	2025-06-01 00:15:00.308104	2025-06-01 00:15:00.308104	\N	\N
2863	93	\N	Ayudante (carpintero)	hr	0.3000	12.50	labor	2025-06-01 00:15:00.32495	2025-06-01 00:15:00.32495	\N	\N
2864	93	\N	Maestro carpintero	hr	0.3000	15.00	labor	2025-06-01 00:15:00.341745	2025-06-01 00:15:00.341745	\N	\N
2865	94	\N	Marco de 2x4 mara	ml	1.1000	42.56	material	2025-06-01 00:15:00.727439	2025-06-01 00:15:00.727439	\N	\N
2866	94	110	Clavos de 4 pulg	kg	0.1000	20.00	material	2025-06-01 00:15:00.759812	2025-06-01 00:15:00.759812	\N	\N
2867	94	\N	Ayudante	hr	1.5000	12.50	labor	2025-06-01 00:15:00.777069	2025-06-01 00:15:00.777069	\N	\N
2868	94	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:15:00.793913	2025-06-01 00:15:00.793913	\N	\N
2869	95	\N	Marco de 2x4 tajibo	ml	1.1000	30.88	material	2025-06-01 00:15:01.18094	2025-06-01 00:15:01.18094	\N	\N
2870	95	110	Clavos de 4 pulg	kg	0.1000	20.00	material	2025-06-01 00:15:01.214794	2025-06-01 00:15:01.214794	\N	\N
2871	95	\N	Ayudante	hr	1.5000	12.50	labor	2025-06-01 00:15:01.232253	2025-06-01 00:15:01.232253	\N	\N
2872	95	\N	Maestro albañil	hr	1.5000	18.75	labor	2025-06-01 00:15:01.249037	2025-06-01 00:15:01.249037	\N	\N
2873	96	\N	Marco de 2x6 pulg	ml	1.1000	65.00	material	2025-06-01 00:15:01.651542	2025-06-01 00:15:01.651542	\N	\N
2874	96	110	Clavos de 4 pulg	kg	0.1000	20.00	material	2025-06-01 00:15:01.684748	2025-06-01 00:15:01.684748	\N	\N
2875	96	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:15:01.701622	2025-06-01 00:15:01.701622	\N	\N
2876	96	\N	Maestro albañil	hr	1.0000	18.75	labor	2025-06-01 00:15:01.718284	2025-06-01 00:15:01.718284	\N	\N
2877	97	\N	Mueble bajo mesón	ml	1.0000	684.25	material	2025-06-01 00:15:02.127183	2025-06-01 00:15:02.127183	\N	\N
2878	97	\N	Maestro carpintero	hr	2.0000	15.00	labor	2025-06-01 00:15:02.144217	2025-06-01 00:15:02.144217	\N	\N
2879	98	\N	Mueble de estanteria para cocina	m2	1.0000	684.25	material	2025-06-01 00:15:02.537129	2025-06-01 00:15:02.537129	\N	\N
2880	98	\N	Maestro carpintero	hr	2.0000	15.00	labor	2025-06-01 00:15:02.554001	2025-06-01 00:15:02.554001	\N	\N
2881	99	\N	Mueble bajo mesón	ml	1.0000	684.25	material	2025-06-01 00:15:02.914558	2025-06-01 00:15:02.914558	\N	\N
2882	99	\N	Maestro carpintero	hr	2.0000	15.00	labor	2025-06-01 00:15:02.931856	2025-06-01 00:15:02.931856	\N	\N
2883	100	\N	Tornillo de encarne de 1 1/2 pulg	pza	2.0000	1.22	material	2025-06-01 00:15:03.313386	2025-06-01 00:15:03.313386	\N	\N
2884	100	\N	Madera de tajibo cepillada	p2	4.5000	20.00	material	2025-06-01 00:15:03.35611	2025-06-01 00:15:03.35611	\N	\N
2885	100	\N	Tarugo plástico para tornillo de encarne	pza	2.0000	0.91	material	2025-06-01 00:15:03.392522	2025-06-01 00:15:03.392522	\N	\N
2886	100	\N	Ayudante (carpintero)	hr	4.0000	12.50	labor	2025-06-01 00:15:03.409618	2025-06-01 00:15:03.409618	\N	\N
2887	100	\N	Maestro carpintero	hr	4.0000	15.00	labor	2025-06-01 00:15:03.427248	2025-06-01 00:15:03.427248	\N	\N
2888	101	\N	Peldaño de madera tajibo de 2x12pulg	ml	1.0000	53.50	material	2025-06-01 00:15:03.800419	2025-06-01 00:15:03.800419	\N	\N
2889	101	\N	Ayudante (carpintero)	hr	0.7000	12.50	labor	2025-06-01 00:15:03.818872	2025-06-01 00:15:03.818872	\N	\N
2890	101	\N	Maestro carpintero	hr	0.7000	15.00	labor	2025-06-01 00:15:03.837233	2025-06-01 00:15:03.837233	\N	\N
2891	102	\N	Viga de 2x4 pulg	ml	1.2500	45.00	material	2025-06-01 00:15:04.281812	2025-06-01 00:15:04.281812	\N	\N
2892	102	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:15:04.298694	2025-06-01 00:15:04.298694	\N	\N
2893	102	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:15:04.315472	2025-06-01 00:15:04.315472	\N	\N
2894	103	\N	Machimbre tajibo	m2	1.0000	195.80	material	2025-06-01 00:15:04.686433	2025-06-01 00:15:04.686433	\N	\N
2895	103	\N	Viga de 3x6 pulg	ml	0.8000	100.00	material	2025-06-01 00:15:04.723181	2025-06-01 00:15:04.723181	\N	\N
2896	103	\N	Ayudante (carpintero)	hr	1.0000	12.50	labor	2025-06-01 00:15:04.741195	2025-06-01 00:15:04.741195	\N	\N
2897	103	\N	Maestro carpintero	hr	1.0000	15.00	labor	2025-06-01 00:15:04.758226	2025-06-01 00:15:04.758226	\N	\N
2898	104	\N	Portón de madera	m2	1.0000	573.05	material	2025-06-01 00:15:05.125815	2025-06-01 00:15:05.125815	\N	\N
2899	104	\N	Ayudante (carpintero)	hr	2.2600	12.50	labor	2025-06-01 00:15:05.142733	2025-06-01 00:15:05.142733	\N	\N
2900	104	\N	Maestro carpintero	hr	2.2600	15.00	labor	2025-06-01 00:15:05.159737	2025-06-01 00:15:05.159737	\N	\N
2901	105	\N	Puerta tablero de 2 pulg (Ingreso)	pza	1.0000	1.00	material	2025-06-01 00:15:05.522299	2025-06-01 00:15:05.522299	\N	\N
2902	105	\N	Bisagra de 4 pulg	pza	3.0000	25.00	material	2025-06-01 00:15:05.557435	2025-06-01 00:15:05.557435	\N	\N
2903	105	\N	Maestro carpintero	hr	8.0000	15.00	labor	2025-06-01 00:15:05.574477	2025-06-01 00:15:05.574477	\N	\N
2904	106	\N	Marco de 2x4 tajibo	ml	5.1000	30.88	material	2025-06-01 00:15:05.99226	2025-06-01 00:15:05.99226	\N	\N
2905	106	\N	Puerta tablero de 2 pulg	m2	1.8900	600.00	material	2025-06-01 00:15:06.029971	2025-06-01 00:15:06.029971	\N	\N
2906	106	110	Clavos de 4 pulg	kg	0.2000	20.00	material	2025-06-01 00:15:06.064226	2025-06-01 00:15:06.064226	\N	\N
2907	106	\N	Bisagra de Fe. de 4 pulg	pza	3.0000	25.00	material	2025-06-01 00:15:06.100038	2025-06-01 00:15:06.100038	\N	\N
2908	106	\N	Chapa para exteriores	pza	1.0000	410.75	material	2025-06-01 00:15:06.135379	2025-06-01 00:15:06.135379	\N	\N
2909	106	\N	Ayudante	hr	2.2000	12.50	labor	2025-06-01 00:15:06.152669	2025-06-01 00:15:06.152669	\N	\N
2910	106	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:15:06.169776	2025-06-01 00:15:06.169776	\N	\N
2911	106	\N	Maestro carpintero	hr	3.2000	15.00	labor	2025-06-01 00:15:06.187299	2025-06-01 00:15:06.187299	\N	\N
2912	107	\N	Puerta con vitral	m2	1.0000	231.04	material	2025-06-01 00:15:06.569436	2025-06-01 00:15:06.569436	\N	\N
2913	107	\N	Ayudante (carpintero)	hr	2.0000	12.50	labor	2025-06-01 00:15:06.586346	2025-06-01 00:15:06.586346	\N	\N
2914	107	\N	Maestro carpintero	hr	2.0000	15.00	labor	2025-06-01 00:15:06.603454	2025-06-01 00:15:06.603454	\N	\N
2915	108	\N	Puerta placa de 2 pulg  70 cm (interiores)	pza	1.0000	840.00	material	2025-06-01 00:15:06.968523	2025-06-01 00:15:06.968523	\N	\N
2916	108	\N	Bisagra de 4 pulg	pza	3.0000	25.00	material	2025-06-01 00:15:07.003098	2025-06-01 00:15:07.003098	\N	\N
2917	108	\N	Maestro carpintero	hr	8.0000	15.00	labor	2025-06-01 00:15:07.020329	2025-06-01 00:15:07.020329	\N	\N
2918	109	\N	Puerta placa de 2 pulg  80 cm (interiores)	pza	1.0000	900.00	material	2025-06-01 00:15:07.383388	2025-06-01 00:15:07.383388	\N	\N
2919	109	\N	Bisagra de 4 pulg	pza	3.0000	25.00	material	2025-06-01 00:15:07.418464	2025-06-01 00:15:07.418464	\N	\N
2920	109	\N	Maestro carpintero	hr	8.0000	15.00	labor	2025-06-01 00:15:07.435478	2025-06-01 00:15:07.435478	\N	\N
2921	110	\N	Puerta placa de 2 pulg  90 cm	pza	1.0000	940.00	material	2025-06-01 00:15:07.805269	2025-06-01 00:15:07.805269	\N	\N
2922	110	\N	Bisagra de 4 pulg	pza	3.0000	25.00	material	2025-06-01 00:15:07.839974	2025-06-01 00:15:07.839974	\N	\N
2923	110	\N	Maestro carpintero	hr	8.0000	15.00	labor	2025-06-01 00:15:07.857806	2025-06-01 00:15:07.857806	\N	\N
2924	111	\N	Puerta plegable de melamínico para ropero empotrado	m2	1.0000	322.00	material	2025-06-01 00:15:08.22705	2025-06-01 00:15:08.22705	\N	\N
2925	111	\N	Ayudante (carpintero)	hr	0.5000	12.50	labor	2025-06-01 00:15:08.249016	2025-06-01 00:15:08.249016	\N	\N
2926	111	\N	Maestro carpintero	hr	0.5000	15.00	labor	2025-06-01 00:15:08.266997	2025-06-01 00:15:08.266997	\N	\N
2927	112	\N	Ropero empotrado (con cajonería)	m2	1.0000	870.00	material	2025-06-01 00:15:08.64089	2025-06-01 00:15:08.64089	\N	\N
2928	112	\N	Maestro carpintero	hr	1.0000	15.00	labor	2025-06-01 00:15:08.657861	2025-06-01 00:15:08.657861	\N	\N
2929	113	\N	Ropero empotrado (sin cajonería)	m2	1.0000	320.00	material	2025-06-01 00:15:09.056794	2025-06-01 00:15:09.056794	\N	\N
2930	113	\N	Maestro carpintero	hr	1.0000	15.00	labor	2025-06-01 00:15:09.073867	2025-06-01 00:15:09.073867	\N	\N
2931	114	\N	Tapajunta de madera de 2 pulg cedro	ml	1.1000	10.08	material	2025-06-01 00:15:09.471486	2025-06-01 00:15:09.471486	\N	\N
2932	114	\N	Tornillo de encarne de 1 1/2 pulg	pza	2.0000	1.22	material	2025-06-01 00:15:09.506003	2025-06-01 00:15:09.506003	\N	\N
2933	114	\N	Tarugo plástico para tornillo de encarne	pza	0.6000	0.91	material	2025-06-01 00:15:09.54122	2025-06-01 00:15:09.54122	\N	\N
2934	114	\N	Ayudante (carpintero)	hr	0.2500	12.50	labor	2025-06-01 00:15:09.559545	2025-06-01 00:15:09.559545	\N	\N
2935	114	\N	Maestro carpintero	hr	0.2500	15.00	labor	2025-06-01 00:15:09.576725	2025-06-01 00:15:09.576725	\N	\N
2936	115	\N	Marco de 2x4 tajibo	ml	6.6000	30.88	material	2025-06-01 00:15:10.162104	2025-06-01 00:15:10.162104	\N	\N
2937	115	\N	Ventana sencilla	ml	9.0000	34.00	material	2025-06-01 00:15:10.198011	2025-06-01 00:15:10.198011	\N	\N
2938	115	110	Clavos de 4 pulg	kg	0.1500	20.00	material	2025-06-01 00:15:10.231474	2025-06-01 00:15:10.231474	\N	\N
2939	115	\N	Picaporte	pza	1.0000	6.00	material	2025-06-01 00:15:10.266129	2025-06-01 00:15:10.266129	\N	\N
2940	115	\N	Rieles de ventana	ml	2.1000	6.00	material	2025-06-01 00:15:10.30117	2025-06-01 00:15:10.30117	\N	\N
2941	115	\N	Rulemanes para ventanas	pza	2.0000	4.00	material	2025-06-01 00:15:10.336116	2025-06-01 00:15:10.336116	\N	\N
2942	115	\N	Vidrio doble	p2	6.9300	8.00	material	2025-06-01 00:15:10.372511	2025-06-01 00:15:10.372511	\N	\N
2943	115	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:15:10.389544	2025-06-01 00:15:10.389544	\N	\N
2944	115	\N	Maestro albañil	hr	0.6000	18.75	labor	2025-06-01 00:15:10.406426	2025-06-01 00:15:10.406426	\N	\N
2945	115	\N	Maestro carpintero	hr	3.2000	15.00	labor	2025-06-01 00:15:10.423465	2025-06-01 00:15:10.423465	\N	\N
2946	116	\N	Ventana sencilla	ml	1.0000	34.00	material	2025-06-01 00:15:10.925491	2025-06-01 00:15:10.925491	\N	\N
2947	116	\N	Ayudante (carpintero)	hr	2.0000	12.50	labor	2025-06-01 00:15:10.94242	2025-06-01 00:15:10.94242	\N	\N
2948	116	\N	Maestro carpintero	hr	2.0000	15.00	labor	2025-06-01 00:15:10.959394	2025-06-01 00:15:10.959394	\N	\N
2949	117	\N	Ventana sencilla	ml	1.0000	34.00	material	2025-06-01 00:15:11.335479	2025-06-01 00:15:11.335479	\N	\N
2950	117	\N	Bisagra de 3 pulg	pza	3.0000	12.00	material	2025-06-01 00:15:11.3704	2025-06-01 00:15:11.3704	\N	\N
2951	117	\N	Picaporte	pza	2.0000	6.00	material	2025-06-01 00:15:11.405252	2025-06-01 00:15:11.405252	\N	\N
2952	117	\N	Ayudante (carpintero)	hr	1.5000	12.50	labor	2025-06-01 00:15:11.42239	2025-06-01 00:15:11.42239	\N	\N
2953	117	\N	Maestro carpintero	hr	1.5000	15.00	labor	2025-06-01 00:15:11.439247	2025-06-01 00:15:11.439247	\N	\N
2954	118	\N	Ventana sencilla	ml	1.0000	34.00	material	2025-06-01 00:15:11.801339	2025-06-01 00:15:11.801339	\N	\N
2955	118	\N	Jaladores	pza	1.0000	8.00	material	2025-06-01 00:15:11.835875	2025-06-01 00:15:11.835875	\N	\N
2956	118	\N	Picaporte	pza	1.0000	6.00	material	2025-06-01 00:15:11.869802	2025-06-01 00:15:11.869802	\N	\N
2957	118	\N	Vidrio doble	p2	11.1300	8.00	material	2025-06-01 00:15:11.905109	2025-06-01 00:15:11.905109	\N	\N
2958	118	\N	Maestro carpintero	hr	2.0000	15.00	labor	2025-06-01 00:15:11.922201	2025-06-01 00:15:11.922201	\N	\N
2959	119	\N	Madera 3x7 tajibo cepillada	ml	1.0000	100.00	material	2025-06-01 00:15:12.340527	2025-06-01 00:15:12.340527	\N	\N
2960	119	\N	Ayudante	hr	0.4000	12.50	labor	2025-06-01 00:15:12.357585	2025-06-01 00:15:12.357585	\N	\N
2961	119	\N	Maestro albañil	hr	0.4000	18.75	labor	2025-06-01 00:15:12.374519	2025-06-01 00:15:12.374519	\N	\N
2962	120	\N	Madera 3x8 tajibo cepillada	ml	1.0000	135.00	material	2025-06-01 00:15:12.757569	2025-06-01 00:15:12.757569	\N	\N
2963	120	\N	Ayudante	hr	0.4000	12.50	labor	2025-06-01 00:15:12.77464	2025-06-01 00:15:12.77464	\N	\N
2964	120	\N	Maestro albañil	hr	0.4000	18.75	labor	2025-06-01 00:15:12.794582	2025-06-01 00:15:12.794582	\N	\N
2965	121	\N	Ayudante	hr	0.4000	12.50	labor	2025-06-01 00:15:13.199337	2025-06-01 00:15:13.199337	\N	\N
2966	121	\N	Maestro albañil	hr	0.4000	18.75	labor	2025-06-01 00:15:13.220079	2025-06-01 00:15:13.220079	\N	\N
2967	122	\N	Madera 6x6 tajibo cepillada	ml	1.0000	200.00	material	2025-06-01 00:15:13.657471	2025-06-01 00:15:13.657471	\N	\N
2968	122	\N	Ayudante	hr	0.2500	12.50	labor	2025-06-01 00:15:13.674583	2025-06-01 00:15:13.674583	\N	\N
2969	122	\N	Maestro albañil	hr	0.2500	18.75	labor	2025-06-01 00:15:13.69201	2025-06-01 00:15:13.69201	\N	\N
2970	123	\N	Madera tajibo	p2	13.3300	20.00	material	2025-06-01 00:15:14.138201	2025-06-01 00:15:14.138201	\N	\N
2971	123	\N	Ayudante	hr	0.2500	12.50	labor	2025-06-01 00:15:14.156163	2025-06-01 00:15:14.156163	\N	\N
2972	123	\N	Maestro albañil	hr	0.2500	18.75	labor	2025-06-01 00:15:14.172905	2025-06-01 00:15:14.172905	\N	\N
2973	124	\N	Madera 8x8 tajibo cepillada	ml	1.0000	360.00	material	2025-06-01 00:15:14.611326	2025-06-01 00:15:14.611326	\N	\N
2974	124	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:15:14.628142	2025-06-01 00:15:14.628142	\N	\N
2975	124	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:15:14.645115	2025-06-01 00:15:14.645115	\N	\N
2976	124	\N	Maestro carpintero	hr	8.0000	15.00	labor	2025-06-01 00:15:14.662405	2025-06-01 00:15:14.662405	\N	\N
2977	125	\N	Baranda de tubo metálico h=90cm	ml	1.0000	354.20	material	2025-06-01 00:15:15.138511	2025-06-01 00:15:15.138511	\N	\N
2978	125	\N	Maestro cerrajero	hr	1.0000	18.75	labor	2025-06-01 00:15:15.155579	2025-06-01 00:15:15.155579	\N	\N
2979	126	\N	Fierro redondo de 3/4	ml	1.0500	41.00	material	2025-06-01 00:15:15.721995	2025-06-01 00:15:15.721995	\N	\N
2980	126	\N	Ayudante	hr	0.3000	12.50	labor	2025-06-01 00:15:15.739212	2025-06-01 00:15:15.739212	\N	\N
2981	126	\N	Maestro albañil	hr	0.3000	18.75	labor	2025-06-01 00:15:15.756541	2025-06-01 00:15:15.756541	\N	\N
2982	127	\N	Churrasquera	pza	1.0000	949.90	material	2025-06-01 00:15:16.112245	2025-06-01 00:15:16.112245	\N	\N
2983	128	\N	Escalera caracol metálica con peldaños de madera H=2.6 R=0.8	pza	1.0000	2.00	material	2025-06-01 00:15:16.463849	2025-06-01 00:15:16.463849	\N	\N
2984	129	\N	Cemento portland IP-30	kg	5.0000	1.20	material	2025-06-01 00:15:16.883166	2025-06-01 00:15:16.883166	\N	\N
2985	129	\N	Arenilla	m3	0.0300	100.00	material	2025-06-01 00:15:16.91792	2025-06-01 00:15:16.91792	\N	\N
2986	129	\N	Escalera marinera de acero inoxidable 3 m	pza	1.0000	850.00	material	2025-06-01 00:15:16.951941	2025-06-01 00:15:16.951941	\N	\N
2987	129	\N	Ayudante	hr	5.5000	12.50	labor	2025-06-01 00:15:16.968786	2025-06-01 00:15:16.968786	\N	\N
2988	129	\N	Maestro albañil	hr	5.5000	18.75	labor	2025-06-01 00:15:16.986897	2025-06-01 00:15:16.986897	\N	\N
2989	130	\N	Parrilla para churrasquera	pza	1.0000	949.90	material	2025-06-01 00:15:17.344544	2025-06-01 00:15:17.344544	\N	\N
2990	131	\N	Cemento portland IP-30	kg	4.0000	1.20	material	2025-06-01 00:15:17.821515	2025-06-01 00:15:17.821515	\N	\N
2991	131	\N	Arenilla	m3	0.0100	100.00	material	2025-06-01 00:15:17.857687	2025-06-01 00:15:17.857687	\N	\N
2992	131	\N	Reja de protección de fierro	m2	1.0000	402.50	material	2025-06-01 00:15:17.894744	2025-06-01 00:15:17.894744	\N	\N
2993	131	\N	Ayudante	hr	0.8000	12.50	labor	2025-06-01 00:15:17.911429	2025-06-01 00:15:17.911429	\N	\N
2994	131	\N	Maestro albañil	hr	0.8000	18.75	labor	2025-06-01 00:15:17.928295	2025-06-01 00:15:17.928295	\N	\N
2995	132	\N	Puerta metalica arrollable	m2	1.0000	420.00	material	2025-06-01 00:15:18.310189	2025-06-01 00:15:18.310189	\N	\N
2996	132	\N	Ayudante (cerrajero)	hr	1.0000	100.00	labor	2025-06-01 00:15:18.328632	2025-06-01 00:15:18.328632	\N	\N
2997	132	\N	Maestro cerrajero	hr	1.0000	18.75	labor	2025-06-01 00:15:18.346351	2025-06-01 00:15:18.346351	\N	\N
2998	133	\N	Reja de protección de fierro	m2	2.0000	402.50	material	2025-06-01 00:15:18.730149	2025-06-01 00:15:18.730149	\N	\N
2999	133	\N	Chapa para exteriores	pza	1.0000	410.75	material	2025-06-01 00:15:18.765379	2025-06-01 00:15:18.765379	\N	\N
3000	133	\N	Ayudante (cerrajero)	hr	0.3000	100.00	labor	2025-06-01 00:15:18.782356	2025-06-01 00:15:18.782356	\N	\N
3001	133	\N	Maestro cerrajero	hr	0.3000	18.75	labor	2025-06-01 00:15:18.799733	2025-06-01 00:15:18.799733	\N	\N
3002	134	\N	Fierro redondo de 1/2	ml	7.0000	9.60	material	2025-06-01 00:15:19.244225	2025-06-01 00:15:19.244225	\N	\N
3003	134	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:15:19.279381	2025-06-01 00:15:19.279381	\N	\N
3004	134	\N	Arenilla	m3	0.0100	100.00	material	2025-06-01 00:15:19.314502	2025-06-01 00:15:19.314502	\N	\N
3005	134	\N	Ayudante	hr	0.3000	12.50	labor	2025-06-01 00:15:19.331524	2025-06-01 00:15:19.331524	\N	\N
3006	134	\N	Maestro albañil	hr	0.3000	18.75	labor	2025-06-01 00:15:19.348607	2025-06-01 00:15:19.348607	\N	\N
3007	135	\N	Reja de protección de fierro angular	m2	1.0000	380.00	material	2025-06-01 00:15:19.748853	2025-06-01 00:15:19.748853	\N	\N
3008	135	\N	Ayudante	hr	0.3000	12.50	labor	2025-06-01 00:15:19.766131	2025-06-01 00:15:19.766131	\N	\N
3009	135	\N	Maestro albañil	hr	0.3000	18.75	labor	2025-06-01 00:15:19.783327	2025-06-01 00:15:19.783327	\N	\N
3010	136	\N	Cemento portland IP-30	kg	10.0000	1.20	material	2025-06-01 00:15:20.224477	2025-06-01 00:15:20.224477	\N	\N
3011	136	\N	Arenilla	m3	0.1000	100.00	material	2025-06-01 00:15:20.259845	2025-06-01 00:15:20.259845	\N	\N
3012	136	\N	Ripio chancado	m3	0.2000	230.00	material	2025-06-01 00:15:20.294761	2025-06-01 00:15:20.294761	\N	\N
3013	136	\N	Verja metálica de tubo cuadrado	m2	1.0000	420.00	material	2025-06-01 00:15:20.32958	2025-06-01 00:15:20.32958	\N	\N
3014	136	\N	Ayudante	hr	8.0000	12.50	labor	2025-06-01 00:15:20.346315	2025-06-01 00:15:20.346315	\N	\N
3015	136	\N	Maestro albañil	hr	4.0000	18.75	labor	2025-06-01 00:15:20.363083	2025-06-01 00:15:20.363083	\N	\N
3016	137	\N	Malla olímpica #10	m2	1.0000	60.00	material	2025-06-01 00:15:20.800652	2025-06-01 00:15:20.800652	\N	\N
3017	137	\N	Maestro cerrajero	hr	0.2000	18.75	labor	2025-06-01 00:15:20.817753	2025-06-01 00:15:20.817753	\N	\N
3018	138	\N	Malla olímpica #14 3/4"	m2	1.0000	63.00	material	2025-06-01 00:15:21.184646	2025-06-01 00:15:21.184646	\N	\N
3019	138	\N	Maestro cerrajero	hr	0.2000	18.75	labor	2025-06-01 00:15:21.201306	2025-06-01 00:15:21.201306	\N	\N
3020	139	\N	Malla olímpica #16 1/2"	m2	1.0000	74.00	material	2025-06-01 00:15:21.558611	2025-06-01 00:15:21.558611	\N	\N
3021	139	\N	Maestro cerrajero	hr	0.2000	18.75	labor	2025-06-01 00:15:21.575854	2025-06-01 00:15:21.575854	\N	\N
3022	140	\N	Cemento portland IP-30	kg	12.0000	1.20	material	2025-06-01 00:15:21.988006	2025-06-01 00:15:21.988006	\N	\N
3023	140	\N	Piedra bola	m3	0.0300	192.00	material	2025-06-01 00:15:22.022673	2025-06-01 00:15:22.022673	\N	\N
3024	140	\N	Ripio bruto	m3	0.0500	180.00	material	2025-06-01 00:15:22.057177	2025-06-01 00:15:22.057177	\N	\N
3025	140	\N	Poste prefabricado de hormigón L=3.00	pza	1.0000	75.00	material	2025-06-01 00:15:22.092546	2025-06-01 00:15:22.092546	\N	\N
3026	140	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:15:22.109254	2025-06-01 00:15:22.109254	\N	\N
3027	140	\N	Maestro albañil	hr	0.7500	18.75	labor	2025-06-01 00:15:22.125969	2025-06-01 00:15:22.125969	\N	\N
3028	141	\N	Madera cuchi 4x4 plg. 3.0m	pza	1.0000	200.00	material	2025-06-01 00:15:22.51631	2025-06-01 00:15:22.51631	\N	\N
3029	141	\N	Ayudante	hr	0.5000	12.50	labor	2025-06-01 00:15:22.533008	2025-06-01 00:15:22.533008	\N	\N
3030	141	\N	Maestro albañil	hr	0.2000	18.75	labor	2025-06-01 00:15:22.551241	2025-06-01 00:15:22.551241	\N	\N
3031	142	\N	Cemento portland IP-30	kg	12.0000	1.20	material	2025-06-01 00:15:22.960752	2025-06-01 00:15:22.960752	\N	\N
3032	142	\N	Piedra bola	m3	0.0300	192.00	material	2025-06-01 00:15:22.995002	2025-06-01 00:15:22.995002	\N	\N
3033	142	\N	Ripio bruto	m3	0.0500	180.00	material	2025-06-01 00:15:23.029713	2025-06-01 00:15:23.029713	\N	\N
3034	142	\N	Tubería de FoGo 2 plg	ml	3.0000	55.94	material	2025-06-01 00:15:23.064661	2025-06-01 00:15:23.064661	\N	\N
3035	142	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:15:23.082008	2025-06-01 00:15:23.082008	\N	\N
3036	142	\N	Maestro albañil	hr	0.7500	18.75	labor	2025-06-01 00:15:23.10419	2025-06-01 00:15:23.10419	\N	\N
3037	143	\N	Cemento portland IP-30	kg	12.0000	1.20	material	2025-06-01 00:15:23.518444	2025-06-01 00:15:23.518444	\N	\N
3038	143	\N	Piedra bola	m3	0.0300	192.00	material	2025-06-01 00:15:23.555241	2025-06-01 00:15:23.555241	\N	\N
3039	143	\N	Ripio bruto	m3	0.0500	180.00	material	2025-06-01 00:15:23.590343	2025-06-01 00:15:23.590343	\N	\N
3040	143	\N	Tubería de FoGo 3 plg	ml	3.0000	55.94	material	2025-06-01 00:15:23.625274	2025-06-01 00:15:23.625274	\N	\N
3041	143	\N	Ayudante	hr	1.0000	12.50	labor	2025-06-01 00:15:23.642808	2025-06-01 00:15:23.642808	\N	\N
3042	143	\N	Maestro albañil	hr	0.7500	18.75	labor	2025-06-01 00:15:23.660525	2025-06-01 00:15:23.660525	\N	\N
3043	144	\N	Fierro angular de 3/4 x 1/8	ml	0.6000	8.30	material	2025-06-01 00:15:24.036404	2025-06-01 00:15:24.036404	\N	\N
3044	144	\N	Alambre de púas	ml	3.0000	0.42	material	2025-06-01 00:15:24.071549	2025-06-01 00:15:24.071549	\N	\N
3045	144	\N	Ayudante (cerrajero)	hr	0.3000	100.00	labor	2025-06-01 00:15:24.089057	2025-06-01 00:15:24.089057	\N	\N
3046	144	\N	Maestro cerrajero	hr	0.3000	18.75	labor	2025-06-01 00:15:24.106495	2025-06-01 00:15:24.106495	\N	\N
3047	145	\N	Tubín cuadrado 20mm 20mm	ml	7.5000	24.00	material	2025-06-01 00:15:24.501662	2025-06-01 00:15:24.501662	\N	\N
3048	145	\N	Ayudante (cerrajero)	hr	1.0000	100.00	labor	2025-06-01 00:15:24.518832	2025-06-01 00:15:24.518832	\N	\N
3049	145	\N	Maestro cerrajero	hr	1.0000	18.75	labor	2025-06-01 00:15:24.535908	2025-06-01 00:15:24.535908	\N	\N
3050	146	\N	Tubín cuadrado 50mm 30mm	ml	7.5000	36.00	material	2025-06-01 00:15:24.906637	2025-06-01 00:15:24.906637	\N	\N
3051	146	\N	Ayudante (cerrajero)	hr	1.0000	100.00	labor	2025-06-01 00:15:24.923435	2025-06-01 00:15:24.923435	\N	\N
3052	146	\N	Maestro cerrajero	hr	1.0000	18.75	labor	2025-06-01 00:15:24.94021	2025-06-01 00:15:24.94021	\N	\N
3053	147	\N	Reja de protección de fierro	m2	1.0000	402.50	material	2025-06-01 00:15:25.331193	2025-06-01 00:15:25.331193	\N	\N
3054	147	\N	Ayudante (cerrajero)	hr	0.4000	100.00	labor	2025-06-01 00:15:25.348274	2025-06-01 00:15:25.348274	\N	\N
3055	147	\N	Maestro cerrajero	hr	0.4000	18.75	labor	2025-06-01 00:15:25.365324	2025-06-01 00:15:25.365324	\N	\N
3056	148	24	Clavos de 3 pulg	kg	0.5000	13.00	material	2025-06-01 00:15:25.812024	2025-06-01 00:15:25.812024	\N	\N
3057	148	\N	Madera de 2x4 almendrillo	p2	9.0000	20.00	material	2025-06-01 00:15:25.847272	2025-06-01 00:15:25.847272	\N	\N
3058	148	\N	Ayudante (carpintero)	hr	0.2000	12.50	labor	2025-06-01 00:15:25.864359	2025-06-01 00:15:25.864359	\N	\N
3059	148	\N	Maestro carpintero	hr	0.2000	15.00	labor	2025-06-01 00:15:25.881768	2025-06-01 00:15:25.881768	\N	\N
3060	149	24	Clavos de 3 pulg	kg	0.5000	13.00	material	2025-06-01 00:15:26.25401	2025-06-01 00:15:26.25401	\N	\N
3061	149	\N	Madera de 2x5 almendrillo	p2	12.0000	20.00	material	2025-06-01 00:15:26.292783	2025-06-01 00:15:26.292783	\N	\N
3062	149	\N	Ayudante (carpintero)	hr	0.2000	12.50	labor	2025-06-01 00:15:26.309904	2025-06-01 00:15:26.309904	\N	\N
3063	149	\N	Maestro carpintero	hr	0.2000	15.00	labor	2025-06-01 00:15:26.32711	2025-06-01 00:15:26.32711	\N	\N
3064	150	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:15:26.761519	2025-06-01 00:15:26.761519	\N	\N
3065	150	\N	Estuco	kg	24.0000	0.75	material	2025-06-01 00:15:26.798447	2025-06-01 00:15:26.798447	\N	\N
3066	150	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:15:26.831789	2025-06-01 00:15:26.831789	\N	\N
3067	150	\N	Clavos de 1 1/2 pulg	kg	0.0800	13.00	material	2025-06-01 00:15:26.865751	2025-06-01 00:15:26.865751	\N	\N
3068	150	\N	Clavos de 2 1/2 pulg	kg	0.0800	13.00	material	2025-06-01 00:15:26.900397	2025-06-01 00:15:26.900397	\N	\N
3069	150	\N	Paja para plafoneado	m2	1.1000	3.50	material	2025-06-01 00:15:26.935715	2025-06-01 00:15:26.935715	\N	\N
3070	150	\N	Listón de 2x2 pulg	ml	5.0000	12.00	material	2025-06-01 00:15:26.970237	2025-06-01 00:15:26.970237	\N	\N
3071	150	\N	Malla gallinera	m2	1.1000	3.50	material	2025-06-01 00:15:27.004779	2025-06-01 00:15:27.004779	\N	\N
3072	150	22	Agua	lt	3.2000	0.06	material	2025-06-01 00:15:27.038187	2025-06-01 00:15:27.038187	\N	\N
3073	150	\N	Ayudante	hr	1.9000	12.50	labor	2025-06-01 00:15:27.056693	2025-06-01 00:15:27.056693	\N	\N
3074	150	\N	Maestro albañil	hr	1.9000	18.75	labor	2025-06-01 00:15:27.073947	2025-06-01 00:15:27.073947	\N	\N
3075	151	\N	Cielo falso de yeso aprensado	m2	1.1000	150.00	material	2025-06-01 00:15:27.436459	2025-06-01 00:15:27.436459	\N	\N
3076	151	\N	Colocador de cielo falso	hr	0.2000	15.00	labor	2025-06-01 00:15:27.456877	2025-06-01 00:15:27.456877	\N	\N
3077	152	\N	Cielo falso de plastoform con perfiles de aluminio	m2	1.0500	175.00	material	2025-06-01 00:15:27.814993	2025-06-01 00:15:27.814993	\N	\N
3078	152	\N	Colocador de cielo falso	hr	0.7500	15.00	labor	2025-06-01 00:15:27.831919	2025-06-01 00:15:27.831919	\N	\N
3079	153	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:15:28.386602	2025-06-01 00:15:28.386602	\N	\N
3080	153	\N	Estuco	kg	24.0000	0.75	material	2025-06-01 00:15:28.421438	2025-06-01 00:15:28.421438	\N	\N
3081	153	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:15:28.45468	2025-06-01 00:15:28.45468	\N	\N
3082	153	\N	Clavos de 1 1/2 pulg	kg	0.0800	13.00	material	2025-06-01 00:15:28.490025	2025-06-01 00:15:28.490025	\N	\N
3083	153	\N	Clavos de 2 1/2 pulg	kg	0.0800	13.00	material	2025-06-01 00:15:28.524591	2025-06-01 00:15:28.524591	\N	\N
3084	153	\N	Paja para plafoneado	m2	1.1000	3.50	material	2025-06-01 00:15:28.55891	2025-06-01 00:15:28.55891	\N	\N
3085	153	\N	Listón de 2x2 pulg	ml	5.0000	12.00	material	2025-06-01 00:15:28.59365	2025-06-01 00:15:28.59365	\N	\N
3086	153	\N	Malla gallinera	m2	1.1000	3.50	material	2025-06-01 00:15:28.628171	2025-06-01 00:15:28.628171	\N	\N
3087	153	22	Agua	lt	3.2000	0.06	material	2025-06-01 00:15:28.661652	2025-06-01 00:15:28.661652	\N	\N
3088	153	\N	Ayudante	hr	1.9000	12.50	labor	2025-06-01 00:15:28.678608	2025-06-01 00:15:28.678608	\N	\N
3089	153	\N	Maestro albañil	hr	1.9000	18.75	labor	2025-06-01 00:15:28.696009	2025-06-01 00:15:28.696009	\N	\N
3090	154	\N	Cemento portland IP-30	kg	6.5000	1.20	material	2025-06-01 00:15:29.111186	2025-06-01 00:15:29.111186	\N	\N
3091	154	\N	Estuco	kg	17.5000	0.75	material	2025-06-01 00:15:29.145734	2025-06-01 00:15:29.145734	\N	\N
3092	154	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:15:29.178976	2025-06-01 00:15:29.178976	\N	\N
3093	154	22	Agua	lt	4.2000	0.06	material	2025-06-01 00:15:29.213043	2025-06-01 00:15:29.213043	\N	\N
3094	154	\N	Ayudante	hr	1.1000	12.50	labor	2025-06-01 00:15:29.228794	2025-06-01 00:15:29.228794	\N	\N
3095	154	\N	Maestro albañil	hr	1.1000	18.75	labor	2025-06-01 00:15:29.246026	2025-06-01 00:15:29.246026	\N	\N
3096	155	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:15:29.68684	2025-06-01 00:15:29.68684	\N	\N
3097	155	\N	Estuco	kg	24.0000	0.75	material	2025-06-01 00:15:29.723091	2025-06-01 00:15:29.723091	\N	\N
3098	155	5	Arena Fina	m3	0.0300	70.00	material	2025-06-01 00:15:29.756247	2025-06-01 00:15:29.756247	\N	\N
3099	155	\N	Clavos de 1 1/2 pulg	kg	0.0900	13.00	material	2025-06-01 00:15:29.790775	2025-06-01 00:15:29.790775	\N	\N
3100	155	\N	Paja para plafoneado	m2	1.1000	3.50	material	2025-06-01 00:15:29.825945	2025-06-01 00:15:29.825945	\N	\N
3101	155	\N	Malla gallinera	m2	1.1000	3.50	material	2025-06-01 00:15:29.859589	2025-06-01 00:15:29.859589	\N	\N
3102	155	22	Agua	lt	3.2000	0.06	material	2025-06-01 00:15:29.893865	2025-06-01 00:15:29.893865	\N	\N
3103	155	\N	Ayudante	hr	1.4000	12.50	labor	2025-06-01 00:15:29.911173	2025-06-01 00:15:29.911173	\N	\N
3104	155	\N	Maestro albañil	hr	1.4000	18.75	labor	2025-06-01 00:15:29.92669	2025-06-01 00:15:29.92669	\N	\N
3105	156	24	Clavos de 3 pulg	kg	0.5000	13.00	material	2025-06-01 00:15:30.339557	2025-06-01 00:15:30.339557	\N	\N
3106	156	\N	Cumbrera Duralit Española	ml	0.0100	37.14	material	2025-06-01 00:15:30.374225	2025-06-01 00:15:30.374225	\N	\N
3107	156	\N	Teja Duralit Española 1.60x1.05	pza	0.8000	90.50	material	2025-06-01 00:15:30.408892	2025-06-01 00:15:30.408892	\N	\N
3108	156	\N	Listón de 2x2 pulg	ml	2.0000	12.00	material	2025-06-01 00:15:30.443559	2025-06-01 00:15:30.443559	\N	\N
3109	156	\N	Viga de 2x4 pulg	ml	3.1700	45.00	material	2025-06-01 00:15:30.478006	2025-06-01 00:15:30.478006	\N	\N
3110	156	\N	Ayudante	hr	3.0000	12.50	labor	2025-06-01 00:15:30.494709	2025-06-01 00:15:30.494709	\N	\N
3111	156	\N	Maestro albañil	hr	3.0000	18.75	labor	2025-06-01 00:15:30.511652	2025-06-01 00:15:30.511652	\N	\N
3112	157	\N	Calamina ondulada No28 1.00x2.00	pza	0.6200	52.53	material	2025-06-01 00:15:30.900358	2025-06-01 00:15:30.900358	\N	\N
3113	157	24	Clavos de 3 pulg	kg	0.5000	13.00	material	2025-06-01 00:15:30.93519	2025-06-01 00:15:30.93519	\N	\N
3114	157	\N	Clavos de calamina	kg	0.0200	12.00	material	2025-06-01 00:15:30.9711	2025-06-01 00:15:30.9711	\N	\N
3115	157	\N	Listón de 2x2 pulg	ml	2.0000	12.00	material	2025-06-01 00:15:31.006315	2025-06-01 00:15:31.006315	\N	\N
3116	157	\N	Ayudante	hr	2.0000	12.50	labor	2025-06-01 00:15:31.023527	2025-06-01 00:15:31.023527	\N	\N
3117	157	\N	Maestro albañil	hr	2.0000	18.75	labor	2025-06-01 00:15:31.040571	2025-06-01 00:15:31.040571	\N	\N
3118	158	\N	Teja ondulada Duralit 2.44 x 1.08	pza	0.5000	105.00	material	2025-06-01 00:15:31.456731	2025-06-01 00:15:31.456731	\N	\N
3119	158	\N	Tirafondo 4 1/2x1/4	pza	3.0000	2.50	material	2025-06-01 00:15:31.491338	2025-06-01 00:15:31.491338	\N	\N
3120	158	\N	Ayudante	hr	0.5000	12.50	labor	2025-06-01 00:15:31.508977	2025-06-01 00:15:31.508977	\N	\N
3121	158	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:15:31.525719	2025-06-01 00:15:31.525719	\N	\N
3122	159	\N	Cubierta de Jatata	m2	1.0000	121.60	material	2025-06-01 00:15:31.887541	2025-06-01 00:15:31.887541	\N	\N
3123	159	\N	Ayudante 2	hr	1.0000	12.50	labor	2025-06-01 00:15:31.904518	2025-06-01 00:15:31.904518	\N	\N
3124	159	\N	Maestro colocador de cubierta jatata	hr	1.0000	120.00	labor	2025-06-01 00:15:31.921789	2025-06-01 00:15:31.921789	\N	\N
3125	160	\N	Clavos de 2 1/2 pulg	kg	0.5000	13.00	material	2025-06-01 00:15:32.30777	2025-06-01 00:15:32.30777	\N	\N
3126	160	\N	Tirafondo 4 1/2x1/4	pza	4.0000	2.50	material	2025-06-01 00:15:32.343176	2025-06-01 00:15:32.343176	\N	\N
3127	160	\N	Listón de 2x2 pulg	ml	1.0000	12.00	material	2025-06-01 00:15:32.378308	2025-06-01 00:15:32.378308	\N	\N
3128	160	\N	Viga de 2x6 pulg	ml	1.4300	68.00	material	2025-06-01 00:15:32.413521	2025-06-01 00:15:32.413521	\N	\N
3129	160	\N	Calamina Plástica Onduline (200x90)	m2	1.0000	44.42	material	2025-06-01 00:15:32.450922	2025-06-01 00:15:32.450922	\N	\N
3765	232	13	Madera para encofrado	p2	30.0000	8.00	material	2025-06-01 00:16:19.300588	2025-06-01 00:16:19.300588	\N	\N
3766	232	\N	Alambre de amarre	kg	1.5000	11.00	material	2025-06-01 00:16:19.335051	2025-06-01 00:16:19.335051	\N	\N
3767	232	22	Agua	lt	16.0000	0.06	material	2025-06-01 00:16:19.368065	2025-06-01 00:16:19.368065	\N	\N
3768	232	\N	Ayudante	hr	20.0000	12.50	labor	2025-06-01 00:16:19.385021	2025-06-01 00:16:19.385021	\N	\N
3769	232	\N	Ayudante (encofrador)	hr	8.0000	12.50	labor	2025-06-01 00:16:19.401648	2025-06-01 00:16:19.401648	\N	\N
3770	232	\N	Ayudante (fierrista)	hr	10.0000	12.50	labor	2025-06-01 00:16:19.418265	2025-06-01 00:16:19.418265	\N	\N
3771	232	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:19.435353	2025-06-01 00:16:19.435353	\N	\N
3772	232	\N	Maestro encofrador	hr	4.0000	18.75	labor	2025-06-01 00:16:19.452603	2025-06-01 00:16:19.452603	\N	\N
3773	232	\N	Maestro fierrista	hr	5.0000	18.75	labor	2025-06-01 00:16:19.470344	2025-06-01 00:16:19.470344	\N	\N
3774	232	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:16:19.487003	2025-06-01 00:16:19.487003	\N	\N
3775	232	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:16:19.503199	2025-06-01 00:16:19.503199	\N	\N
3776	233	\N	Acero de alta resistencia	kg	150.0000	8.50	material	2025-06-01 00:16:20.145709	2025-06-01 00:16:20.145709	\N	\N
3777	233	\N	Cemento portland IP-30	kg	350.0000	1.20	material	2025-06-01 00:16:20.185111	2025-06-01 00:16:20.185111	\N	\N
3778	233	\N	Arenilla	m3	0.5500	100.00	material	2025-06-01 00:16:20.219719	2025-06-01 00:16:20.219719	\N	\N
3779	233	\N	Ripio chancado	m3	0.7500	230.00	material	2025-06-01 00:16:20.255011	2025-06-01 00:16:20.255011	\N	\N
3780	233	23	Clavos de 2 pulg	kg	1.5000	13.00	material	2025-06-01 00:16:20.292085	2025-06-01 00:16:20.292085	\N	\N
3781	233	13	Madera para encofrado	p2	30.0000	8.00	material	2025-06-01 00:16:20.324133	2025-06-01 00:16:20.324133	\N	\N
3782	233	\N	Alambre de amarre	kg	1.5000	11.00	material	2025-06-01 00:16:20.358282	2025-06-01 00:16:20.358282	\N	\N
3783	233	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:16:20.39127	2025-06-01 00:16:20.39127	\N	\N
3784	233	\N	Ayudante	hr	25.0000	12.50	labor	2025-06-01 00:16:20.407953	2025-06-01 00:16:20.407953	\N	\N
3785	233	\N	Ayudante (encofrador)	hr	10.0000	12.50	labor	2025-06-01 00:16:20.424718	2025-06-01 00:16:20.424718	\N	\N
3786	233	\N	Ayudante (fierrista)	hr	10.0000	12.50	labor	2025-06-01 00:16:20.441372	2025-06-01 00:16:20.441372	\N	\N
3787	233	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:20.4581	2025-06-01 00:16:20.4581	\N	\N
3788	233	\N	Maestro encofrador	hr	5.0000	18.75	labor	2025-06-01 00:16:20.474703	2025-06-01 00:16:20.474703	\N	\N
3789	233	\N	Maestro fierrista	hr	5.0000	18.75	labor	2025-06-01 00:16:20.491391	2025-06-01 00:16:20.491391	\N	\N
3790	233	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:16:20.508105	2025-06-01 00:16:20.508105	\N	\N
3791	233	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:16:20.52513	2025-06-01 00:16:20.52513	\N	\N
3792	234	\N	Acero de alta resistencia	kg	55.0000	8.50	material	2025-06-01 00:16:21.10949	2025-06-01 00:16:21.10949	\N	\N
3793	234	\N	Cemento portland IP-30	kg	300.0000	1.20	material	2025-06-01 00:16:21.144095	2025-06-01 00:16:21.144095	\N	\N
3794	234	\N	Arenilla	m3	0.6000	100.00	material	2025-06-01 00:16:21.178538	2025-06-01 00:16:21.178538	\N	\N
3795	234	\N	Ripio rodado	m3	0.8000	170.00	material	2025-06-01 00:16:21.212987	2025-06-01 00:16:21.212987	\N	\N
3796	234	\N	Clavos de 2 1/2 pulg	kg	0.8000	13.00	material	2025-06-01 00:16:21.24853	2025-06-01 00:16:21.24853	\N	\N
3797	234	13	Madera para encofrado	p2	30.0000	8.00	material	2025-06-01 00:16:21.28199	2025-06-01 00:16:21.28199	\N	\N
3798	234	\N	Alambre de amarre	kg	0.8000	11.00	material	2025-06-01 00:16:21.316779	2025-06-01 00:16:21.316779	\N	\N
3799	234	22	Agua	lt	170.0000	0.06	material	2025-06-01 00:16:21.350401	2025-06-01 00:16:21.350401	\N	\N
3800	234	\N	Ayudante	hr	22.0000	12.50	labor	2025-06-01 00:16:21.367242	2025-06-01 00:16:21.367242	\N	\N
3801	234	\N	Ayudante (encofrador)	hr	8.0000	12.50	labor	2025-06-01 00:16:21.384265	2025-06-01 00:16:21.384265	\N	\N
3802	234	\N	Ayudante (fierrista)	hr	8.0000	12.50	labor	2025-06-01 00:16:21.401075	2025-06-01 00:16:21.401075	\N	\N
3803	234	\N	Maestro albañil	hr	5.0000	18.75	labor	2025-06-01 00:16:21.417675	2025-06-01 00:16:21.417675	\N	\N
3804	234	\N	Maestro encofrador	hr	4.0000	18.75	labor	2025-06-01 00:16:21.434332	2025-06-01 00:16:21.434332	\N	\N
3805	234	\N	Maestro fierrista	hr	4.0000	18.75	labor	2025-06-01 00:16:21.451377	2025-06-01 00:16:21.451377	\N	\N
3806	234	\N	Mezcladora 350 lts (1 bolsa)	hr	0.2500	30.00	equipment	2025-06-01 00:16:21.468185	2025-06-01 00:16:21.468185	\N	\N
3807	234	\N	Vibradora de inmersion	hr	0.2500	22.00	equipment	2025-06-01 00:16:21.485339	2025-06-01 00:16:21.485339	\N	\N
3808	235	\N	Alquitran	kg	2.0000	12.60	material	2025-06-01 00:16:22.095023	2025-06-01 00:16:22.095023	\N	\N
3809	235	\N	Cemento portland IP-30	kg	10.2000	1.20	material	2025-06-01 00:16:22.130598	2025-06-01 00:16:22.130598	\N	\N
3810	235	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:16:22.162779	2025-06-01 00:16:22.162779	\N	\N
3811	235	\N	Sika-1	lt	0.3600	18.00	material	2025-06-01 00:16:22.196771	2025-06-01 00:16:22.196771	\N	\N
3812	235	\N	Diesel	lt	1.1700	3.10	material	2025-06-01 00:16:22.231774	2025-06-01 00:16:22.231774	\N	\N
3813	235	\N	Ayudante	hr	1.0500	12.50	labor	2025-06-01 00:16:22.248876	2025-06-01 00:16:22.248876	\N	\N
3814	235	\N	Capataz	hr	0.0500	18.75	labor	2025-06-01 00:16:22.265693	2025-06-01 00:16:22.265693	\N	\N
3815	235	\N	Maestro albañil	hr	1.0500	18.75	labor	2025-06-01 00:16:22.284289	2025-06-01 00:16:22.284289	\N	\N
3816	236	\N	Alquitran	kg	0.2000	12.60	material	2025-06-01 00:16:22.859963	2025-06-01 00:16:22.859963	\N	\N
3817	236	\N	Cemento portland IP-30	kg	2.0000	1.20	material	2025-06-01 00:16:22.89451	2025-06-01 00:16:22.89451	\N	\N
3818	236	5	Arena Fina	m3	0.0100	70.00	material	2025-06-01 00:16:22.928338	2025-06-01 00:16:22.928338	\N	\N
3819	236	\N	Polietileno	m2	1.1000	3.73	material	2025-06-01 00:16:22.963213	2025-06-01 00:16:22.963213	\N	\N
3820	236	\N	Sika-1	lt	0.0900	18.00	material	2025-06-01 00:16:22.997425	2025-06-01 00:16:22.997425	\N	\N
3821	236	\N	Diesel	lt	0.1000	3.10	material	2025-06-01 00:16:23.033162	2025-06-01 00:16:23.033162	\N	\N
3822	236	\N	Ayudante	hr	0.2000	12.50	labor	2025-06-01 00:16:23.049852	2025-06-01 00:16:23.049852	\N	\N
3823	236	\N	Maestro albañil	hr	0.2000	18.75	labor	2025-06-01 00:16:23.066599	2025-06-01 00:16:23.066599	\N	\N
3824	237	\N	Alquitran	kg	0.4000	12.60	material	2025-06-01 00:16:23.482056	2025-06-01 00:16:23.482056	\N	\N
3825	237	\N	Cemento portland IP-30	kg	4.0000	1.20	material	2025-06-01 00:16:23.517015	2025-06-01 00:16:23.517015	\N	\N
3826	237	5	Arena Fina	m3	0.0200	70.00	material	2025-06-01 00:16:23.553305	2025-06-01 00:16:23.553305	\N	\N
3827	237	\N	Polietileno	m2	2.0000	3.73	material	2025-06-01 00:16:23.588871	2025-06-01 00:16:23.588871	\N	\N
3828	237	\N	Sika-1	lt	0.1800	18.00	material	2025-06-01 00:16:23.621873	2025-06-01 00:16:23.621873	\N	\N
3829	237	\N	Diesel	lt	0.2000	3.10	material	2025-06-01 00:16:23.656525	2025-06-01 00:16:23.656525	\N	\N
3830	237	\N	Ayudante	hr	0.2000	12.50	labor	2025-06-01 00:16:23.673192	2025-06-01 00:16:23.673192	\N	\N
3831	237	\N	Maestro albañil	hr	0.4000	18.75	labor	2025-06-01 00:16:23.689873	2025-06-01 00:16:23.689873	\N	\N
3832	238	\N	Impermeabilizante Recuplast galon 18 lt	lt	1.5000	46.40	material	2025-06-01 00:16:24.08087	2025-06-01 00:16:24.08087	\N	\N
3833	238	\N	Ayudante	hr	0.3000	12.50	labor	2025-06-01 00:16:24.097537	2025-06-01 00:16:24.097537	\N	\N
3834	238	\N	Maestro albañil	hr	0.3000	18.75	labor	2025-06-01 00:16:24.11428	2025-06-01 00:16:24.11428	\N	\N
3835	239	\N	Membrana asfáltica	m2	1.0500	46.97	material	2025-06-01 00:16:24.497221	2025-06-01 00:16:24.497221	\N	\N
3836	239	\N	Ayudante	hr	0.5000	12.50	labor	2025-06-01 00:16:24.514119	2025-06-01 00:16:24.514119	\N	\N
3837	239	\N	Maestro albañil	hr	0.5000	18.75	labor	2025-06-01 00:16:24.531254	2025-06-01 00:16:24.531254	\N	\N
3838	240	\N	Impermeabilizante Recuplast galon 18 lt	lt	1.5000	46.40	material	2025-06-01 00:16:24.944955	2025-06-01 00:16:24.944955	\N	\N
3839	240	\N	Ayudante	hr	0.3000	12.50	labor	2025-06-01 00:16:24.962154	2025-06-01 00:16:24.962154	\N	\N
3840	240	\N	Maestro albañil	hr	0.3000	18.75	labor	2025-06-01 00:16:24.978792	2025-06-01 00:16:24.978792	\N	\N
3841	241	\N	Material para acometida eléctrica de vivienda	gbl	1.0000	360.00	material	2025-06-01 00:16:25.424801	2025-06-01 00:16:25.424801	\N	\N
3842	241	\N	Maestro electricista	hr	8.0000	15.00	labor	2025-06-01 00:16:25.441711	2025-06-01 00:16:25.441711	\N	\N
3843	242	\N	Tubo de PVC de 1 pulg	ml	6.0000	3.60	material	2025-06-01 00:16:25.813249	2025-06-01 00:16:25.813249	\N	\N
3844	242	\N	Bastón de 1 plg	pza	1.0000	60.00	material	2025-06-01 00:16:25.847597	2025-06-01 00:16:25.847597	\N	\N
3845	242	\N	Caja metálica de 20x10cm	pza	1.0000	22.00	material	2025-06-01 00:16:25.88213	2025-06-01 00:16:25.88213	\N	\N
3846	242	\N	Cable telefónico de dos pares	ml	26.0000	2.20	material	2025-06-01 00:16:25.916836	2025-06-01 00:16:25.916836	\N	\N
3847	242	\N	Ayudante (electricista)	hr	6.0000	12.50	labor	2025-06-01 00:16:25.933555	2025-06-01 00:16:25.933555	\N	\N
3848	242	\N	Maestro electricista	hr	8.0000	15.00	labor	2025-06-01 00:16:25.95016	2025-06-01 00:16:25.95016	\N	\N
3849	243	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:26.343596	2025-06-01 00:16:26.343596	\N	\N
3850	243	\N	Alambre aislado 1.5mm2 (#14)	ml	10.0000	2.08	material	2025-06-01 00:16:26.380533	2025-06-01 00:16:26.380533	\N	\N
3851	243	\N	Aplique 100 W	pza	1.0000	201.75	material	2025-06-01 00:16:26.414637	2025-06-01 00:16:26.414637	\N	\N
3852	243	\N	Cinta aislante	pza	0.1500	6.00	material	2025-06-01 00:16:26.448691	2025-06-01 00:16:26.448691	\N	\N
3853	243	\N	Tubo Berman de 3/4 pulg	ml	4.5000	5.00	material	2025-06-01 00:16:26.483092	2025-06-01 00:16:26.483092	\N	\N
3854	243	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:26.498701	2025-06-01 00:16:26.498701	\N	\N
3855	244	\N	Pegante para PVC	lt	0.0100	35.00	material	2025-06-01 00:16:26.88406	2025-06-01 00:16:26.88406	\N	\N
3856	244	\N	Cinta aislante	pza	0.0100	6.00	material	2025-06-01 00:16:26.918104	2025-06-01 00:16:26.918104	\N	\N
3857	244	\N	Tubo Berman de 3/4 pulg	ml	1.0500	5.00	material	2025-06-01 00:16:26.952033	2025-06-01 00:16:26.952033	\N	\N
3858	244	\N	Alambre aislado Nº 10	ml	1.0500	5.00	material	2025-06-01 00:16:26.985961	2025-06-01 00:16:26.985961	\N	\N
3859	244	\N	Ayudante (electricista)	hr	0.5000	12.50	labor	2025-06-01 00:16:27.002567	2025-06-01 00:16:27.002567	\N	\N
3860	244	\N	Maestro electricista	hr	0.5000	15.00	labor	2025-06-01 00:16:27.019057	2025-06-01 00:16:27.019057	\N	\N
3861	245	\N	Pegante para PVC	lt	0.0100	35.00	material	2025-06-01 00:16:27.39911	2025-06-01 00:16:27.39911	\N	\N
3862	245	\N	Cinta aislante	pza	0.0100	6.00	material	2025-06-01 00:16:27.433553	2025-06-01 00:16:27.433553	\N	\N
3863	245	\N	Tubo Berman de 5/8 pulg	ml	1.0500	2.00	material	2025-06-01 00:16:27.469723	2025-06-01 00:16:27.469723	\N	\N
3864	245	\N	Alambre aislado Nº 12	ml	1.0500	4.00	material	2025-06-01 00:16:27.504071	2025-06-01 00:16:27.504071	\N	\N
3865	245	\N	Ayudante (electricista)	hr	0.5000	12.50	labor	2025-06-01 00:16:27.520698	2025-06-01 00:16:27.520698	\N	\N
3866	245	\N	Maestro electricista	hr	0.5000	15.00	labor	2025-06-01 00:16:27.544804	2025-06-01 00:16:27.544804	\N	\N
3867	246	\N	Pegante para PVC	lt	0.0100	35.00	material	2025-06-01 00:16:27.926983	2025-06-01 00:16:27.926983	\N	\N
3868	246	\N	Cinta aislante	pza	0.0100	6.00	material	2025-06-01 00:16:27.961529	2025-06-01 00:16:27.961529	\N	\N
3869	246	\N	Tubo Berman de 5/8 pulg	ml	1.0500	2.00	material	2025-06-01 00:16:27.996067	2025-06-01 00:16:27.996067	\N	\N
3870	246	\N	Alambre asilado Nº14	ml	1.0500	2.50	material	2025-06-01 00:16:28.031436	2025-06-01 00:16:28.031436	\N	\N
3871	246	\N	Ayudante (electricista)	hr	0.5000	12.50	labor	2025-06-01 00:16:28.0484	2025-06-01 00:16:28.0484	\N	\N
3872	246	\N	Maestro electricista	hr	0.5000	15.00	labor	2025-06-01 00:16:28.065101	2025-06-01 00:16:28.065101	\N	\N
3873	247	\N	Alambre aislado 4mm2 (#10)	ml	2.0000	4.00	material	2025-06-01 00:16:28.447055	2025-06-01 00:16:28.447055	\N	\N
3874	247	\N	Bastón de 3/4	pza	1.0000	60.80	material	2025-06-01 00:16:28.481419	2025-06-01 00:16:28.481419	\N	\N
3875	247	\N	Caja metálica para medidor	pza	1.0000	50.00	material	2025-06-01 00:16:28.516364	2025-06-01 00:16:28.516364	\N	\N
3876	247	\N	Cinta aislante	pza	3.0000	6.00	material	2025-06-01 00:16:28.550475	2025-06-01 00:16:28.550475	\N	\N
3877	247	\N	Tubo Berman de 3/4 pulg	ml	3.0000	5.00	material	2025-06-01 00:16:28.585503	2025-06-01 00:16:28.585503	\N	\N
3878	247	\N	Maestro electricista	hr	2.0000	15.00	labor	2025-06-01 00:16:28.602596	2025-06-01 00:16:28.602596	\N	\N
3879	248	\N	Spot para punto de luz	pza	1.0000	68.59	material	2025-06-01 00:16:28.986736	2025-06-01 00:16:28.986736	\N	\N
3880	248	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:29.021725	2025-06-01 00:16:29.021725	\N	\N
3881	248	\N	Alambre aislado 1.5mm2 (#14)	ml	10.0000	2.08	material	2025-06-01 00:16:29.056334	2025-06-01 00:16:29.056334	\N	\N
3882	248	\N	Cinta aislante	pza	0.1500	6.00	material	2025-06-01 00:16:29.092057	2025-06-01 00:16:29.092057	\N	\N
3883	248	\N	Tubo Berman de 3/4 pulg	ml	4.5000	5.00	material	2025-06-01 00:16:29.126227	2025-06-01 00:16:29.126227	\N	\N
3884	248	\N	Maestro electricista	hr	4.0000	15.00	labor	2025-06-01 00:16:29.142878	2025-06-01 00:16:29.142878	\N	\N
3885	249	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:29.524809	2025-06-01 00:16:29.524809	\N	\N
3886	249	\N	Alambre aislado 1.5mm2 (#14)	ml	15.0000	2.08	material	2025-06-01 00:16:29.559729	2025-06-01 00:16:29.559729	\N	\N
3887	249	\N	Alambre aislado 2.5mm2 (#12)	ml	16.0000	3.23	material	2025-06-01 00:16:29.594288	2025-06-01 00:16:29.594288	\N	\N
3888	249	\N	Caja plástica pvc 2x4	pza	2.0000	5.00	material	2025-06-01 00:16:29.628688	2025-06-01 00:16:29.628688	\N	\N
3889	249	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:29.663208	2025-06-01 00:16:29.663208	\N	\N
3890	249	\N	Interruptor conmutable doble	pza	2.0000	58.00	material	2025-06-01 00:16:29.698132	2025-06-01 00:16:29.698132	\N	\N
3891	249	\N	Tubo Berman de 3/4 pulg	ml	9.0000	5.00	material	2025-06-01 00:16:29.73276	2025-06-01 00:16:29.73276	\N	\N
3892	249	\N	Maestro electricista	hr	6.0000	15.00	labor	2025-06-01 00:16:29.749514	2025-06-01 00:16:29.749514	\N	\N
3893	250	\N	Pegante para PVC	lt	0.2500	35.00	material	2025-06-01 00:16:30.147186	2025-06-01 00:16:30.147186	\N	\N
3894	250	\N	Alambre aislado 1.5mm2 (#14)	ml	15.0000	2.08	material	2025-06-01 00:16:30.18157	2025-06-01 00:16:30.18157	\N	\N
3895	250	\N	Alambre aislado 2.5mm2 (#12)	ml	16.0000	3.23	material	2025-06-01 00:16:30.215812	2025-06-01 00:16:30.215812	\N	\N
3896	250	\N	Caja plástica pvc 2x4	pza	2.0000	5.00	material	2025-06-01 00:16:30.249873	2025-06-01 00:16:30.249873	\N	\N
3897	250	\N	Cinta aislante	pza	0.2500	6.00	material	2025-06-01 00:16:30.284287	2025-06-01 00:16:30.284287	\N	\N
3898	250	\N	Interruptor conmutable sencillo	pza	2.0000	49.00	material	2025-06-01 00:16:30.318633	2025-06-01 00:16:30.318633	\N	\N
3899	250	\N	Tubo Berman de 3/4 pulg	ml	9.0000	5.00	material	2025-06-01 00:16:30.352905	2025-06-01 00:16:30.352905	\N	\N
3900	250	\N	Maestro electricista	hr	6.0000	15.00	labor	2025-06-01 00:16:30.369622	2025-06-01 00:16:30.369622	\N	\N
3901	251	\N	Disyuntor 1x10 A	pza	1.0000	19.00	material	2025-06-01 00:16:30.735475	2025-06-01 00:16:30.735475	\N	\N
3902	251	\N	Maestro electricista	hr	0.2000	15.00	labor	2025-06-01 00:16:30.752129	2025-06-01 00:16:30.752129	\N	\N
3903	252	\N	Disyuntor 1x15A	pza	1.0000	19.00	material	2025-06-01 00:16:31.111962	2025-06-01 00:16:31.111962	\N	\N
3904	252	\N	Maestro electricista	hr	0.2000	15.00	labor	2025-06-01 00:16:31.128892	2025-06-01 00:16:31.128892	\N	\N
3905	253	\N	Disyuntor térmico de 20A	pza	1.0000	24.00	material	2025-06-01 00:16:31.488085	2025-06-01 00:16:31.488085	\N	\N
3906	253	\N	Maestro electricista	hr	0.2000	15.00	labor	2025-06-01 00:16:31.506273	2025-06-01 00:16:31.506273	\N	\N
3907	254	\N	Disyuntor térmico de 25A	pza	1.0000	24.00	material	2025-06-01 00:16:31.871084	2025-06-01 00:16:31.871084	\N	\N
3908	254	\N	Maestro colocador de cubierta jatata	hr	0.2000	120.00	labor	2025-06-01 00:16:31.888115	2025-06-01 00:16:31.888115	\N	\N
3909	255	\N	Disyuntor térmico de 32A	pza	1.0000	29.00	material	2025-06-01 00:16:32.246909	2025-06-01 00:16:32.246909	\N	\N
3910	255	\N	Maestro electricista	hr	0.2000	15.00	labor	2025-06-01 00:16:32.26383	2025-06-01 00:16:32.26383	\N	\N
5208	114	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.102469	2025-06-01 09:40:55.102469	3	\N
5209	121	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.1231	2025-06-01 09:40:55.1231	\N	4
5210	121	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.143289	2025-06-01 09:40:55.143289	9	\N
5211	121	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.161869	2025-06-01 09:40:55.161869	3	\N
5212	111	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.181103	2025-06-01 09:40:55.181103	\N	4
5213	111	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.200424	2025-06-01 09:40:55.200424	9	\N
5214	111	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.219828	2025-06-01 09:40:55.219828	3	\N
5215	116	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.239627	2025-06-01 09:40:55.239627	\N	4
5216	116	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.259272	2025-06-01 09:40:55.259272	9	\N
5217	116	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.279209	2025-06-01 09:40:55.279209	3	\N
5218	117	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.297803	2025-06-01 09:40:55.297803	\N	4
5219	117	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.317343	2025-06-01 09:40:55.317343	9	\N
5220	117	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.336791	2025-06-01 09:40:55.336791	3	\N
5221	113	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.356491	2025-06-01 09:40:55.356491	\N	4
5222	113	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.376112	2025-06-01 09:40:55.376112	9	\N
5223	113	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.395429	2025-06-01 09:40:55.395429	3	\N
5224	120	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.415023	2025-06-01 09:40:55.415023	\N	4
5225	120	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.436819	2025-06-01 09:40:55.436819	9	\N
5226	120	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.456297	2025-06-01 09:40:55.456297	3	\N
5227	104	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.47639	2025-06-01 09:40:55.47639	\N	4
5228	104	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.495963	2025-06-01 09:40:55.495963	9	\N
5229	104	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.515628	2025-06-01 09:40:55.515628	3	\N
5230	105	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.535595	2025-06-01 09:40:55.535595	\N	4
5231	105	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.555104	2025-06-01 09:40:55.555104	9	\N
5232	105	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.574713	2025-06-01 09:40:55.574713	3	\N
5233	109	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.594199	2025-06-01 09:40:55.594199	\N	4
5234	109	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:55.613813	2025-06-01 09:40:55.613813	9	\N
5235	109	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:55.634462	2025-06-01 09:40:55.634462	3	\N
5236	115	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:55.654096	2025-06-01 09:40:55.654096	\N	4
5347	131	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:57.849903	2025-06-01 09:40:57.849903	9	\N
5348	131	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:57.869413	2025-06-01 09:40:57.869413	3	\N
5349	103	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:57.89127	2025-06-01 09:40:57.89127	\N	4
5350	103	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:57.910169	2025-06-01 09:40:57.910169	9	\N
5351	103	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:57.930768	2025-06-01 09:40:57.930768	3	\N
5352	133	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:57.950797	2025-06-01 09:40:57.950797	\N	4
5353	133	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:57.97064	2025-06-01 09:40:57.97064	9	\N
5354	133	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:57.990104	2025-06-01 09:40:57.990104	3	\N
5355	325	\N	Herramienta: HERRAMIENTAS MENORES	%	0.1000	9.72	tool	2025-06-01 09:40:58.008847	2025-06-01 09:40:58.008847	\N	4
5356	325	\N	Mano de obra: PLOMERO ESPECIALISTA	HR	0.6000	56.88	labor	2025-06-01 09:40:58.02929	2025-06-01 09:40:58.02929	11	\N
5357	325	\N	Mano de obra: AYUDANTE	HR	0.6000	6.25	labor	2025-06-01 09:40:58.051821	2025-06-01 09:40:58.051821	3	\N
5358	476	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:58.071331	2025-06-01 09:40:58.071331	\N	4
5359	476	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:58.091487	2025-06-01 09:40:58.091487	9	\N
5360	476	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:58.110818	2025-06-01 09:40:58.110818	3	\N
5361	384	\N	Herramienta: RETROEXCAVADORA	HR.	0.2500	299.00	tool	2025-06-01 09:40:58.130464	2025-06-01 09:40:58.130464	\N	6
5362	384	\N	Herramienta: VOLQUETA	M3	0.2500	24.38	tool	2025-06-01 09:40:58.150616	2025-06-01 09:40:58.150616	\N	8
5363	384	\N	Mano de obra: PEON	HR	2.0000	4.50	labor	2025-06-01 09:40:58.171547	2025-06-01 09:40:58.171547	1	\N
5364	384	\N	Mano de obra: AYUDANTE	HR	2.0000	6.25	labor	2025-06-01 09:40:58.190825	2025-06-01 09:40:58.190825	3	\N
5365	452	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:58.210257	2025-06-01 09:40:58.210257	\N	4
5366	452	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:58.230311	2025-06-01 09:40:58.230311	9	\N
5367	452	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:58.249676	2025-06-01 09:40:58.249676	3	\N
5368	119	\N	Herramienta: HERRAMIENTAS MENORES	%	0.2000	9.72	tool	2025-06-01 09:40:58.269989	2025-06-01 09:40:58.269989	\N	4
5369	119	\N	Mano de obra: CARPINTERO	HR	1.5000	22.52	labor	2025-06-01 09:40:58.289507	2025-06-01 09:40:58.289507	9	\N
5370	119	\N	Mano de obra: AYUDANTE	HR	1.5000	6.25	labor	2025-06-01 09:40:58.309033	2025-06-01 09:40:58.309033	3	\N
5381	6	\N	Mano de obra básica: PEON	HR	0.5000	4.50	labor	2025-06-01 09:40:58.761717	2025-06-01 10:31:06.276	1	\N
5382	6	\N	Herramientas básicas: HERRAMIENTAS MENORES	%	0.0500	9.72	tool	2025-06-01 09:40:58.800973	2025-06-01 10:31:06.276	\N	4
5423	45	\N	Herramientas básicas: HERRAMIENTAS MENORES	%	0.0500	9.72	tool	2025-06-01 09:41:00.577619	2025-06-01 09:41:00.577619	\N	4
5424	43	\N	Herramientas básicas: HERRAMIENTAS MENORES	%	0.0500	9.72	tool	2025-06-01 09:41:00.637548	2025-06-01 09:41:00.637548	\N	4
5425	46	\N	Herramientas básicas: HERRAMIENTAS MENORES	%	0.0500	9.72	tool	2025-06-01 09:41:00.697338	2025-06-01 09:41:00.697338	\N	4
5428	47	\N	Herramientas básicas: HERRAMIENTAS MENORES	%	0.0500	9.72	tool	2025-06-01 09:41:00.832386	2025-06-01 09:41:00.832386	\N	4
5429	55	\N	Herramientas básicas: HERRAMIENTAS MENORES	%	0.0500	9.72	tool	2025-06-01 09:41:00.891207	2025-06-01 09:41:00.891207	\N	4
5430	51	\N	Herramientas básicas: HERRAMIENTAS MENORES	%	0.0500	9.72	tool	2025-06-01 09:41:00.950246	2025-06-01 09:41:00.950246	\N	4
5431	42	\N	Herramientas básicas: HERRAMIENTAS MENORES	%	0.0500	9.72	tool	2025-06-01 09:41:01.008706	2025-06-01 09:41:01.008706	\N	4
5432	40	\N	Herramientas básicas: HERRAMIENTAS MENORES	%	0.0500	9.72	tool	2025-06-01 09:41:01.065591	2025-06-01 09:41:01.065591	\N	4
5433	48	\N	Herramientas básicas: HERRAMIENTAS MENORES	%	0.0500	9.72	tool	2025-06-01 09:41:01.122637	2025-06-01 09:41:01.122637	\N	4
5434	54	\N	Herramientas básicas: HERRAMIENTAS MENORES	%	0.0500	9.72	tool	2025-06-01 09:41:01.180798	2025-06-01 09:41:01.180798	\N	4
5435	35	\N	Herramientas básicas: HERRAMIENTAS MENORES	%	0.0500	9.72	tool	2025-06-01 09:41:01.240761	2025-06-01 09:41:01.240761	\N	4
5436	50	\N	Herramientas básicas: HERRAMIENTAS MENORES	%	0.0500	9.72	tool	2025-06-01 09:41:01.302322	2025-06-01 09:41:01.302322	\N	4
5437	38	\N	Mano de obra básica: PEON	HR	0.5000	4.50	labor	2025-06-01 09:41:01.341101	2025-06-01 09:41:01.341101	1	\N
\.


--
-- Data for Name: budget_items; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.budget_items (id, budget_id, activity_id, quantity, unit_price, subtotal, phase_id) FROM stdin;
27	25	6	1.000	5.13	0.00	1
28	25	176	50.000	5.94	297.00	1
29	25	45	1.000	344.30	0.00	5
30	25	241	1.000	480.00	0.00	5
31	26	178	1.000	12.50	0.00	1
32	26	386	1.000	303.88	0.00	1
33	26	62	1.000	566.80	0.00	3
34	26	88	1.000	937.50	0.00	3
35	27	6	1.000	5.13	0.00	1
36	27	176	50.000	5.94	297.00	1
37	27	45	33.000	344.30	11361.90	5
38	27	241	34.000	480.00	16320.00	5
39	28	6	1.000	5.13	0.00	1
40	28	176	50.000	5.94	297.00	1
41	28	45	33.000	344.30	11361.90	5
42	28	241	34.000	480.00	16320.00	5
43	28	108	1.000	1035.00	1035.00	4
44	29	6	1.000	5.13	0.00	1
45	29	176	50.000	5.94	297.00	1
46	29	185	34.000	6.25	212.50	1
47	29	108	1.000	1035.00	1035.00	4
48	29	116	34.000	89.00	3026.00	4
49	29	45	33.000	344.30	11361.90	5
50	29	241	34.000	480.00	16320.00	5
51	29	245	2344.000	20.46	47958.24	5
52	30	184	2.000	1.25	2.50	1
53	30	390	3.000	303.88	911.64	1
54	30	32	2.000	354.13	708.26	3
55	31	184	2.000	1.25	2.50	1
56	31	390	3.000	303.88	911.64	1
57	31	32	2.000	354.13	708.26	3
58	31	266	12.000	272.00	3264.00	2
59	32	178	32.000	12.50	400.00	1
60	32	390	34.000	303.88	10331.92	1
61	33	178	32.000	12.50	400.00	1
62	33	390	34.000	303.88	10331.92	1
63	33	56	3.000	533.30	1599.90	3
64	33	234	1.000	5038.45	5038.45	3
65	34	386	2.000	303.88	607.76	1
66	34	185	2.000	6.25	12.50	1
\.


--
-- Data for Name: budgets; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.budgets (id, project_id, phase_id, total, status, created_at, updated_at) FROM stdin;
1	1	1	15750.00	active	2025-05-31 16:39:56.491842	2025-05-31 16:39:56.491842
2	1	2	28500.00	active	2025-05-31 16:39:56.491842	2025-05-31 16:39:56.491842
3	2	3	125000.00	active	2025-05-31 16:39:56.491842	2025-05-31 16:39:56.491842
4	3	1	8900.00	draft	2025-05-31 16:39:56.491842	2025-05-31 16:39:56.491842
25	37	\N	297.00	active	2025-06-01 11:11:46.202759	2025-06-01 11:11:46.202759
26	37	\N	0.00	active	2025-06-01 11:15:35.116028	2025-06-01 11:15:35.116028
27	37	\N	27978.90	active	2025-06-01 11:20:30.335984	2025-06-01 11:20:30.335984
28	37	\N	29013.90	active	2025-06-01 11:21:25.563162	2025-06-01 11:21:25.563162
29	37	\N	80210.64	active	2025-06-01 11:23:16.145041	2025-06-01 11:23:16.145041
30	38	\N	1622.40	active	2025-06-01 12:11:58.210542	2025-06-01 12:11:58.210542
31	38	\N	4886.40	active	2025-06-01 13:29:10.505926	2025-06-01 13:29:10.505926
32	39	\N	10731.92	active	2025-06-01 13:47:41.965467	2025-06-01 13:47:41.965467
33	39	\N	17370.27	active	2025-06-01 14:23:49.234669	2025-06-01 14:23:49.234669
34	40	\N	1228.02	active	2025-06-01 16:21:08.170385	2025-06-01 16:21:08.170385
\.


--
-- Data for Name: city_price_factors; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.city_price_factors (id, city, country, materials_factor, labor_factor, equipment_factor, transport_factor, description, is_active, created_at, updated_at) FROM stdin;
1	La Paz	Bolivia	1.1500	1.2000	1.1000	1.2500	Capital administrativa - precios elevados por altitud y costos logísticos	t	2025-06-01 01:09:04.722584	2025-06-01 01:09:04.722584
2	Santa Cruz	Bolivia	1.0000	1.0000	1.0000	1.0000	Ciudad de referencia base para precios de construcción en Bolivia	t	2025-06-01 01:09:04.722584	2025-06-01 01:09:04.722584
3	Cochabamba	Bolivia	0.9500	0.9800	0.9600	0.9200	Precios moderados - centro del país con buena conectividad	t	2025-06-01 01:09:04.722584	2025-06-01 01:09:04.722584
4	Sucre	Bolivia	1.0500	1.0800	1.0300	1.1500	Capital constitucional - precios ligeramente elevados	t	2025-06-01 01:09:04.722584	2025-06-01 01:09:04.722584
5	Potosí	Bolivia	1.2500	1.3000	1.2000	1.4000	Precios altos por altitud extrema y dificultades logísticas	t	2025-06-01 01:09:04.722584	2025-06-01 01:09:04.722584
6	Oruro	Bolivia	1.1200	1.1500	1.0800	1.2000	Precios elevados por ubicación en altiplano	t	2025-06-01 01:09:04.722584	2025-06-01 01:09:04.722584
7	Tarija	Bolivia	0.8800	0.9200	0.9000	0.9500	Precios menores por menor demanda y ubicación sureña	t	2025-06-01 01:09:04.722584	2025-06-01 01:09:04.722584
8	Trinidad	Bolivia	1.3000	1.2500	1.3500	1.5000	Precios altos por ubicación en Beni y transporte fluvial	t	2025-06-01 01:09:04.722584	2025-06-01 01:09:04.722584
9	Cobija	Bolivia	1.3500	1.3000	1.4000	1.6000	Precios más altos por ubicación fronteriza amazónica	t	2025-06-01 01:09:04.722584	2025-06-01 01:09:04.722584
\.


--
-- Data for Name: company_advertisements; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.company_advertisements (id, supplier_id, title, description, image_url, link_url, ad_type, is_active, start_date, end_date, view_count, click_count, created_at, updated_at) FROM stdin;
3	152	Materiales de Primera - Bolivia	Cemento, acero y agregados de la mejor calidad. Distribución directa a toda Bolivia con precios competitivos.	/uploads/logo-1748924663278.jpg	https://materialesbolivia.com	featured	t	2025-06-01 00:00:00	2025-06-28 00:00:00	103	0	2025-06-01 19:29:57.820793	2025-06-03 09:44:27.391
4	153	Herramientas Profesionales	Tu ferretería de confianza en Cochabamba. Herramientas, equipos y asesoría técnica especializada.	/uploads/logo-1748927322200.webp	https://ferreteriacentral.com	standard	t	2025-06-01 00:00:00	2025-06-30 00:00:00	108	0	2025-06-01 19:29:57.820793	2025-06-03 09:45:16.9
1	150	Espacio Publicitario - publica tu empresa gratis por tiempo limitado	detalles 	/uploads/logo-1748927473791.jpg		banner	t	2025-06-01 00:00:00	2025-06-29 00:00:00	142	0	2025-06-01 18:05:36.871096	2025-06-03 09:45:16.918
2	151	Construcción de Calidad - Constructora ABC	Proyectos residenciales y comerciales con garantía. Más de 15 años construyendo tu futuro en La Paz.	/uploads/logo-1748924145870.jpg	https://constructora-abc.com	standard	t	2025-06-01 00:00:00	2025-06-03 00:00:00	58	0	2025-06-01 19:29:57.820793	2025-06-03 04:15:49.941
\.


--
-- Data for Name: construction_phases; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.construction_phases (id, name, description) FROM stdin;
1	TRABAJOS PRELIMINARES	Actividades iniciales de preparación del proyecto
2	MOVIMIENTOS DE TIERRAS	Excavaciones, rellenos y movimiento de suelos
3	OBRA GRUESA	Estructura principal de la construcción
4	OBRA FINA	Acabados interiores y exteriores
5	INSTALACIONES HIDROSANITARIAS	Sistemas de agua potable y desagüe
6	INSTALACIONES ELECTRICAS	Sistemas eléctricos y de comunicaciones
7	TRABAJOS DE ACABADOS	Acabados finales y decorativos
8	JARDINES Y EXTERIORES	Paisajismo y áreas exteriores
9	VIAS Y ACCESOS	Pavimentación y accesos vehiculares
\.


--
-- Data for Name: consultation_messages; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.consultation_messages (id, user_id, name, email, message_type, subject, message, status, admin_response, is_public, created_at, responded_at) FROM stdin;
\.


--
-- Data for Name: labor_categories; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.labor_categories (id, name, description, unit, hourly_rate, skill_level, is_active, created_at, updated_at) FROM stdin;
1	PEON	Categoría de mano de obra: PEON	HR	4.50	basic	t	2025-06-01 09:30:52.501913	2025-06-01 09:30:52.501913
2	ALBAÑIL	Categoría de mano de obra: ALBAÑIL	HR	10.00	skilled	t	2025-06-01 09:30:52.519791	2025-06-01 09:30:52.519791
3	AYUDANTE	Categoría de mano de obra: AYUDANTE	HR	6.25	basic	t	2025-06-01 09:30:52.535975	2025-06-01 09:30:52.535975
4	ESPECIALISTA	Categoría de mano de obra: ESPECIALISTA	HR	18.01	specialist	t	2025-06-01 09:30:52.551671	2025-06-01 09:30:52.551671
5	PERFORISTA	Categoría de mano de obra: PERFORISTA	HR	9.53	basic	t	2025-06-01 09:30:52.567786	2025-06-01 09:30:52.567786
6	ESPECIALISTA CALIFICADO	Categoría de mano de obra: ESPECIALISTA CALIFICADO	HR	21.02	specialist	t	2025-06-01 09:30:52.583789	2025-06-01 09:30:52.583789
7	ENCOFRADOR	Categoría de mano de obra: ENCOFRADOR	HR	11.25	skilled	t	2025-06-01 09:30:52.599887	2025-06-01 09:30:52.599887
8	ARMADOR	Categoría de mano de obra: ARMADOR	HR	11.25	skilled	t	2025-06-01 09:30:52.615614	2025-06-01 09:30:52.615614
9	CARPINTERO	Categoría de mano de obra: CARPINTERO	HR	22.52	specialist	t	2025-06-01 09:30:52.630181	2025-06-01 09:30:52.630181
10	ESPECIALISTA CERRAJERO	Categoría de mano de obra: ESPECIALISTA CERRAJERO	HR	15.61	specialist	t	2025-06-01 09:30:52.645931	2025-06-01 09:30:52.645931
11	PLOMERO ESPECIALISTA	Categoría de mano de obra: PLOMERO ESPECIALISTA	HR	56.88	specialist	t	2025-06-01 09:30:52.661721	2025-06-01 09:30:52.661721
12	ELECTRICISTA	Categoría de mano de obra: ELECTRICISTA	HR	15.01	skilled	t	2025-06-01 09:30:52.676353	2025-06-01 09:30:52.676353
\.


--
-- Data for Name: material_categories; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.material_categories (id, name) FROM stdin;
1	ACERO PARA CONSTRUCCION
2	ADHESIVOS
3	ADITIVOS
4	ADOQUINES
5	AISLAMIENTO TERMICO Y ACUSTICO
6	ALIGERANTES
7	ALAMBRES Y MALLAS
8	ARIDOS Y PIEDRAS
9	ALFOMBRAS Y EMPAPELADOS
10	AZULEJOS Y CERAMICOS
11	BOMBAS DE AGUA
12	CALEFONES
13	CAÑOS Y ACCESORIOS
14	CAMARA SEPTICA DE PVC
15	CARPINTERIA DE ALUMINIO
16	CEMENTOS
17	CIELO FALSO PLAFON
18	CLAVOS
19	CUBIERTAS
20	DOMOS DE PVC
21	ESTUCOS Y CALES
22	FIJACIONES EN SECO
23	GAVIONES
24	GRIFERIA
25	HERRAMIENTAS
26	IMPERMEABILIZANTES
27	IMPERMEABILIZANTES SUPERFICIALES
28	INSTALACION ELECTRICA
29	INSTALACION SANITARIA
30	INSTALACION TELEFONICA
31	LADRILLOS
32	LOSETAS
33	MADERAS
34	MADERA ELABORADA
35	MANGUERAS
36	MOSAICOS Y ZOCALOS
37	MALLAS ELECTROSOLDADAS
38	MATERIAL ELECTRICO DE EMPALME
39	MESONES
40	PINTURAS
41	PISOS
42	PLANCHAS DE ACERO
43	PLANCHAS DE ACRILICO
44	POLITUBOS
45	QUINQUELLERIA
46	SELLANTES
47	SOGAS
48	TANQUES
49	TEJAS
50	TIERRA TOSCA Y SUELO SELECCIONADO
51	TUBOS DE CERAMICA
52	TUBOS DE HORMIGON
53	TUBOS Y ACCESORIOS DE PVC
54	TUBERIAS Y AGO. NOVAFOI
55	TUBOS Y ACC. P/AGUA CALIENTE
56	VIDRIOS
57	CARBURANTES - LUBRICANTES
58	CAMARA NUEVA ERA DE POLIETILENO
\.


--
-- Data for Name: material_supplier_prices; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.material_supplier_prices (id, material_id, supplier_id, price, currency, minimum_quantity, lead_time_days, description, is_active, last_updated, valid_until, created_at) FROM stdin;
1	1793	150	499.0000	BOB	1.00	0	\N	t	2025-06-01 12:07:31.880765	2025-06-08 00:00:00	2025-06-01 12:07:31.880765
2	1793	150	466.0000	BOB	1.00	0	\N	t	2025-06-01 13:18:36.281688	2025-06-01 00:00:00	2025-06-01 13:18:36.281688
\.


--
-- Data for Name: materials; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.materials (id, category_id, name, unit, price, description, last_updated) FROM stdin;
1	16	Cemento Portland Tipo I	Bolsa	45.50	Cemento hidráulico para uso general	2025-05-31 16:39:27.15218
2	16	Cemento Portland Tipo IP	Bolsa	42.00	Cemento con adición puzolánica	2025-05-31 16:39:27.15218
3	31	Ladrillo Gambote 6H	Unidad	2.80	Ladrillo cerámico para mampostería	2025-05-31 16:39:27.15218
4	31	Ladrillo Adobito	Unidad	1.90	Ladrillo de menor dimensión	2025-05-31 16:39:27.15218
5	8	Arena Fina	M3	120.00	Arena fina para morteros y revoques	2025-05-31 16:39:27.15218
6	8	Arena Gruesa	M3	110.00	Arena gruesa para hormigones	2025-05-31 16:39:27.15218
7	8	Grava 3/4	M3	140.00	Grava de 3/4 de pulgada	2025-05-31 16:39:27.15218
8	8	Piedra Manzana	M3	85.00	Piedra para hormigón ciclópeo	2025-05-31 16:39:27.15218
9	1	Fierro 8mm	Kg	8.50	Barra de acero corrugado de 8mm	2025-05-31 16:39:27.15218
10	1	Fierro 10mm	Kg	8.50	Barra de acero corrugado de 10mm	2025-05-31 16:39:27.15218
11	1	Fierro 12mm	Kg	8.50	Barra de acero corrugado de 12mm	2025-05-31 16:39:27.15218
12	1	Alambre Negro #18	Kg	12.00	Alambre para amarres	2025-05-31 16:39:27.15218
13	33	Tablón 2x8x4m	Pieza	85.00	Tablón de madera para encofrados	2025-05-31 16:39:27.15218
14	33	Cuartón 2x3x4m	Pieza	35.00	Cuartón de madera	2025-05-31 16:39:27.15218
15	19	Calamina Galvanizada #28	Plancha	78.00	Plancha ondulada galvanizada	2025-05-31 16:39:27.15218
16	49	Teja Colonial	Unidad	4.50	Teja cerámica colonial	2025-05-31 16:39:27.15218
17	40	Pintura Latex Interior	Galón	95.00	Pintura latex para interiores	2025-05-31 16:39:27.15218
18	40	Pintura Anticorrosiva	Galón	110.00	Pintura base para metales	2025-05-31 16:39:27.15218
19	10	Azulejo 20x30 Blanco	M2	35.00	Azulejo cerámico blanco	2025-05-31 16:39:27.15218
20	10	Cerámica Piso 40x40	M2	48.00	Cerámica para piso	2025-05-31 16:39:27.15218
21	53	Tubo PVC 4" Desagüe	Metro	28.00	Tubo PVC para desagües	2025-05-31 16:39:27.15218
22	53	Tubo PVC 1/2" Presión	Metro	4.20	Tubo PVC para agua potable	2025-05-31 16:39:27.15218
23	18	Clavos 2"	Kg	9.50	Clavos de 2 pulgadas	2025-05-31 16:39:27.15218
24	18	Clavos 3"	Kg	9.50	Clavos de 3 pulgadas	2025-05-31 16:39:27.15218
25	45	Bisagras 3"	Par	18.00	Bisagras de 3 pulgadas	2025-05-31 16:39:27.15218
26	56	Vidrio Transparente 4mm	M2	85.00	Vidrio transparente de 4mm	2025-05-31 16:39:27.15218
59	1	CORRUGADO 1/4" (6mm.) BAR 12 m.	Barra	16.89	Barra corrugada de 6mm	2025-05-31 20:27:13.387646
60	1	CORRUGADO 5/16" (8 mm.) BAR 12 m.	Barra	28.66	Barra corrugada de 8mm	2025-05-31 20:27:13.387646
61	1	CORRUGADO 3/8" (10 mm.) BAR 12 m.	Barra	45.55	Barra corrugada de 10mm	2025-05-31 20:27:13.387646
62	1	CORRUGADO 1/2" (12 mm.) BAR 12 m.	Barra	69.17	Barra corrugada de 12mm	2025-05-31 20:27:13.387646
63	1	CORRUGADO 5/8" (16 mm.) BAR 12 m.	Barra	123.18	Barra corrugada de 16mm	2025-05-31 20:27:13.387646
64	1	CORRUGADO 3/4" (20 mm.) BAR 12 m.	Barra	192.35	Barra corrugada de 20mm	2025-05-31 20:27:13.387646
65	1	CORRUGADO 1" (25 mm.) BAR 12 m.	Barra	310.45	Barra corrugada de 25mm	2025-05-31 20:27:13.387646
66	1	LISO 1/4" (6mm.) BAR 12 m.	Barra	17.70	Barra lisa de 6mm	2025-05-31 20:27:13.387646
67	1	LISO 5/16" (8mm.) BAR 12 m.	Barra	28.82	Barra lisa de 8mm	2025-05-31 20:27:13.387646
68	1	LISO 3/8" (10mm.) BAR 12 m.	Barra	44.06	Barra lisa de 10mm	2025-05-31 20:27:13.387646
69	1	LISO 1/2" (12 mm.) BAR 12 m.	Barra	66.64	Barra lisa de 12mm	2025-05-31 20:27:13.387646
70	1	ANGULAR 3/4"x1/8" BAR 6 m.	Barra	39.99	Angular de acero	2025-05-31 20:27:13.387646
71	1	ANGULAR 1" x 3/16" BAR 6 m.	Barra	75.06	Angular de acero	2025-05-31 20:27:13.387646
72	1	ANGULAR 2" x 1/4" BAR 6 m.	Barra	187.30	Angular de acero	2025-05-31 20:27:13.387646
73	1	TUBULAR CUADRADO 20x20	Barra	38.29	Tubo cuadrado	2025-05-31 20:27:13.387646
74	1	TUBULAR CUADRADO 25x25	Barra	44.44	Tubo cuadrado	2025-05-31 20:27:13.387646
75	1	TUBULAR REDONDO DE 25 mm.	Barra	36.07	Tubo redondo	2025-05-31 20:27:13.387646
76	1	PLATINA 1"x 1/8"	Barra	30.69	Platina de acero	2025-05-31 20:27:13.387646
77	1	PLATINA 2" x 1/4"	Barra	76.59	Platina de acero	2025-05-31 20:27:13.387646
78	1	ALAMBRE GALVANIZADO #14	Kg	19.44	Alambre galvanizado	2025-05-31 20:27:13.387646
79	2	CARPICOLA MONOPOL env. 3.5 Lts.	Galón	96.14	Adhesivo para carpintería	2025-05-31 20:27:13.387646
80	2	PARKETEX env 18 Lts WILLIAMS	Galón	107.22	Adhesivo para parquet	2025-05-31 20:27:13.387646
81	2	PEGA ALFOMBRA MONOPOL	Galón	136.82	Adhesivo para alfombras	2025-05-31 20:27:13.387646
82	2	PEGA PARKET	Bolsa 12Kg	290.35	Adhesivo para parquet	2025-05-31 20:27:13.387646
83	2	COLA FRESCA	Kg	11.32	Cola blanca	2025-05-31 20:27:13.387646
84	2	PEGATUBO PARA PVC MONOPOL	Galón	364.08	Adhesivo PVC	2025-05-31 20:27:13.387646
85	2	SIKADUR 31 ADHESIVO EPOXICO	Kg	248.03	Adhesivo epóxico estructural	2025-05-31 20:27:13.387646
86	2	PEGAMENTO PVC P-14 PARABOND	Litro	132.63	Pegamento para tubería PVC	2025-05-31 20:27:13.387646
87	2	PEGAMENTO CPVC (Agua Caliente)	Litro	171.59	Pegamento para agua caliente	2025-05-31 20:27:13.387646
88	3	SIKA 4 A IMPERMEABILIZANTE	Kg	40.13	Impermeabilizante	2025-05-31 20:27:13.387646
89	3	SIKA 1 IMPERMEABILIZANTE	Bolsa 5Kg	153.57	Impermeabilizante	2025-05-31 20:27:13.387646
90	3	SIKA 2 ACELERADOR ULTRA RAPIDO	Bolsa 6Kg	224.38	Acelerador de fraguado	2025-05-31 20:27:13.387646
91	3	PLASTIMENT BV-40 PLASTIFICANTE	Bolsa 20Kg	858.08	Plastificante para hormigón	2025-05-31 20:27:13.387646
92	3	SIKAMENT FF.86 SUPER PLASTIFICANTE	Bolsa 20Kg	1636.53	Super plastificante	2025-05-31 20:27:13.387646
93	3	SIKA LATEX ADHERENTE P/MORTERO	Bolsa 5Kg	213.75	Látex para morteros	2025-05-31 20:27:13.387646
94	8	ARENA FINA LAVADA	M3	120.00	Arena fina para morteros	2025-05-31 20:27:35.221576
95	8	ARENA GRUESA	M3	110.00	Arena para hormigones	2025-05-31 20:27:35.221576
96	8	GRAVA 3/4"	M3	140.00	Grava de 3/4 pulgada	2025-05-31 20:27:35.221576
97	8	GRAVA 1/2"	M3	135.00	Grava de 1/2 pulgada	2025-05-31 20:27:35.221576
98	8	RIPIO 3/4"	M3	95.00	Ripio para hormigón	2025-05-31 20:27:35.221576
99	8	PIEDRA MANZANA	M3	85.00	Piedra para hormigón ciclópeo	2025-05-31 20:27:35.221576
100	8	PIEDRA BRUTA	M3	75.00	Piedra bruta para cimientos	2025-05-31 20:27:35.221576
101	8	GRAVILLA	M3	125.00	Gravilla decorativa	2025-05-31 20:27:35.221576
102	16	CEMENTO PORTLAND TIPO I	Bolsa	45.50	Cemento normal	2025-05-31 20:27:35.221576
103	16	CEMENTO PORTLAND TIPO IP	Bolsa	42.00	Cemento con adición puzolánica	2025-05-31 20:27:35.221576
104	16	CEMENTO PORTLAND TIPO V	Bolsa	48.00	Cemento resistente a sulfatos	2025-05-31 20:27:35.221576
105	16	CEMENTO BLANCO	Bolsa	85.00	Cemento blanco estructural	2025-05-31 20:27:35.221576
106	16	CAL HIDRATADA	Bolsa	18.50	Cal para morteros	2025-05-31 20:27:35.221576
107	18	CLAVOS 1"	Kg	9.50	Clavos de 1 pulgada	2025-05-31 20:27:35.221576
108	18	CLAVOS 2"	Kg	9.50	Clavos de 2 pulgadas	2025-05-31 20:27:35.221576
109	18	CLAVOS 3"	Kg	9.50	Clavos de 3 pulgadas	2025-05-31 20:27:35.221576
110	18	CLAVOS 4"	Kg	9.50	Clavos de 4 pulgadas	2025-05-31 20:27:35.221576
111	18	CLAVOS DE TECHOS	Kg	11.00	Clavos especiales para techos	2025-05-31 20:27:35.221576
112	18	TORNILLOS 2" x 8	Kg	12.50	Tornillos para madera	2025-05-31 20:27:35.221576
113	31	LADRILLO GAMBOTE 6H	Unidad	2.80	Ladrillo cerámico común	2025-05-31 20:27:35.221576
114	31	LADRILLO ADOBITO	Unidad	1.90	Ladrillo pequeño	2025-05-31 20:27:35.221576
115	31	LADRILLO VISTO 6H	Unidad	3.20	Ladrillo visto para acabados	2025-05-31 20:27:35.221576
116	31	LADRILLO TUBULAR 12cm	Unidad	4.50	Ladrillo tubular	2025-05-31 20:27:35.221576
117	31	LADRILLO REFRACTARIO	Unidad	15.00	Ladrillo para hornos	2025-05-31 20:27:35.221576
118	31	BLOCK DE HORMIGON 15cm	Unidad	8.50	Block hueco de hormigón	2025-05-31 20:27:35.221576
119	33	TABLON 2x8x4m EUCALIPTO	Pieza	85.00	Tablón para encofrados	2025-05-31 20:27:59.099651
120	33	CUARTON 2x3x4m	Pieza	35.00	Cuartón de madera	2025-05-31 20:27:59.099651
121	33	VIGA 2x10x4m	Pieza	120.00	Viga estructural	2025-05-31 20:27:59.099651
122	33	TABLA 1x8x4m	Pieza	28.00	Tabla para construcción	2025-05-31 20:27:59.099651
123	33	MACHIHEMBRE MARA	M2	180.00	Piso de madera mara	2025-05-31 20:27:59.099651
124	33	PUERTA CONTRAPLACA 0.80x2.10	Pieza	450.00	Puerta de madera	2025-05-31 20:27:59.099651
125	33	VENTANA MADERA 1.20x1.00	M2	320.00	Ventana de madera	2025-05-31 20:27:59.099651
126	40	PINTURA LATEX INTERIOR	Galón	95.00	Pintura latex para interiores	2025-05-31 20:27:59.099651
127	40	PINTURA LATEX EXTERIOR	Galón	105.00	Pintura latex para exteriores	2025-05-31 20:27:59.099651
128	40	PINTURA ANTICORROSIVA	Galón	110.00	Base anticorrosiva	2025-05-31 20:27:59.099651
129	40	ESMALTE SINTETICO	Galón	125.00	Esmalte para acabados	2025-05-31 20:27:59.099651
130	40	BARNIZ MARINO	Galón	135.00	Barniz para madera	2025-05-31 20:27:59.099651
131	40	IMPRIMANTE BLANCO	Galón	88.00	Imprimante para muros	2025-05-31 20:27:59.099651
132	45	BISAGRAS 3"	Par	18.00	Bisagras de 3 pulgadas	2025-05-31 20:27:59.099651
133	45	BISAGRAS 4"	Par	25.00	Bisagras de 4 pulgadas	2025-05-31 20:27:59.099651
134	45	CERRADURA EXTERIOR	Pieza	180.00	Cerradura para puerta principal	2025-05-31 20:27:59.099651
135	45	CERRADURA INTERIOR	Pieza	95.00	Cerradura para puerta interior	2025-05-31 20:27:59.099651
136	45	MANIJA BRONCE	Pieza	45.00	Manija de bronce	2025-05-31 20:27:59.099651
137	45	ALDABA GRANDE	Pieza	35.00	Aldaba para portón	2025-05-31 20:27:59.099651
138	45	CANDADO 50mm	Pieza	28.00	Candado mediano	2025-05-31 20:27:59.099651
139	19	CALAMINA GALVANIZADA #28	Plancha	78.00	Plancha ondulada galvanizada	2025-05-31 20:27:59.099651
140	19	CALAMINA GALVANIZADA #33	Plancha	95.00	Plancha galvanizada pesada	2025-05-31 20:27:59.099651
141	19	CALAMINA PLASTICA #12	Plancha	65.00	Plancha plástica translúcida	2025-05-31 20:27:59.099651
142	19	TEJA ETERNIT	Plancha	68.00	Plancha de fibrocemento	2025-05-31 20:27:59.099651
143	19	CUMBRERA GALVANIZADA	Metro	35.00	Cumbrera metálica	2025-05-31 20:27:59.099651
144	19	CANAL GALVANIZADA	Metro	28.00	Canal para desagüe	2025-05-31 20:27:59.099651
145	53	TUBO PVC 4" DESAGUE	Metro	28.00	Tubo para desagüe	2025-05-31 20:27:59.099651
146	53	TUBO PVC 6" DESAGUE	Metro	45.00	Tubo para desagüe principal	2025-05-31 20:27:59.099651
147	53	TUBO PVC 1/2" PRESION	Metro	4.20	Tubo para agua potable	2025-05-31 20:27:59.099651
148	53	TUBO PVC 3/4" PRESION	Metro	6.80	Tubo para agua potable	2025-05-31 20:27:59.099651
149	53	CODO PVC 4" x 90°	Unidad	18.50	Codo para desagüe	2025-05-31 20:27:59.099651
150	53	CODO PVC 1/2" x 90°	Unidad	2.80	Codo para agua	2025-05-31 20:27:59.099651
151	53	TEE PVC 4"	Unidad	25.00	Tee para desagüe	2025-05-31 20:27:59.099651
152	53	TEE PVC 1/2"	Unidad	3.80	Tee para agua	2025-05-31 20:27:59.099651
153	53	REDUCCION PVC 4" a 2"	Unidad	15.50	Reducción de diámetro	2025-05-31 20:27:59.099651
154	10	AZULEJO 20x30 BLANCO	M2	35.00	Azulejo cerámico blanco	2025-05-31 20:28:27.046508
155	10	AZULEJO 20x30 COLOR	M2	42.00	Azulejo cerámico de color	2025-05-31 20:28:27.046508
156	10	CERAMICA PISO 40x40	M2	48.00	Cerámica para piso	2025-05-31 20:28:27.046508
157	10	CERAMICA PISO 60x60	M2	75.00	Cerámica grande para piso	2025-05-31 20:28:27.046508
158	10	CERAMICA ANTIDESLIZANTE	M2	55.00	Cerámica rugosa para baños	2025-05-31 20:28:27.046508
159	10	PORCELANATO 60x60	M2	120.00	Porcelanato premium	2025-05-31 20:28:27.046508
160	56	VIDRIO TRANSPARENTE 4mm	M2	85.00	Vidrio transparente común	2025-05-31 20:28:27.046508
161	56	VIDRIO TRANSPARENTE 6mm	M2	125.00	Vidrio transparente grueso	2025-05-31 20:28:27.046508
162	56	VIDRIO CATEDRAL 3mm	M2	95.00	Vidrio translúcido	2025-05-31 20:28:27.046508
163	56	VIDRIO ESPEJO 4mm	M2	180.00	Espejo común	2025-05-31 20:28:27.046508
164	56	VIDRIO TEMPLADO 8mm	M2	220.00	Vidrio de seguridad	2025-05-31 20:28:27.046508
165	49	TEJA COLONIAL CERAMICA	Unidad	4.50	Teja cerámica tradicional	2025-05-31 20:28:27.046508
166	49	TEJA ESPAÑOLA DURALIT	Unidad	5.20	Teja de concreto	2025-05-31 20:28:27.046508
167	49	TEJA ROMANA PRENSADA	Unidad	6.80	Teja romana de concreto	2025-05-31 20:28:27.046508
168	49	CUMBRERA TEJA COLONIAL	Metro	38.00	Cumbrera cerámica	2025-05-31 20:28:27.046508
169	41	PISO MOSAICO GRANITICO	M2	85.00	Mosaico granulado	2025-05-31 20:28:27.046508
170	41	PISO MOSAICO CORRIENTE	M2	65.00	Mosaico económico	2025-05-31 20:28:27.046508
171	41	PISO VINILICO	M2	45.00	Piso vinílico	2025-05-31 20:28:27.046508
172	41	PISO LAMINADO DOMESTICO	M2	95.00	Piso laminado residencial	2025-05-31 20:28:27.046508
173	41	PARQUET MARA	M2	350.00	Parquet de madera mara	2025-05-31 20:28:27.046508
174	41	ALFOMBRA RESIDENCIAL	M2	35.00	Alfombra común	2025-05-31 20:28:27.046508
175	29	INODORO COMPLETO	Pieza	285.00	Inodoro con accesorios	2025-05-31 20:28:27.046508
176	29	LAVAMANOS BLANCO	Pieza	145.00	Lavamanos cerámico	2025-05-31 20:28:27.046508
177	29	LAVAPLATOS 2 DEP. 1 FREG.	Pieza	320.00	Lavaplatos de acero	2025-05-31 20:28:27.046508
178	29	DUCHA COMPLETA	Pieza	85.00	Ducha económica	2025-05-31 20:28:27.046508
179	29	GRIFERIA LAVAMANOS	Pieza	65.00	Grifería cromada	2025-05-31 20:28:27.046508
180	29	TANQUE PLASTICO 1000 LTS	Pieza	450.00	Tanque de agua	2025-05-31 20:28:27.046508
181	29	BOMBA DE AGUA 1/2 HP	Pieza	680.00	Bomba centrífuga	2025-05-31 20:28:27.046508
182	28	CABLE THW #12	Metro	3.80	Cable eléctrico #12	2025-05-31 20:28:27.046508
183	28	CABLE THW #14	Metro	2.95	Cable eléctrico #14	2025-05-31 20:28:27.046508
184	28	TUBO EMT 1/2"	Metro	8.50	Tubo conduit metálico	2025-05-31 20:28:27.046508
185	28	INTERRUPTOR SIMPLE	Pieza	12.00	Interruptor común	2025-05-31 20:28:27.046508
186	28	TOMACORRIENTE DOBLE	Pieza	15.00	Tomacorriente polarizado	2025-05-31 20:28:27.046508
187	28	CAJA OCTOGONAL	Pieza	4.50	Caja para luminaria	2025-05-31 20:28:27.046508
188	28	TABLERO 12 CIRCUITOS	Pieza	185.00	Tablero de distribución	2025-05-31 20:28:27.046508
189	28	FLUORESCENTE 2x40W	Pieza	85.00	Luminaria fluorescente	2025-05-31 20:28:27.046508
190	1	CORRUGADO 1/4\\'\\' (6mm.) BAR 12 m.	Barra	16.89	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.362901
191	1	CORRUGADO 5/16\\'\\' (8 mm.) BAR 12 m.	Barra	28.66	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.396806
192	1	CORRUGADO 3/8\\'\\' (10 mm.) BAR 12 m.	Barra	45.55	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.413032
193	1	CORRUGADO 1/2\\'\\' (12 mm.) BAR 12 m.	Barra	69.17	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.430562
194	1	CORRUGADO 5/8\\'\\' (16 mm.) BAR 12 m.	Barra	123.18	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.454765
195	1	CORRUGADO 3/4\\'\\' (20 mm.) BAR 12 m.	Barra	192.35	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.471578
196	1	CORRUGADO 1\\'\\' (25 mm.) BAR 12 m.	Barra	310.45	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.487443
197	1	TUBULAR CUADRADO 15x15 mm	BARRA	37.39	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.502761
198	1	LISO 1/4\\'\\' (6mm.) BAR 12 m.	Barra	17.70	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.517477
199	1	LISO 5/16\\'\\' (6mm.) BAR 12 m.	Barra	28.82	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.533735
200	1	LISO 3/8\\'\\' (8mm.) BAR 12 m.	Barra	44.06	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.5497
201	1	LISO 1/2\\'\\' (10 mm.) BAR 12 m.	Barra	66.64	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.565568
202	1	LISO 5/8\\'\\' (12mm.) BAR 12 m.	Barra	117.25	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.580948
203	1	LISO 3/4\\'\\' (16 mm.) BAR 12 m.	Barra	185.31	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.595258
204	1	ANGULAR 3/4\\'\\'xl/8\\'\\' BAR 6 m.	Barra	39.99	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.610356
205	1	ANGULAR 1\\'\\' x 3/16\\'\\' BAR 6 m.	Barra	75.06	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.626239
206	1	ANGULAR1\\'\\'xl/8\\'\\' BAR 6 m.	Barra	54.17	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.644668
207	1	ANGULAR 11/4\\'\\'x 1/8\\'\\' BAR 6 m.	Barra	68.85	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.662599
208	1	ANGULAR 11/2\\'\\' x 1/8\\'\\' BAR 6 m.	Barra	82.64	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.679826
209	1	ANGULAR 1 1/2\\'\\'x 3/16\\'\\'BAR 6 m.	Barra	110.67	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.696264
210	1	ANGULAR 11/2\\'\\' x 1/4\\'\\' BAR 6 m.	Barra	149.33	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.713173
211	1	ANGULAR 2\\'\\' x 1/8\\'\\' BAR 6 m.	Barra	127.91	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.72892
212	1	ANGULAR 2\\'\\' x 3/16\\'\\' BAR 6 m.	Barra	151.48	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.744532
213	1	ANGULAR 2\\'\\' x 1/4\\'\\' BAR 6 m.	Barra	187.30	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.759844
214	1	ANGULAR 2 1/2\\'\\' x 3/16\\'\\' BAR 6 m.	Barra	211.93	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.777314
215	1	ANGULAR 2 1/2x 1/4\\'\\' BAR 6 m.	Barra	230.97	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.792697
216	1	ANGULAR 3\\'\\' x 1/4\\'\\' BAR 6 m.	Barra	283.77	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.808166
217	1	ANGULAR 3\\'\\' x 3/8\\'\\' BAR 6 m.	Barra	416.29	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.823799
218	1	TUBULAR CUADRADO 20x20	Barra	38.29	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.840233
219	1	TUBULAR CUADRADO 25x25	Barra	44.44	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.855761
220	1	TUBULAR CUADRADO 15x15	Barra	26.74	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.871617
221	1	TUBULAR CUADRADO 40x40	Barra	78.25	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.887066
222	1	TUBULAR REDONDO DE 19 mm.	Barra	25.30	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.902413
223	1	TUBULAR REDONDO DE 22 mm.	Barra	30.35	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.917882
224	1	TUBULAR REDONDO DE 25 mm.	Barra	36.07	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.933205
225	1	TUBULAR REDONDO DE 38 mm.	Barra	57.88	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.948552
226	1	TUBULAR REDONDO DE 50 mm.	Barra	71.55	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.964094
227	1	ALAMBRE GALVANIZADO #14	Kgr	19.44	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.979406
228	1	PLATINA 3/4\\'\\' x 1/8\\'\\'	Barra	22.80	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:13.994979
229	1	PLATINA l\\'\\'x l/8\\'\\'	Barra	30.69	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.010223
230	1	PLATINA 1\\'\\'x 3/16\\'\\'	Barra	44.00	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.028416
231	1	PLATINA l\\'\\'x l/4\\'\\'	Barra	53.49	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.044337
232	1	PLATINA 1/2\\'\\' x 3/16\\'\\'	Barra	50.30	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.059854
233	1	PLATINA 1/2\\'\\' x 1/8\\'\\'	Barra	46.06	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.075562
234	1	PLATINA1/2\\'\\' x 1/4\\'\\'	Barra	59.90	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.093219
235	1	PLATINA 2\\'\\' x 3/16\\'\\'	Barra	75.59	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.108576
236	1	PLATINA 2\\'\\' x 1/4\\'\\'	Barra	76.59	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.12588
237	1	PLATINA 2\\'\\'x 3/8\\'\\'	Barra	93.42	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.140317
238	1	PLATINA 11/4\\'\\' x 1/4\\'\\'	Barra	149.33	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.155928
239	1	PLATINA 3/4\\'\\' x 1/4\\'\\'	Barra	65.27	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.170313
240	1	PLATINA 21/2\\'\\' x 1/4\\'\\'	Barra	42.15	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.185596
241	1	PLATINA 21/2\\'\\' x 3/8\\'\\'	Barra	138.04	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.201622
242	1	PLATINA 3\\'\\'x l/4\\'\\'	Barra	160.26	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.217879
243	1	PLATINA 3\\'\\'x 3/8\\'\\'	Barra	239.35	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.233285
244	1	PERFIL TEE DE 1/8\\'\\'x1 1/4\\'\\'	Barra	76.36	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.248643
245	1	PERFIL TEE 1/8\\'\\'x3/4\\'\\'	Barra	43.07	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.26511
246	1	PERFIL TEE 1/8\\'\\'xl 1/2\\'\\'	Barra	89.56	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.280639
247	1	PERFILTEE 1/4\\'\\'x 2\\'\\'	Barra	235.19	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.296599
248	1	PERFILTEE 3/16\\'\\'x 11/4\\'\\'	Barra	111.19	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.312051
249	1	PERFILTEE 3/16\\'\\'x 11/2\\'\\'	Barra	137.69	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.327696
250	1	PERFIL P/VENTANA 3-2 (BARRA 6m.)	Barra	61.09	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.343256
251	1	PERFIL P/VENTANA 3-3 (BARRA 6m.)	Barra	58.03	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.359983
252	1	PERFIL P/VENTANA 3-4 (BARRA 6m.)	Barra	103.25	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.375239
253	1	PERFIL P/VENTANA 3-5 (BARRA 6m.)	Barra	96.38	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.391279
254	1	PERFIL P/VENTANA 3-6 (BARRA 6m.)	Barra	58.03	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.407401
255	1	PERFIL P/VENTANA 3-7 (BARRA 6m.)	Barra	103.25	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.42326
256	1	PERFIL P/VENTANA 4-2 (BARRA 6m.)	Barra	84.86	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.43856
257	1	PERFIL P/VENTANA 4 - 3 (BARRA 6m.)	Barra	107.01	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.456375
258	1	PERFIL P/VENTANA 5-2 (BARRA 6m.)	Barra	15.85	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:14.47193
259	15	PERFIL P/VENTANA 5-4 (BARRA 6m.)	Barra	24.13	Importado de archivo SQL - Categoría 15	2025-05-31 20:38:14.487184
260	2	CARPICOLA MONOPOL   env. 3.5 Lts.	GI.	96.14	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.502648
261	2	PARKETEX  env 18 Lts WILLIAMS	GI.	107.22	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.517929
262	2	PA.RKET EX SH. WILLIAWS	18 Lt.	502.78	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.533299
263	2	PEGA ALFOMBRA MONOPOL	Galón	136.82	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.548588
264	2	PEGA PARKET	12Kg.	290.35	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.564048
265	2	COLA FRESCA	Kgr.	11.32	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.579407
266	2	DURA COLA TIPO CARPICOLA SH.W.	GI.	113.57	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.595076
267	2	DURA COLA TIPO CARPICOLA SH.W.	18 Lt.	470.24	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.609298
268	2	CLEFABOL TIPO PEGA TODO SH.W.	GI.	158.08	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.624584
269	2	CLEFABOL TIPO PEGATODO SH.W.	18 Lt.	692.70	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.63996
270	2	PEGATUBO PARA PVC MONOPOL	GI.	364.08	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.654214
271	2	PEGA TODO  CLEFA MONOPOL	GI.	151.17	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.669711
272	2	PEGATODO (MONOPOL)	18 Lt.	705.22	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.701296
273	2	SIKADUR 31 ADHESIVO APOXICO	Kg.	248.03	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.716733
274	2	SIKADUR 32 PUENTE ADHERENCIA	1kgr.	471.86	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.732362
275	2	COLMAFIX 32 PUENTE ADHERENCIA	Kg.	467.32	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.748134
276	2	BINDA EXTRA IMPERMEABLE	Kg.	26.68	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.76346
277	2	BINDA PASTA BLANCA P/BASES FLEX.	25kg.	102.74	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.779517
278	2	BINDA PASTA IMPERMEABLE PARA SUPERFICIE FLEXIBLE	2Kg.	51.97	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.795139
279	2	BINDA CERAMICOS P/SUP. RIGIDAS	5Kg.	97.00	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.811514
280	2	FRAGUADOR BINDA BLANCO	2Kg.	72.37	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.82696
281	2	BINDA FRAGUADOR P/COLORES	2Kg.	68.70	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.841285
282	2	PEGAMENTO PARA VINIL	GI.	111.19	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.857426
283	2	EUXIT 220 ADHESIVO EPOXICO	Kg.	216.95	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.873924
284	2	ADIUNION RAP. PTE. DE ADHERENCIA	3Kg.	632.35	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.891344
285	2	ADIUNION RAP. PTE. DE ADHERENCIA	Kg.	417.06	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.906868
286	2	ADICERAMICO IMPERMEABLE	Kg.	14.15	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.92549
287	2	ADIPASTA IMPERMEABLE P/BASE	Kg.	56.17	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.941234
288	2	ADIFRAGUE EMBOQUILLADO COL.	Kg.	30.35	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.956362
289	2	ADISELLO ADHESIVO POLIURETANO	MI.	157.13	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.971906
290	2	FULLPARXET P/ PARKET (60 Kg.)	Pza.	1339.68	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:14.987712
291	2	FULL PARA ALFOMBRA (18 Lts.)	Pza.	588.33	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.003277
292	2	FULLER PARA ALFOMBRA (200 Lts)	Pza.	5850.79	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.018843
293	2	FULLCAÑERIA P/TUBOS PVC (18 Lts.)	Pza.	750.93	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.034306
294	2	FULLCAÑERIA P/TUBOS PVC (200 Lts.)	Pza.	7597.45	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.049754
295	2	FULLCOLA PARA MADERA(20 Kg.)	Pza.	643.50	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.065832
296	2	FULLCOLA PARA MADERA(60 Kg.)	Pza.	1735.44	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.082825
297	2	FULLCOLA PARA MADERA (200 Kg.)	Pza.	5786.61	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.09912
298	2	PEGAMENTO PVC P-14 PARABOND	1/2 Lt.	78.71	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.114585
299	2	PEGAMENTO PVC P-14 PARABOND	1 Lt.	132.63	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.130062
300	2	PEGAMENTO PVC P-14 PARABOND	GI.	472.24	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.173683
301	2	LIMPIADOR PVC Y PCVC	1 Lt.	93.42	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.194124
302	2	LIMPIADOR PVC V PCVC	GI.	307.02	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.20984
303	2	PEGAMENTO CPVC (Agua CaIiente)	1/8 Lt.	37.60	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.225467
304	2	PEGAMENTO CPVC (Agua Calient.)	1/4 Lt.	55.71	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.240914
305	2	PEGAMENTO CPVC (Agua CaIieuite)	1/2 Lt.	96.14	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.255244
306	2	PEGAMENTO CPVC (Agua Caliente)	1 Lt.	171.59	Importado de archivo SQL - Categoría 2	2025-05-31 20:38:15.270585
307	3	SIKA 4  A  IMPERMEABILIZANTE	Kg	40.13	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.28816
308	3	SIKA 1 IMPERMEABILIZANTE	5Kg.	153.57	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.304301
309	3	SIKA1 IMPERMEABILIZANTE	20Kg.	475.79	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.31977
310	3	SIKA 2 ACELERADOR ULTRA RAPIDO	6 Kg.	224.38	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.335233
311	3	SIKA 2 ACELERADOR ULTRA RAPIDO	1.3 Kg.	49.07	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.350801
312	3	SIKA 3 ACELERADOR CONTROLABLE	1.3 Kg.	47.92	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.36884
313	3	SIKA3ACELERADOR CONTROLABLE	25 Kg.	602.66	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.384562
314	3	SIKA 4-A ACELERADOR IMPERMEABILIZANTE	5Kg.	196.16	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.401269
315	3	PLASTIMENT BV-40 PLASTIFICANTE	20Kg.	858.08	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.416644
316	3	PLASTIMENT H-E PLASTIFICANTE	20Kg.	859.48	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.432609
317	3	PIASTIMENT H.E.R. PLASTIFICANTE RETARDADOR	20Kg.	770.05	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.448113
318	3	SIKAMENT FF.86 SUPER PLASTIFICANTE	20Kg.	1636.53	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.46373
319	3	SIKA LATEX ADHERENTE P/MORTERO	5Kgr.	213.75	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.482713
320	3	SIKACEM 810 REACTIVO P/MORTERO	3Kg.	286.82	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.498353
321	3	INTRAPLAST (0.85 Kg.)	Pza.	31.86	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.513867
322	3	LUBRICON Y PLASTIFIGANTE	Kg.	13.22	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.529879
323	3	LUBRICON PLASTIFICANTE RETARDADOR	Kg.	13.37	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.544325
324	3	MELMET L-10 SUPER FLUIDIFICANTE	Kg.	18.88	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.559858
325	3	RETOCURING AGENTE CURADO ANTISOL	Lt.	14.29	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.575242
326	3	LINOL 3 INCA ACELERADOR	Lt.	13.25	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.59067
327	3	ADIUNO IMPERMEABILIZANTE	0.90Kg.	32.42	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.606057
328	3	ADIUNO IMPERMEABILIZANTE	5Kg.	137.25	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.621496
329	3	ADIUNO IMPERMEABILIZANTE	10Kg.	224.38	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.636829
330	3	ADIRAPID	1.2Kg.	46.30	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.65306
331	3	ADIRAPID 201 ACELERADOR	20Kg.	442.71	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.66901
332	3	ADIPLAST 2 PLASTIFICANTE	20Kg.	764.32	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.68478
333	3	ADIPLAST 3 PLAST. RETARDADOR	20Kg.	686.20	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.706459
334	3	ADIPLAST 101	20Kg.	1435.12	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.774649
335	3	ADICRIL	1Kg.	191.00	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.828655
336	3	113.20 ADIEXPANSOR	0.85Kg.	28.19	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.844042
337	3	ADICUR MEMBRANA CURADO	Pza.	20.65	Importado de archivo SQL - Categoría 3	2025-05-31 20:38:15.859768
338	4	ADOQUIN COMANCHE	Pza.	4.41	Importado de archivo SQL - Categoría 4	2025-05-31 20:38:15.875216
339	5	PLANCHA TECNOPOR 100x50x1.5 cm.	M2	1.06	Importado de archivo SQL - Categoría 5	2025-05-31 20:38:15.892678
340	5	PLANCHA TECNOPOR l00x100xl.5 cm.	M2	2.18	Importado de archivo SQL - Categoría 5	2025-05-31 20:38:15.908731
341	5	PLANCHA TECNOPOR 200x100x1.5 cm.	M2	3.19	Importado de archivo SQL - Categoría 5	2025-05-31 20:38:15.929812
342	5	PLANCHA TECNOPOR 100x50x2.0 cm.	M2	4.23	Importado de archivo SQL - Categoría 5	2025-05-31 20:38:15.945335
343	5	PLANCHA TECNO. l00x100x2.0 cm.	M2	1.15	Importado de archivo SQL - Categoría 5	2025-05-31 20:38:15.960868
344	5	PLANCHA TECNO.200x100x2 cm.	M2	2.56	Importado de archivo SQL - Categoría 5	2025-05-31 20:38:15.97643
345	5	PLANCHA TECNO. l00x50x2.5 cm.	M2	3.71	Importado de archivo SQL - Categoría 5	2025-05-31 20:38:15.991843
346	5	PLANCHA TECNO. 100x100x2.5 cm.	M2	4.89	Importado de archivo SQL - Categoría 5	2025-05-31 20:38:16.007317
347	5	PLANCHA TECNO. 100x50x2.5 cm	M2	6.23	Importado de archivo SQL - Categoría 5	2025-05-31 20:38:16.022727
348	5	PLANCHA TECNO. 100x50x3.0 cm	M2	7.43	Importado de archivo SQL - Categoría 5	2025-05-31 20:38:16.038194
349	5	PLANCHA TECNO. 100x50x4.0 cm STD	Pza.	9.95	Importado de archivo SQL - Categoría 5	2025-05-31 20:38:16.053737
350	5	PLANCHA TECNO. l00x50x5.0 cm STD	Pza.	12.31	Importado de archivo SQL - Categoría 5	2025-05-31 20:38:16.068279
351	5	LANA DE VIDRIO 25 mm. ESPESOR	M2	30.87	Importado de archivo SQL - Categoría 5	2025-05-31 20:38:16.084104
352	6	CASETONES 50 x 50 x 16	Pza.	11.67	Importado de archivo SQL - Categoría 6	2025-05-31 20:38:16.0998
353	6	CASETONES 50 x 50 x 20	Pza.	14.52	Importado de archivo SQL - Categoría 6	2025-05-31 20:38:16.115237
354	6	CASETONES 40 x 40 x 25.	Pza.	22.55	Importado de archivo SQL - Categoría 6	2025-05-31 20:38:16.133189
355	6	CASETONES 40 x 40 x 16	Pza.	9.29	Importado de archivo SQL - Categoría 6	2025-05-31 20:38:16.148973
356	6	CASETONES 40 x 40 x 20	Pza.	12.31	Importado de archivo SQL - Categoría 6	2025-05-31 20:38:16.164472
357	6	PLASTOFORM TIRA 100x40x12 cm.	Pza.	18.57	Importado de archivo SQL - Categoría 6	2025-05-31 20:38:16.17989
358	6	PLASTOFORM TIRA 100x40x15 cm.	Pza.	22.99	Importado de archivo SQL - Categoría 6	2025-05-31 20:38:16.195751
359	6	PLASTOFORM TIRA 100x40x20 cm.	Pza.	30.87	Importado de archivo SQL - Categoría 6	2025-05-31 20:38:16.211056
360	6	PLASTOFORM TIRA 100x50x12 cm.	Pza.	23.07	Importado de archivo SQL - Categoría 6	2025-05-31 20:38:16.226969
361	6	PLASTOFORM TIRA 100x50x15 cm.	Pza.	28.82	Importado de archivo SQL - Categoría 6	2025-05-31 20:38:16.24336
362	6	PLASTOFORM TIRA 100x50x20 cm.	Pza.	38.64	Importado de archivo SQL - Categoría 6	2025-05-31 20:38:16.258754
363	7	ALAMBRE DE AMARRE	Kg.	10.63	Importado de archivo SQL - Categoría 7	2025-05-31 20:38:16.2745
364	7	ALAMBRE GALVANIZADO  # 8	Kg.	11.83	Importado de archivo SQL - Categoría 7	2025-05-31 20:38:16.29003
365	7	ALAMBRE GALVANIZADO #10	Kg.	12.48	Importado de archivo SQL - Categoría 7	2025-05-31 20:38:16.305905
366	7	ALAMBRE GALVANIZADO #12	Kg.	12.48	Importado de archivo SQL - Categoría 7	2025-05-31 20:38:16.321625
367	7	ALAMBRE GALVANIZADO  # 14	kgr.	4.52	Importado de archivo SQL - Categoría 7	2025-05-31 20:38:16.336714
368	7	ALAMBRE TEJIDO R/ 40 m.x 0.90	RoIIa	126.55	Importado de archivo SQL - Categoría 7	2025-05-31 20:38:16.352239
369	7	ALAMBRE DE PUAS GALV. (500 mts.)	Rollo	0.51	Importado de archivo SQL - Categoría 7	2025-05-31 20:38:16.367808
370	7	ALAMBRE OVALADO GALV. (1.000 mts.)	RoIIo	226.89	Importado de archivo SQL - Categoría 7	2025-05-31 20:38:16.384124
371	7	MALLA MILIMETRICA PLASTICO	M2.	17.58	Importado de archivo SQL - Categoría 7	2025-05-31 20:38:16.39962
372	7	MALLA MILIMETRICA PLAST. (500 m.)	RoIIo	552.21	Importado de archivo SQL - Categoría 7	2025-05-31 20:38:16.415082
373	8	ARENILLA	M3	83.00	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.430824
374	8	ARENA COMUN	M3.	66.00	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.446152
375	8	ARENA FINA	M3.	66.00	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.46223
376	8	RIPIO CHANCADO	M3.	121.49	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.478207
377	8	RIPIO LAVADO	M3.	126.55	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.49377
378	8	RIPIO BRUTO	M3.	112.23	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.509258
379	8	PIEDRA MANZANA	M3.	101.23	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.525407
380	8	PIEDRA PARA CIMIENTOS	M3.	101.23	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.540926
381	8	PIEDRA LAJA SIN CORTAR	M2.	47.23	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.556497
382	8	PIEDRA TARIJA SIN CORTAR	M2.	47.23	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.572014
383	8	PIEDRA TARIJA CORTADA Y PULIDA	M2.	185.56	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.587662
384	8	PIEDRA PIZARRA CORTADA Y PULIDA	 M2.	185.56	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.603099
385	8	PIEDRA PIZARRA CORTADA 15x15	M2.	111.01	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.618751
386	8	PIEDRA PIZARRA CORTADA 15x30	M2.	109.70	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.633243
387	8	PIEDRA PIZARRA CORTADA 20x20	M2.	118.11	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.649053
388	8	PIEDRA PIZARRA CORTADA 20x30	M2.	118.11	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.666184
389	8	PIEDRA PIZARRA CORTADA 30x30	M2.	134.98	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.682554
390	8	PIEDRA PIZARRA CORTADA 40.5x40.5	M2.	160.26	Importado de archivo SQL - Categoría 8	2025-05-31 20:38:16.702623
391	9	ALFOMBRA	M2.	150.25	Importado de archivo SQL - Categoría 9	2025-05-31 20:38:16.718267
392	9	ALFOMBRA NAL. (alto trafico)	M2.	164.27	Importado de archivo SQL - Categoría 9	2025-05-31 20:38:16.734988
393	9	ALFOMBRA NAL. (pelo alto)	M2.	271.06	Importado de archivo SQL - Categoría 9	2025-05-31 20:38:16.753737
394	9	ALFOMBRA NAL. (pelo bajo)	M2.	216.59	Importado de archivo SQL - Categoría 9	2025-05-31 20:38:16.769196
395	9	ALFOMBRA AMERICANA	M2.	281.56	Importado de archivo SQL - Categoría 9	2025-05-31 20:38:16.784689
396	9	ALFOMBRA TIPO PERSA (240x340 cm.)	Unid.	1637.03	Importado de archivo SQL - Categoría 9	2025-05-31 20:38:16.800645
397	9	ALFOMBRA TIPO PERSA (200x300 cm.)	Unid.	1200.51	Importado de archivo SQL - Categoría 9	2025-05-31 20:38:16.820629
398	9	TAPIZÓN	M2.	103.64	Importado de archivo SQL - Categoría 9	2025-05-31 20:38:16.837562
399	10	AZULEJO BLANCO NAL. 15x15	M2.	58.65	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:16.852928
400	10	AZULEJO COLOR NAL. 15x15	M2.	62.20	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:16.868592
401	10	AZULEJO DECORADO 15x15	M2.	63.94	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:16.884179
402	10	AZULEJO BLANCO BRAS. 15x15	M2.	71.03	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:16.899864
403	10	AZULEJO COLOR BRAS. 15x15	M2.	74.58	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:16.919958
404	10	AZULEJO DECORADO BRAS. 15x15	M2.	99.55	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:16.935072
405	10	AZULEJO DECORADO BRAS. 20x20	M2.	108.30	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:16.951645
406	10	AZULEJO DECORADO BRAS. 20x25	M2.	115.41	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:16.9713
407	10	AZULEJO ELIANE (ELITE) 15x15	M2.	90.40	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:16.988597
408	10	AZULEJO ELIANE BLANCO 15x15	M2.	86.48	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.005588
409	10	AZULEJO ELIANE AZUL 15x15	M2.	85.53	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.025139
410	10	AZULEJO ELIANE DECORADO 20x20	M2.	90.62	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.040841
411	10	AZULEJO ELIANE DECORADO 20x25	M2.	97.21	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.056695
412	10	AZULEJO ZANON ARG. 20x25	M2.	168.73	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.07294
413	10	AZULEJO ESPAÑOL PAMESA 31x45	M2.	242.93	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.090444
414	10	AZULEJO ESPAÑOL PAMESA 20x30	M2.	202.29	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.105881
415	10	AZULEJO ESPAÑOL PAMESA 20x20	M2.	153.37	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.12131
416	10	PISO CERAMICO ELIANE 20x20	M2.	127.39	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.136977
417	10	PISO CERAMICO ELIANE 13x26	M2.	93.79	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.152545
418	10	PISO CERAMICO ESPECIAL 25x25	M2.	159.93	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.168661
419	10	PISO CERAMICO GRANULADO 20x30	M2	153.57	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.18384
420	10	RANDA ELIANE FANCY BLACK 6.50x20	Pza.	28.93	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.199262
421	10	RANDAS ELIANE FIESTA GRAY 6.50x15	Pza.	4.82	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.214812
422	10	RANDAS ELIANE ARIES 10x20	Pza.	38.97	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.230034
423	10	RANDAS ELIANE PYXIS GREEN 7.50X20	Pza.	37.33	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.244301
424	10	RANDAS ZANON P/PISO 16x33	Pza.	29.33	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.259606
425	10	RANDAS ZANON P/PISO 16x16	Pza.	20.26	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.275435
426	10	RANDAS ZANON P/PARED 8x20, 10x25	Pza.	41.52	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.290936
427	10	RANDAS PAMESAP/PASO 10x31,14x28	Pza.	82.50	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.305275
428	10	RANDAS PAMESAP/PARED 9x31,10x45	Pza.	57.70	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.320663
429	10	RANDAS PAMESA P/PARED 7x20	Pza.	41.19	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.33606
430	10	RANDAS PAMESA P/PARED 20x20	Pza.	21.87	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.350251
431	10	REVESTIMIENTO CERAMICO NAL.	M2.	56.17	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.365847
432	10	ENCHAPE LADRILLO NACIONAL	M2.	46.75	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.381155
433	10	BALDOSA CERAM. SEMIGRES 15x15	M2.	49.76	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.397206
434	10	BALDOSA CERAM. ESM. DEC. 15x1 5	M2.	99.25	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.412594
435	10	BALDOSA CERAMICA ESMALT. 11x23	M2.	91.62	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.428025
436	10	CERAMICA ESMALTADA NAL. 20x30	M2.	98.91	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.443351
437	10	CERAMICA ESMALTADA BRAS.30x30	M2.	156.24	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.458898
438	10	CERAMICA ESMALTADA BRAS. 25x25	M2.	139.69	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.477385
439	10	CERAMICA ESMALTADA BRAS.20x20	M2.	146.42	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.493621
440	10	CERAMICA ESMALTADA BRAS. 20x30	M2.	123.82	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.510323
441	10	CERAM. KAISER PISCINA 23.50x11.50	M2.	93.79	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.527191
442	10	CERAMICA KAISER TRAD. 23.50x11.50	M2.	85.90	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.541341
443	10	CERAMICA KAISER DURA 23.50x11.50	M2.	98.19	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.556567
444	10	CERAMICA KAISER NATURAL ROJO	M2.	58.40	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.571663
445	10	CERAMICA KAISER NATURAL BEIGE	M2.	70.84	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.587355
446	10	REVEST. CAPRI - FINA 20x25	M2.	85.53	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.602665
447	10	REVEST. CAPRI - CLASICA 20x25	M2.	76.75	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.647055
448	10	REVEST. CAPRI - CLASICA 31x31	M2.	79.64	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.661241
449	10	REVEST. CAPRI - GRANITICO 20x25	M2.	91.62	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.676659
450	10	REVEST. CAPRI - GRANITICO 31x31	M2.	107.22	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.691717
451	10	REVEST. CAPRI - NATURAL 31x31	M2.	68.35	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.707294
452	10	CERAMICA ZANON LISA 20x20, 25x25	M2.	136.17	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.722388
453	10	CERAM. ZANON CORRUGADA 25x25	M2.	150.53	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.737535
454	10	CERAMICA ZANON ESPECIAL 33x33	M2.	189.62	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.752997
455	10	CERAMICA ZANON RUSTICA 33x33	M2.	198.54	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.771136
456	10	CERAMICA ESPAÑOLA PAMESA 31x31	M2.	190.81	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.786446
457	10	CERAMICA ESPAÑOLA PAMESA 42x42	M2.	252.74	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.802121
458	10	CERAMICA ESPAÑOLA PAMESA 50x50	M2.	210.56	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:17.817664
459	11	BOMBA DE AGUA 0.8 H.P. ITALIANA	Unid.	2603.71	Importado de archivo SQL - Categoría 11	2025-05-31 20:38:17.833242
460	11	BOMBA DE AGUA 1 H.P. ITALIANA	Unid.	3458.68	Importado de archivo SQL - Categoría 11	2025-05-31 20:38:17.848446
461	11	BOMBA DE AGUA 1.5 H.P. ITALIANA	Unid.	4840.83	Importado de archivo SQL - Categoría 11	2025-05-31 20:38:17.863631
462	11	BOMBA DE AGUA 2.2 H.P. ITALIANA	Unid.	5490.00	Importado de archivo SQL - Categoría 11	2025-05-31 20:38:17.878793
463	11	BOMBA DE AGUA 5.5 H.P. ITALIANA	Unid.	6750.71	Importado de archivo SQL - Categoría 11	2025-05-31 20:38:17.894156
464	11	BOMBA DE AGUA 7.5 H.P. ITALIANA	Unid.	8038.00	Importado de archivo SQL - Categoría 11	2025-05-31 20:38:17.909374
465	12	CALEFON A GAS 50 Lts.	Pza.	4121.50	Importado de archivo SQL - Categoría 12	2025-05-31 20:38:17.92457
466	12	CALEFON ELECTRICO 30 Gl.	Pza.	2849.57	Importado de archivo SQL - Categoría 12	2025-05-31 20:38:17.940291
467	12	CALEFON ELECTRICO 40 Gl.	Pza.	4184.09	Importado de archivo SQL - Categoría 12	2025-05-31 20:38:17.955765
468	12	CALEFON ELECTRICO 52 Gl.	Pza.	4310.88	Importado de archivo SQL - Categoría 12	2025-05-31 20:38:17.971191
469	13	CAÑERIA GALV. 1/2\\'\\' L=6m.	Pza.	96.38	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:17.986459
470	13	CAÑERIA GALV. 3/4\\'\\' L=6m.	Pza.	123.18	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.001689
471	13	CAÑERIA GALV. 1\\'\\' L= 6m.	Pza.	162.16	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.017019
472	13	CAÑERIA GALV. 1 1/4\\'\\' L= 6m.	Pz.a.	204.83	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.032992
473	13	CAÑERIA GALV. 1 1/2\\'\\'L=6 m.	Pm	263.17	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.048992
474	13	CAÑERIA GALVAN. 2\\'\\' L=6 m.	Pza.	352.61	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.064888
475	13	CAÑERIA GALVAN. 3\\'\\' L=6 m.	Pza.	725.15	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.080625
476	13	CAÑERIA GALVAN. 4\\'\\' L=6m	Pza.	1049.47	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.095951
477	13	CAÑERIA GALVANIZADA DE 1/2\\'\\'	MI.	18.57	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.111387
478	13	CAÑERIA GALVANIZADA DE 3/4\\'\\'	MI.	21.09	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.126709
479	13	CAÑERIA GALVANIZADA DE 1\\'\\'	MI.	27.85	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.141903
480	13	CODO GALVANIZADO 1/2\\'\\'	Pza.	17.58	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.157116
481	13	CODO GALVANIZADO 3/4\\'\\'	Pza.	9.95	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.172353
482	13	CODO GALVANIZADO 1\\'\\'	Pza.	13.15	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.187591
483	13	CODO GALVANIZADO 1 1/4\\'\\'	Pm.	25.99	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.202815
484	13	CODO GALVANIZADO 1 1/2\\'\\'	Pza.	29.48	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.218362
485	13	CODO GALVANIZADO 2\\'\\'	Pza.	43.68	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.233579
486	13	CODO GALVANIZADO 2 1/2\\'\\'	Pza	64.78	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.248718
487	13	CODO GALVANIZADO 3\\'\\'	Pza.	145.09	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.264035
488	13	CODO GALVANIZADO 4\\'\\'	Pza.	218.04	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.279593
489	13	COPLA GALVANIZADA 1/2\\'\\'	Pza.	5.33	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.295218
490	13	COPLA GALVANIZADA 3/4\\'\\'	Pza.	6.05	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.310507
491	13	COPLA GALVANIZADA 1\\'\\'	Pza.	8.03	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.325655
492	13	COPLA GALVANIZADA 1 1/4\\'\\'	Pza.	13.15	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.340835
493	13	COPLA GALVANIZADA 1 1/2\\'\\'	Pza.	17.58	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.35594
494	13	COPLA GALVANIZADA 2\\'\\'	Pza.	26.51	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.371075
495	13	COPLA GALVANIZADA 2 1/2\\'\\'	Pza.	59.70	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.386453
496	13	COPLA GALVANIZADA 3\\'\\'	Pza	148.51	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.40902
497	13	COPLA GALVAMZADA 4\\'\\'	Pza.	270.45	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.42504
498	13	TEE GALVANIZADA 1/2\\'\\'	Pza.	11.46	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.442064
499	13	TEE GALVANIZADA 3/4\\'\\'	Pza.	13.98	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.459135
500	13	TEE GALVANIZADA 1\\'\\'	Pza.	22.69	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.474479
501	13	TEE GALVANIZADA 1 1/4\\'\\'	Pza.	34.93	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.489779
502	13	TEE GALVANIZADA 1 1/2\\'\\'	Pza.	40.13	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.505235
503	13	TEE GALVANIZADA 2\\'\\'	Pza.	49.76	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.520587
504	13	TEE GALVANIZADA 2 1/2\\'\\'	Pza.	130.61	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.535841
505	13	TEE GALVANIZADA 3\\'\\'	Pza.	174.96	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.551198
506	13	TEE GALVANIZADA 4\\'\\'	Pza.	270.45	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.566579
507	13	CRUZ GALVANIZADA 1/2\\'\\'	Pza.	12.31	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.581947
508	13	CRUZ GALVANIZADA 3/4\\'\\'	Pza.	21.40	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.59914
509	13	CRUZ GALVANIZADA 1\\'\\'	Pza.	29.89	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.615758
510	13	CRUZ GALVANIZADA 1 1/4\\'\\'	Pza.	43.87	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.638979
511	13	CRUZ GALVANIZADA 1 1/2\\'\\'	Pza	52.54	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.65443
512	13	CRUZ GALVANIZADA 2\\'\\'	Pza.	70.00	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.669736
513	13	CRUZ GALVANIZADA 2 1/2\\'\\'	Pza.	139.85	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.685429
514	13	CRUZ GALVANIZADA 3\\'\\'	Pza.	183.38	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.700994
515	13	CRUZ GALVANIZAOA 4\\'\\'	Pza.	279.87	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.717008
516	13	NIPLE HEXAGONAL GALV. 1/2\\'\\'	Pza.	6.30	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.733561
517	13	NIPLE HEXAGONAL GALV. 3/4\\'\\'	Pza.	7.19	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.748886
518	13	NIPLE HEXAGONAL GALV. 1\\'\\'	Pza.	10.63	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.764032
519	13	NIPLE HEXAGONAL GALV. 1 1/4\\'\\'	Pza.	13.98	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.77958
520	13	NIPLE HEXAGONAL GALV. 1 1/2\\'\\'	Pza.	20.95	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.794883
521	13	NIPLE HEXAGONAL GALV. 2\\'\\'	Pza.	27.99	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.810108
522	13	NIPLE HEXAGONAL GALV. 2 1/2\\'\\'	Pza.	38.38	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.825393
523	13	NIPLE HEXAGONAL GALV. 3\\'\\'	Pza.	80.15	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.840763
524	13	NIPLE HEXAGONAL GALV. 4\\'\\'	Pza.	87.89	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.85733
525	13	UNION UNIVERSAL GALV. 1/2\\'\\'	Pza.	14.85	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.872562
526	13	UNION UNIVERSAL GALV. 3/4\\'\\'	Pza.	18.38	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.887998
527	13	UNION UNIVERSAL GALV. 1\\'\\'	Pza.	20.95	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.903185
528	13	UNION UNIVERSAL GALV. 1 1/4\\'\\'	Pza.	42.72	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.918705
529	13	UNION UNIVERSAL GALV. 1 1/2\\'\\'	Pza.	48.72	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.933918
530	13	UNION UNIVERSAL GALV. 2\\'\\'	Pza.	70.00	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.949005
531	13	UNION UNIVERSAL GALV. 2 1/2\\'\\'	Pza.	125.51	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.964347
532	13	UNION UNIVERSAL GALV. 3\\'\\'	Pza.	171.09	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.980014
533	13	UNION UNIVERSAL GALV 4\\'\\'	Pza.	366.56	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:18.995588
534	13	REDUCCION GALVANIZADA 3/4\\'\\'-1/2\\'\\'	Pza.	13.98	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.012141
535	13	REDUCCION GALVANIZADA 1\\'\\'-1/2\\'\\'	Pza.	12.31	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.027401
536	13	REDUCCION GALVANIZADA 1\\'\\'- 3/4\\'\\'	Pza.	8.86	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.042463
537	13	REDUCCION GALVANIZADA 1 1/4\\'\\'-1\\'\\'	Pza.	12.31	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.057582
538	13	REDUCCION GALVANIZAOA 1 1/2\\'\\'-1\\'\\'	Pza.	15.85	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.072993
539	13	REDUCCION GALVANIZAOA 2\\'\\'- 1\\'\\'	Pza.	20.95	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.088137
540	13	LLAVE DE PASO CORTINA 1/2\\'\\' Galv.	Pza.	42.01	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.103518
541	13	LLAVE DE PASO CORTINA 3/4\\'\\' Galv.	Pza.	47.23	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.119014
542	13	LLAVE DE PASO CORTINA 1\\'\\' Galv.	Pza.	61.09	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.134455
543	13	LLAVE DE PASO CORTINA 2\\'\\' Galv.	Pza.	145.09	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.149788
544	13	LLAVE DE PASO GLOBO 1/2\\'\\' Galv.	Pza.	32.42	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.16506
545	13	LLAVE DE PASO GLOBO 3/4\\'\\' Galv.	Pza	34.07	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.180213
546	13	LLAVE DE PASO GLOBO 1\\'\\' Galv	Pza	70.00	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.195427
547	13	LLAVE DE PASO GLOBO 2\\'\\'	Pza	139.85	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.210684
548	13	CODO DE BRONCE 1/2\\'\\'	Pza	7.60	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.225932
549	13	CODO DE BRONCE 3/4\\'\\'	Pza.	16.89	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.241128
550	13	TEE DE COBRE 1/2\\'\\'	Pza.	8.41	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.256828
551	13	TEE DE COBRE 3/4\\'\\'	Pza.	20.26	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.272235
552	13	TERMINAL ROSCA INT. COBRE DE 1/2\\'\\'	Pza.	10.08	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.287598
553	13	TERMINAL ROSCA INT. COBRE DE 3/4\\'\\'	Pza.	18.57	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.303206
554	13	CODO TERMIN. ROSCA INT. COBRE 1/2\\'\\'	Pza.	14.36	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.318375
555	13	CODO TERMIN. ROSCA INT. COBRE 3/4\\'\\'	Pza.	25.30	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.33351
556	13	UNION UNIVERSAL COBRE DE 1/2\\'\\'	Pza.	25.30	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.348628
557	13	UNION UNIVERSAL COBRE DE 3/4\\'\\'	Pza.	42.15	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.36385
558	13	LLAVE DE PASO CORTINA COBRE DE 1/2\\'\\'	Pza.	101.23	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.379245
559	13	LLAVE DE PASO CORTINA COBRE DE 3/4\\'\\'	Pza.	189.01	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.394816
560	13	CANERIA DE COBRE DE 3/8	MI	227.79	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.410141
561	13	CAÑERIA DE COBRE DE 1/2	MI	315.50	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.425429
562	13	CAÑERIA DE COBRE DE 3/4	MI	421.79	Importado de archivo SQL - Categoría 13	2025-05-31 20:38:19.440537
563	14	CAMARA SEPTICA DE 500 Lt	Pza	1115.23	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:19.456755
564	15	BOX DE DUCHA (en L)	M2	2185.57	Importado de archivo SQL - Categoría 15	2025-05-31 20:38:19.471998
565	15	BOX TINA EN \\'\\'L\\'\\' 1.50x0.70x1.50	Pza	2478.03	Importado de archivo SQL - Categoría 15	2025-05-31 20:38:19.487324
566	15	VENTANA CORREDIZA DE 1.0x1.20  2 hojas	Pza.	1061.07	Importado de archivo SQL - Categoría 15	2025-05-31 20:38:19.503972
567	15	VENTANA CORREDIZA DE 2.00x1.20  3 hojas	Pza.	1752.92	Importado de archivo SQL - Categoría 15	2025-05-31 20:38:19.519589
568	15	VENTANA CORREDIZA DE 3.00x1.20  4 hojas	Pza.	2407.92	Importado de archivo SQL - Categoría 15	2025-05-31 20:38:19.535634
569	15	PUERTA CORREDIZA DE 2.40x2.00  c/vidrio	Pza.	4855.44	Importado de archivo SQL - Categoría 15	2025-05-31 20:38:19.556219
570	16	CEMENTO BLANCO TOLTECA	Bolsa	271.62	Importado de archivo SQL - Categoría 16	2025-05-31 20:38:19.573595
571	17	LOSETA DISEÑADA l00xl00x2.5 cm.	M2.	38.64	Importado de archivo SQL - Categoría 17	2025-05-31 20:38:19.588814
572	17	LOSETA ACUSTICA  material	M2.	38.64	Importado de archivo SQL - Categoría 17	2025-05-31 20:38:19.604164
573	17	LOSETA MOLDEADA  material	Pza.	12.83	Importado de archivo SQL - Categoría 17	2025-05-31 20:38:19.620096
574	17	LOSETAS TEXPOR Y REVIPOR  MATERIAL	Pza.	48.90	Importado de archivo SQL - Categoría 17	2025-05-31 20:38:19.640696
575	18	CLAVOS	Kg.	10.39	Importado de archivo SQL - Categoría 18	2025-05-31 20:38:19.655903
576	18	CLAVOS DE HIERRO DE 4\\'\\'	Kg.	10.58	Importado de archivo SQL - Categoría 18	2025-05-31 20:38:19.673574
577	18	CLAVOS DE HIERRO DE 3\\'\\'	Kg.	10.58	Importado de archivo SQL - Categoría 18	2025-05-31 20:38:19.688847
578	18	CLAVOS PARA CALAMINA 2 1/2	Kg.	20.47	Importado de archivo SQL - Categoría 18	2025-05-31 20:38:19.703367
579	19	PLACA ONDUL. DURALIT 2.44x1.08 m.	Placa	164.00	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.718835
580	19	PLACA ONDUL. DURALIT 1.83x1.08 m.	Placa	122.51	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.734698
581	19	PLACA ONDULADA DURALIT	M2.	63.80	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.749894
582	19	ONDINA DE DURALIT 2.44x0.50m.	Placa	55.00	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.765214
583	19	ONDINA DE DURALIT 1 .83x0.50m.	Placa	41.52	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.782394
584	19	ONDINA DE DURALIT	M2.	45.93	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.797868
585	19	TEJA ESPAÑOLA DURALIT 1.60x1.05m.	Placa	154.08	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.814398
586	19	TEJA ESPAÑOLA DURALIT 0.70 x l.05m.	Placa	85.05	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.829616
587	19	TEJA ESPAÑOLA DURALIT	M2.	98.51	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.845831
588	19	PLACA CANALIT 91- 7.50x1.00	Placa	889.65	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.860974
589	19	PLACA CANALIT 91- 6.50x1.00	Plac	702.74	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.876527
590	19	CANALIT 91	M2.	117.25	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.892481
591	19	CALAMINA ONDULADA No. 28  300x80	M2.	32.58	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.907805
592	19	CALAMINA ONDULADA No. 28  245x80	Unid	37.95	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.922882
593	19	CALAMINA ONDULADA No.28  215x80	Unid	46.69	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.93821
594	19	CALAMINA ONDULADA No. 28  180x80	Unid	54.93	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.954988
595	19	CALAMINA ONDULADA No. 28  300x90	Unid	62.91	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.970269
596	19	CALAMINA ONDULADA No.28  245x90	Unid	78.69	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:19.987215
597	19	CALAMINA ONDULADA No. 28  215x90	M2.	28.75	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.002557
598	19	CALAMINA ONDULADA No.28  180x90	Unid	46.97	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.017727
599	19	CALAMINA ONDULADA No. 32  245x90	Unid	55.43	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.033143
600	19	CALAMINA ONDULADA No. 32  215x90	Unid	62.72	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.048243
601	19	CALAMINA ONDULADA No. 32  180x90	M2.	46.61	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.064635
602	19	CALAMINA PLANA  No 26 (2x1)	Unid	67.05	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.079909
603	19	CALAMINA PLANA  No  28   2x1	Unid	79.36	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.095051
604	19	CALAMINA PLANA  No 30	Unid	89.93	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.109261
605	19	CALAMINA ONDULADA  No 9  180x80	Unid	111.05	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.124424
606	19	CALAMINA ONDULADA No 9  240x80	M2.	41.40	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.140067
607	19	CALAMINA ONDULADA No 9  300x80	Unid	82.83	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.155409
608	19	CALAMINA ONDULADA No 9  180x90	M2.	46.77	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.171876
609	19	CALAMINA ONDULADA No 9  240x90	Unid	93.55	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.18712
610	19	CALAMINA ONDULADA No 9  300x90	M2.	52.37	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.203431
611	19	CALAMINA ONDULADA   200x90	Unid.	104.76	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.219312
612	19	CALAM. OND. PLAST. No.12 1.80x0.80	Pza	124.18	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.234562
613	19	CALAM. OND. PLAST. No. 12 2.40x0.80	Pza	160.44	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.24997
614	19	CALAM. OND. PLAST. No. 12 3.00x0.80	Pza	196.03	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.266216
615	19	CALAM. OND. PLASTICA No. 12	M2.	81.34	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.284164
616	19	CALAM. OND. PLAST. No. 16 1.80x0.80	Pza.	159.93	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.304334
617	19	CALAM. OND. PLAST. No. 16 2.40x0.80	Pza	204.98	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.322778
618	19	CALAM. OND. PLAST. No. 16 3.00x0.80	Pza	260.50	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.338445
619	19	CALAM. OND. PLAST. No. 16	M2.	108.27	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.353698
620	19	PLACA FRANC. ONDULINE 2.00x0.97	Placa	120.80	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.368753
621	19	PLACA FRANCESA ONDULINE	M2.	63.94	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.383872
622	19	CUMBRERA ONDULINE O.90x0.40	Pza.	74.51	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:20.398903
623	20	DOMO PIRAMIDAL 0.40x0.21	Pza.	143.24	Importado de archivo SQL - Categoría 20	2025-05-31 20:38:20.413787
624	20	DOMO PIRAMIDAL 0.61x0.61	Pza.	560.98	Importado de archivo SQL - Categoría 20	2025-05-31 20:38:20.429529
625	20	DOMO PIRAMIDAL 1.00xl.00	Pza	1456.03	Importado de archivo SQL - Categoría 20	2025-05-31 20:38:20.444294
626	20	DOMO PIRAMIDAL 1.22x1.22	Pza.	1718.93	Importado de archivo SQL - Categoría 20	2025-05-31 20:38:20.459495
627	20	DOMO PIRAMIDAL 180xl.80	Pza.	2250.61	Importado de archivo SQL - Categoría 20	2025-05-31 20:38:20.474657
628	20	DOMO REDONDO DIAMETRO 0.45	Pza.	428.89	Importado de archivo SQL - Categoría 20	2025-05-31 20:38:20.48976
629	20	DOMO REDONDO DIAMETRO 0.60	Pza.	571.64	Importado de archivo SQL - Categoría 20	2025-05-31 20:38:20.504912
630	21	ESTUCO BEDOYA	Kg.	0.69	Importado de archivo SQL - Categoría 21	2025-05-31 20:38:20.519902
631	21	ESTUCO BEDOYA 36 Kg.	Bolsa	21.09	Importado de archivo SQL - Categoría 21	2025-05-31 20:38:20.536428
632	21	ESTUCO PANDO	Kg.	0.51	Importado de archivo SQL - Categoría 21	2025-05-31 20:38:20.551529
633	21	ESTUCO PANDO 18 Kg.	Bolsa	7.60	Importado de archivo SQL - Categoría 21	2025-05-31 20:38:20.56662
634	21	CAL P/REVOQUE (la calera env. 11 kgr	bolsa	0.61	Importado de archivo SQL - Categoría 21	2025-05-31 20:38:20.583851
635	21	CAL P/BLANQUEO ( la calera env. 10kgr.)	Bolsa	12.67	Importado de archivo SQL - Categoría 21	2025-05-31 20:38:20.599173
636	21	YESO COBOCE 30 Kg.	Bolsa	16.58	Importado de archivo SQL - Categoría 21	2025-05-31 20:38:20.614415
637	21	CAL LA CALERA 9 kg.	Bolsa	13.51	Importado de archivo SQL - Categoría 21	2025-05-31 20:38:20.632314
638	22	TIRAFONDOS DE 5 1/2x1/4	Pza.	2.06	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.647767
639	22	TIRAFONDOS DE 4 1/2x1/4	Pza.	2.00	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.662978
640	22	TIRAFONDOS DE 4x1/4	Pza.	2.00	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.678274
641	22	GANCHOS \\'\\'J\\'\\' DE 150 mm.	Pu.	2.33	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.693607
642	22	GANCHOS \\'\\'J\\'\\' DE 120 mm.	Pza.	202.47	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.709029
643	22	GANCHOS \\'\\'J\\'\\' DE 100 mm.	Pza.	202.47	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.724242
644	22	GANCHOS PARATEJA  60-80	Pza.	202.47	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.739551
645	22	GANCHOS DE 14 cm.	Pza.	253.10	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.754943
646	22	GANCHOS DE 10 cm.	Pza.	2.56	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.773425
647	22	AMARRE	Pza.	2.00	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.788856
648	22	TORNILLO DE FIJACION	Pza.	11.97	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.804301
649	22	CANCAMO	Pza.	2.00	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.819817
650	22	FIJADOR DE ALA AUTOTRABANTE	Pza.	2.43	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.835576
651	22	FIJADOR DE ALA SIMPLE	Pza.	4.70	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.853379
652	22	TORNILLO P/MADERA 1/2\\'\\'x2\\'\\'	Doc.	1.25	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.86865
653	22	TORNILLO P/MADERA 1/2\\'\\'x3\\'\\'	Doc.	1.49	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.883919
654	22	TORNILLO P/MADERA 1/2\\'\\'x4\\'\\'	Doc.	1.49	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.899466
655	22	TORNILLO P/MADERA 5  1/8\\'\\'x3\\'\\'	Doc.	1.61	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.914747
656	22	TORNILLO P/MADERA 5/8\\'\\'x5\\'\\'	Doc.	2.00	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.930142
657	22	TORNILLO P/MADERA 3  1/ 4\\'\\'x4\\'\\'	Doc.	2.56	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:20.945607
658	23	GAVION S/DIAGRAMA  2x1x0.5	Pza.	456.06	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:20.961167
659	23	GAVIONES C/DIAGRAMA  2x1x0.5	Pza.	324.57	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:20.976681
660	23	GAVION S/DIAGRAMA  2x1x1.0	Pza.	352.47	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:20.991169
661	23	GAVION C/DIAGRAMA  2x1x1.0	Pza.	456.06	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.005298
662	23	GAVION S/DIAGRAMA 3x1x0.5	Pza.	374.92	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.020592
663	23	GAVION C/DIAGRAMA  3x1x1	Pza.	506.48	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.035806
664	23	GAVION C/DIAGRAMA  4x1x0.5	Pza.	405.60	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.050952
665	23	GAVION S/DIAGRAMA  4x1x1	Pza.	506.48	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.066707
666	23	GAVION C/DIAGRAMA  4x1x0.5 (PVC)	Pza.	713.36	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.084556
667	23	COLCHONETA 4x2x0.17	Pza.	796.35	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.1001
668	23	COLCHONETA 4x2x0.23	Pza.	1020.77	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.115674
669	23	COLCHONETA  4x2x0.30	Pza.	1203.32	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.206544
670	23	COLCHONETA RENO MA. 4x2x0.23	Pza.	920.36	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.221774
671	23	COLCHONETA RENO MA. 5x2x0.23	Pza.	1131.76	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.237334
672	23	COLCHONETA RENO MA. 6x2x0.23	Pza.	1552.72	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.260228
673	23	COLCHONETA RENO MA. 4x2x0.30	Pza.	1003.01	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.275619
674	23	COLCHONETA RENO MA. 5x2x0.30	Pza.	1026.67	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.290722
675	23	COLCHONETA RENO MA. 6x2x0.30	Pza.	1436.30	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.30596
676	23	PRECIO FABRICA ORURO GAVION CORINSA 2x1x1/CD malla 8xl0	Pza.	296.07	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.321073
677	23	PRECIO FABRICA ORURO GAVION CORINSA 2x1x1/CD malla 10x12	Pza.	230.28	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.33621
678	23	PRECIO FABRICA ORUROCOLCHONETA CORINSA 4x2x0,23 malla 6x8 cm.	Pza.	568.29	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.353694
679	23	MALLA 6x8 CM.	Pza.	552.73	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:21.369568
680	24	MEZCLADORA P/ LAVA MANOS BRAS.	Pza.	323.45	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.389565
681	24	MEZCLADORA P/BIDETT BRAS.	Pza.	314.31	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.404689
682	24	MEZCLADORA P/ LAVA PLATOS BRAS.	Pza.	376.62	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.420097
683	24	MEZCLADORA P/TINA BRAS.	Pza.	626.42	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.436828
684	24	MEZCLADORA PARA LAVAMANOS	Pza.	440.15	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.452398
685	24	MEZCLADQRA P / BIDETT  F.V. CROMO	Pza.	552.54	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.471338
686	24	MEZCLADQR Y TRANSFERENCIA	Pza.	326.81	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.487037
687	24	MEZCLADORA TINA/DUCHA ITAL.	Pza.	436.29	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.502507
688	24	MEZCLADORA P/ BIDETT ITALIANO	Pz.a.	379.64	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.517954
689	24	MEZCLADORA P/ LAVAMANO ITAL.	Pza.	326.81	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.532243
690	24	MEZCLADORA LAVAPLATO	Pza.	305.87	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.547654
691	24	GRIFO DE 1/2\\'\\' CROMADO	Pza.	35.90	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.562848
692	24	GRIFO DE 1/2\\'\\' MOV1L CROMADO	Pza.	95.15	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.579531
693	24	GRIFERIA PARA LAVARROPA	Pza.	116.73	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.595309
694	24	MEZCLADORA P/ LAVAMANOS F.V. GALA	Jgo.	1288.66	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.610619
695	24	MEZCLADORA P/ BIDETT F.V. GALA	Jgo.	1394.82	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.626373
696	24	MEZCLADORA P/DUCHA F.V. GALA	Jgo.	1254.26	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.641676
697	24	MEZCLADORA P/LAVAMANOS F.V. ROJO	Jgo.	1279.72	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.657132
698	24	MEZCLADORA P/ BIDETT F.V. ROJO	Jgo.	1468.69	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.671249
699	24	MEZCLADORA P/TINA F.V. GALA	Jgo.	1788.38	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.68644
700	24	MONOMANDO FELIU MEZC. CROMO P/LAVABO	Pza.	614.31	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.701762
701	24	MONOMANDO FELIU MEZC. CROMO P/BIDETT	Pza.	643.14	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.717239
702	24	MONOMANDO FELIU MEZC. CROMO P/TINA- DUCHA	Pza.	975.36	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.732552
703	24	MONOMANDO FELIU MEZC. CROMO P/LAVAPLATOS	Pza.	1040.68	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.748165
704	24	MONOMANDO FELIU MEZC. CROMO ORO P/LAVABO	Pza.	811.39	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.763517
705	24	MONOMANDO FELIU MEZC. CROMO ORO P/BIDETT	Pza.	843.95	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.779018
706	24	MONOMANDO FELIU MEZC. CROMO ORO P/TINA-DUCHA	Pza.	1228.60	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.794375
707	24	MONOMANDO FELIU MEZC. CROMO CRO P/LAVABO	Pza.	1318.74	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.80966
708	24	MONOMANDO FELIU MEZCLADORAP/LAVAMANO NICOLAZZI	Pza.	614.14	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.824896
709	24	MONOMANDO FELIU MEZCLADORA P/DUCHA NICOLAZZI Pza.	Pza.	624.25	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.840477
710	24	MONOMANDO FELIU MEZCLADORA P/TINA-DUCHA NICOLAZZI	Pza.	659.41	Importado de archivo SQL - Categoría 24	2025-05-31 20:38:21.855884
711	25	PALA	Pza.	48.61	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:21.877302
712	25	PICOTA	Pza.	55.71	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:21.892451
713	25	CARRETILLA CON NEUMATICO	Pza.	391.26	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:21.907659
714	25	VADILEJO	Pza.	16.07	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:21.92297
715	25	MARTILLO MEDIANO	Pza.	51.13	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:21.938328
716	25	CIERRA METALICA	Pza.	49.43	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:21.953986
717	25	PLANCHA PARA ALBAÑILERIA	Pza.	46.06	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:21.969222
718	25	BALDE PARA ALBAÑILERIA	Pza.	12.99	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:21.984709
719	25	NIVEL DE MANO	Pza.	44.38	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:22.001306
720	25	COMBO DE 2 Kg.	Pza.	11.32	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:22.01673
721	25	ZINZEL MEDIANO	Pza.	16.48	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:22.031835
722	25	CORTADOR DE PISO Y AZULEJO (fermant)	Pza	558.99	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:22.047486
723	25	PLOMADA	Pza.	42.87	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:22.062896
724	26	TEP-PLASTA ASFALCHILE	18 Kg.	795.54	Importado de archivo SQL - Categoría 26	2025-05-31 20:38:22.077604
725	26	TEP- LIQUIDO ASFALCHILE	18 Kg.	795.54	Importado de archivo SQL - Categoría 26	2025-05-31 20:38:22.092987
726	26	TEP-DENSO ASFALCHILE	18 Kg.	795.54	Importado de archivo SQL - Categoría 26	2025-05-31 20:38:22.113397
727	26	SIKA TOP 107 GRIS (ENV. 25 Kg.)	Pza.	1021.79	Importado de archivo SQL - Categoría 26	2025-05-31 20:38:22.12973
728	26	SIKA TOP 1O7 BLANCO (ENV. 25 Kg.)	Pza.	996.13	Importado de archivo SQL - Categoría 26	2025-05-31 20:38:22.148044
729	26	IGOL PRIMER (ENV. 17 Kg.) SUPERFICIAL	Pza.	1112.86	Importado de archivo SQL - Categoría 26	2025-05-31 20:38:22.163525
730	26	IGOL DENSO (ENV. 17 Kg.) SUPERFICIAL	Pza.	1112.86	Importado de archivo SQL - Categoría 26	2025-05-31 20:38:22.178604
731	26	IGOL TECHO (ENV. 17 Kg.) SUPERFICIAL	Pza.	1605.70	Importado de archivo SQL - Categoría 26	2025-05-31 20:38:22.194091
732	26	IGOL INCOLORO )ENV. 15 Kgr.) FACHADA	10 Kg.	597.45	Importado de archivo SQL - Categoría 26	2025-05-31 20:38:22.209359
733	27	SIKA TOP 107 SEAL REVEST. RIGIDO UNITOP 620 REVEST. P / FACHADAS (21 Kg.)	Pza.	701.03	Importado de archivo SQL - Categoría 27	2025-05-31 20:38:22.224505
734	27	IGOL PRIMER IMPRIMANTE ASFALTICO 10 Kg.	Pza.	671.31	Importado de archivo SQL - Categoría 27	2025-05-31 20:38:22.239788
735	27	IGOL DENSO PINTURA ASFALTICA PARA TANQUES	10Kg.	688.36	Importado de archivo SQL - Categoría 27	2025-05-31 20:38:22.255222
736	27	IGOL TECHO MASA ASFALTICA P/LOSA Kg.	Kg.	94.47	Importado de archivo SQL - Categoría 27	2025-05-31 20:38:22.270806
737	27	SEAPLEZ IMPERMEAB. FLEXIBLE	Jgo	850.17	Importado de archivo SQL - Categoría 27	2025-05-31 20:38:22.286267
738	27	IGOL INCOLORO IMPERMEABILIZANTE PARA FACHADA 0.80 Kg.	Pza.	81.01	Importado de archivo SQL - Categoría 27	2025-05-31 20:38:22.302073
739	27	MEMO. GEOTEXTIL ALUMINIO 3.5 mm.	M2.	88.04	Importado de archivo SQL - Categoría 27	2025-05-31 20:38:22.317446
740	27	MEMO. GEOTEXTIL S / ALUMINIO 3.5 mm.	M2.	83.35	Importado de archivo SQL - Categoría 27	2025-05-31 20:38:22.332895
741	27	MEBR. ASFALT. MINERALIZADA 4mm.	M2.	106.54	Importado de archivo SQL - Categoría 27	2025-05-31 20:38:22.348552
742	27	MEBR. ASF. POLIETILENO ALUM. 3.5 mm.	M2.	83.53	Importado de archivo SQL - Categoría 27	2025-05-31 20:38:22.363844
743	27	MEBR. ASFALTICA ALUMINIO 3.5 mm.	M2.	71.03	Importado de archivo SQL - Categoría 27	2025-05-31 20:38:22.378361
744	28	ALAMB.Cu. AISL MONO.USO DOM. No. 4	100 m.	1019.84	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.393666
745	28	ALAMB.Cu. AISL MONO.USO DOM. No. 6	100 m.	641.50	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.408787
746	28	ALAMB.Cu. AISL MONO.USO DOM. No. 8	100 m.	399.55	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.425027
747	28	ALAMB.Cu. AISL MONO.USO DOM. No. 10	100 m.	243.64	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.440754
748	28	ALAMB.Cu. AISL MONO.USO DOM. No. 12	100 m.	159.40	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.455972
749	28	CABLE Cu. AISL MONO.USO DOM. No. 14	100 m.	106.79	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.471089
750	28	CABLE Cu. AISL MONO.USO DOM. No. 16	100 m.	71.87	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.486886
751	28	CABLE Cu. AISL MONO.USO DOM. No.  18	100 m.	50.81	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.501974
752	28	CABLE Cu. AISL MONO.USO DOM. No. 20	100 m.	36.77	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.51713
753	28	CORDON Cu. AISLADO  2x10 (100 m.)	100 m.	555.43	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.532433
754	28	CORDON Cu. AISLADO 2x12 (100m.)	100 m.	366.23	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.547894
755	28	CORDON Cu. AISLADO 2x14 (100m.)	100 m.	257.64	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.563418
756	28	CORDON Cu. AISLADO  2x16 (100m.)	100 m.	184.08	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.578665
757	28	CORDON Cu. AISLADO 2x18 (100m.)	100 m.	134.77	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.593889
758	28	CORDON Cu. AISLADO 2x20 (1000m.)	100 m.	94.65	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.609509
759	28	CORDON Cu. AISLADO 2x22 (100m.)	100 m.	78.79	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.625329
760	28	CABLE Cu. CONCENTRICO 2x8	100 m.	1121.96	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.640716
761	28	CABLE Cu. CONCENTRICO 2x10	100 m.	762.28	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.656288
762	28	CABLE Cu. CONCENTRICO 3x8	100 m.	2728.89	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.67166
763	28	CABLE Cu. CONCENTRICO 3x6	100 m.	2799.83	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.687244
764	28	CABLE PARATV 2x22 SIMPLE 100m.	Rollo	108.64	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.702495
765	28	CABLE PARATV 2x22 DOBLE 100m.	Rollo	189.18	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.717665
766	28	TUBO P/INST. ELECT. Cd. L=3m. 1/2\\'\\'	Tubo	4.23	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.733375
767	28	TUBO P/INST. ELECT. Cd. L=3m. 5/8\\'\\'	Tubo	5.53	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.748639
768	28	TUBO P/INST. ELECT Cd. L=3m. 3/4\\'\\'	Tubo	7.60	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.763869
769	28	TUBO P/INST ELECT. Cd. L=3m. 1\\'\\'	Tubo	11.46	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.779119
770	28	CABLE Cu. AISLADO MONOPOLAR Nº 8	100 m.	464.51	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.795534
771	28	CABLE Cu. AISLADO MONOPOLAR Nº 6	100 m.	743.01	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.81078
772	28	CABLE Cu. AISLADO MONOPOLAR Nº 4	100 m.	1142.47	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.826028
773	28	CABLE Cu. AISLADO MONOPOLAR Nº 2	100 m.	2436.31	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.841356
774	28	CABLE Cu. AISLADO MONOPOLAR 1/0	100 m.	4128.23	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.856605
775	28	CABLE Cu. AISLADO MONOPOLAR 2/0	100 m.	5095.03	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.872739
776	28	CABLE Cu. AISLADO MONOPOLAR 3/0	100 m.	6444.14	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.888535
777	28	CABLE Cu. AISLADO MONOPOLAR 4/0	100 m.	79.99	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.904198
778	28	CABLE Cu. AISLADO MONOPOLAR 250	100 m.	10391.00	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.919921
779	28	CABLE Cu. AISLADO MONOPOLAR 300	100 m.	12384.83	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.935158
780	28	CABLE Cu. AISLADO MONOPOLAR 350	100 m.	14413.00	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.950341
781	28	CABLE Cu. AISLADO MONOPOLAR 400	100 m.	16441.00	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.965532
782	28	CABLE Cu. AISLADO MONOPOLAR 500	100 m.	20592.97	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.982146
783	28	CABLE Cu. AISLADO MONOPOLAR 600	100 m.	24082.12	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:22.998093
784	28	INTERRUPTOR TERMICO Unip. 6 Amp.	Pza.	42.87	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.013349
785	28	INTERRUPTOR TERM. Unip. 10-l5Amp	Pza.	27.15	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.02874
786	28	INTERRUPTOR TERM. Unip. 20-30 Amp	Pza.	27.15	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.044683
787	28	INTERRUPTOR TERMICO Bipolar 15 Amp.	Pza.	71.87	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.059706
788	28	INTERRUPTOR TERMICO Bipolar 30 Amp.	Pza.	71.87	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.074803
789	28	INTERRUPTOR TERMICO Bipolar 60 Amp.	Pza.	101.65	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.090032
790	28	INTERRUPTOR TERMICO Tripolar 15 Amp.	Pza.	101.65	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.10546
791	28	INTERRUPTOR TERMICO Tripolar 30 Amp.	Pza.	101.65	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.121727
792	28	INTERRUPTOR TERMICO Tripolar 60 Amp.	Pza.	143.60	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.137255
793	28	INTERRUPTOR TERMICO l00 Amp.	Pza.	841.09	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.152967
794	28	INTERRUPTOR TERMICO 200 Amp.	Pza.	2149.97	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.16855
795	28	CAJA RECTANGULAR DOBLE PAVCO	Pza.	7.51	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.184109
796	28	CAJA RECTANGULAR SIMPLE PAVCO	Pza.	4.41	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.199458
797	28	CAJA OCTOGONAL PAVCO	Pza.	7.02	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.215456
798	28	TUBERIA CONDUFLEX PAVCO 1/2\\'\\'	MI.	3.71	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.231375
799	28	TUBERIA CONDUFLEX PAVCO 3/4\\'\\'	MI.	5.39	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.246727
800	28	ADAPTADOR CONDUFLEX PAVCO 1/2\\'\\'	MI.	0.89	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.261939
801	28	UNION CONDUFLEX PAVCO 1/2\\'\\'	MI.	0.89	Importado de archivo SQL - Categoría 28	2025-05-31 20:38:23.278798
802	29	BAÑO FERRUM-FLOREN. 2 PZA. COMPLETO	Jgo.	2146.11	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.29463
803	29	BAÑO FERRUM-FLOREN 3 Pza COMPLETO	Jgo.	2593.44	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.309336
804	29	BAÑO FERRUM-ADRIAT. 3 PZA. COMPLETO	Jgo.	4526.26	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.324677
805	29	BAÑO DECA DE VILLE 3 PZA COMPLETA	Jgo.	2764.35	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.340051
806	29	INODORO BLANCO T/BAJO C/TAPA	Pza.	824.82	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.356077
807	29	INODORO COLOR T/bajo con tapa	Pza.	646.41	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.372525
808	29	INODORO COLOR T/alta con tapa	Pza.	1379.78	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.387809
809	29	LAVAMANOS S/PEDESTAL BLANCO	Pza.	646.20	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.405271
810	29	LAVAMANOS  C/PEDESTAL BLANCO	Pza.	615.50	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.420933
811	29	LAVAMANOS S/PEDESTAL COLOR	Pza.	1078.63	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.436639
812	29	LAVAMANOS C/PEDESTAL COLOR	Pza.	933.57	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.451899
813	29	PEDESTAL BLANCO	Pza.	170.06	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.467269
814	29	URINARIO BLANCO CON SIFON	Pza.	412.53	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.482667
815	29	TINA DE FIERRO ENLOZADO COLOR	Pza.	620.71	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.498936
816	29	BIDET BLANCO	Pza.	466.51	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.513506
817	29	BIDETT FERRUM - ADRIATICA	Pza.	755.01	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.529222
818	29	TOALLERO	Pza.	47.59	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.544625
819	29	JABONERO	Pza.	41.80	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.560285
820	29	PERCHA	Pza.	32.02	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.576022
821	29	PAPELERO	Pza.	53.49	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.59709
822	29	BASE DUCHA 0.80x0.80	Pza.	164.32	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.618878
823	29	BASE DUCHA 0.75x0.75	Pza.	146.94	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.634866
824	29	BASE DUCHA 0.70x0.70	Pza.	129.75	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.651656
825	29	DUCHA LORENZETTI METALICA	Pza.	319.93	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.6669
826	29	LAVAPLATOS C/GRIFERIA 1 BACHA CORRIENTE	Pza.	900.59	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.682084
827	29	LAVAPLATOS C/GRIFERIA 2 BACHAS CORRIENTES .	Pza.	583.10	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.697409
828	29	REJILLA DE PISO \\'\\'SINFONADA\\'\\'	Pza.	56.17	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.713863
829	29	CHICOTILLO GALVANIZADO 30cm.	Pza.	45.42	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.729647
830	29	CHICOTILLO PVC 30 cm.	Pza.	13.98	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.74476
831	29	CAJA INTERCEPTORA DE Ho. 25x25	Pza.	45.55	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.759899
832	29	LAVARROPA DE CEMENTO	Pza.	182.55	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.775684
833	29	LAVADERO DE FIERRO ENLOSADO	Pza.	803.77	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.790862
834	29	PRODUCTOS DECA ACCESORIOS G-17	Jgo.	222.01	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.806018
835	29	PRODUCTOS DECA JABONERA BLANCA A-18	Pza.	39.13	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.821316
836	29	PRODUCTOS DECA PERCHA DOBLE BLANCA A-600	Pza.	23.63	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.837527
837	29	PRODUCTOS DECA PERCHA SIMPLE BLANCA A-680	Pza.	20.58	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.853
838	29	PRODUCTOS DECA TOALLEROS BLANCO A-586	Pza.	47.59	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.86848
839	29	PRODUCTOS DECA PAPELERO BLANCO A-480	Pza.	41.80	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.883799
840	29	PRODUCTOS DECA INODORO BLANCO T/ALTO EXT P-15	Pza.	349.25	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.899006
841	29	PRODUCTOS DECA LAVAMANOS BLANCO L-15	Pza.	171.09	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.914308
842	29	PRODUCTOS DECA URINARIO BLANCO M-711	Pza.	296.95	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.929751
843	29	PRODUCTOS DECA URINARIO BLANCO C/SIFON M-712	Pza.	414.36	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.945411
844	29	PRODUCTOS DECA INODORO COLOR RAVENA (BE-68)	Pza.	508.86	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.960774
845	29	PRODUCTOS DECA INODORO TANQUE COLOR (BE-68)	Pza.	584.96	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.976413
846	29	PRODUCTOS DECA INOD. COLOR HIDRA RAVENA (BE-68)	Pza.	359.73	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:23.992354
847	29	PRODUCTOS DECA LAVAMANOS COLOR RAVENA (BE-68)	Pza.	281.30	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.007959
848	29	PRODUCTOS DECA LAVAM.SOB.COLOR RAVENA (BE-68)	Pza.	392.45	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.023081
849	29	PRODUCTOS DECA PEDESTAL COLOR RAVENA (BE-68)	Pza.	222.30	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.038672
850	29	PRODUCTOS DECA BIDETT COLOR RAVENA (BE-68)	Pza.	421.30	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.054028
851	29	PRODUCTOS DECA INDORO COLOR RAVENA (GE-17)	Pza.	468.52	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.068266
852	29	PRODUCTOS DECA TANQUE COLOR (GE-17)	Pza.	584.96	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.083997
853	29	PRODUCTOS DECA LAVAMANOS COLOR RAVENA (GE-17)	Pza.	269.11	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.099267
854	29	PRODUCTOS DECA LAVAM.SOB.COLOR RAVENA (GE-17)	Pza.	322.23	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.114486
855	29	PRODUCTOS DECA PEDESTAL COLOR RAVENA (GE-17) .	Pza.	211.38	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.129635
856	29	PRODUCTOS DECA INODORO COLOR DE VILLE (CR-37)	Pza.	778.81	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.144924
857	29	PRODUCTOS DECA  TANQUE COLOR (CR-37)	Pza.	584.96	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.159987
858	29	PRODUCTOS DECA LAVAMANOS COLOR DE VILLE (CR-37)	Pza.	394.31	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.175317
859	29	PRODUCTOS DECA LAVAM.SOB. COLOR DE VILLE (CR-37)	Pza.	418.41	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.190629
860	29	PRODUCTOS DECA LAVAM. ENV. COLOR DE VILLE (CR-37)	Pza.	187.63	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.205747
861	29	PRODUCTOS DECA PEDESTAL COLOR DE VILLE (CR-37)	Pza.	247.00	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.220808
862	29	PRODUCTOS DECA BIDETT COLOR DE VILLE (CR-37)	Pza.	605.35	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.236417
863	29	PRODUCTOS DECA INODORO COLOR CARRARA (BE-83)	Pza.	1513.75	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.252126
864	29	PRODUCTOS DECA TANQUE COLOR CARRARA (BE-83)	Pza.	865.83	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.268217
865	29	PRODUCTOS DECA INOD.COLOR HIDRA CARRARA (BE-83)	Pza.	1092.97	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.283713
866	29	PRODUCTOS DECA LAVAM. COLOR CARRARA (BE-83)	Pza.	571.26	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.298946
867	29	PRODUCTOS DECA LAVAM.SOB.COLOR CARRARA (BE-83)	Pza.	558.12	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.314528
868	29	PRODUCTOS DECA PEDESTAL COLOR CARRARA (BE-83)	Pza.	357.67	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.329622
869	29	PRODUCTOS DECA BIDETT COLOR CARRARA (BE-83)	Pza.	1162.14	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.345129
870	29	PRODUCTOS DECA INODORO MONTECARLO (RF-89)	Pza.	1024.62	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.360574
871	29	PRODUCTOS DECA TANOUE (RF-89)	Pza.	774.77	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.375673
872	29	PRODUCTOS DECA INOD. HIDRA MONTECARLO (RF-89)	Pza.	628.50	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.391244
873	29	PRODUCTOS DECA LAVAMANOS MONTECARLO (RF-89)	Pza.	484.28	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.406321
874	29	PRODUCTOS DECA LAVAM.SOB. MONTECARLO (RF-89)	Pza.	472.41	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.421682
875	29	PRODUCTOS DECA PEDESTAL MONTECARLO (RF-89)	Pza.	413.00	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.437754
876	29	PRODUCTOS DECA BIDETT MONTECARLO (RF-89)	Pza.	1426.04	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.454141
877	29	PRODUCTOS DECA INODORO COLOR B. EPOQUE (GE-17)	Pza.	1565.88	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.470134
878	29	PRODUCTOS DECA TANQUE B. EPOOUE (GE-17)	Pza.	721.46	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.485485
879	29	PRODUCTOS DECA LAVAM. COLOR B. EPOQUE (GE-17)	Pza.	659.99	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.509965
880	29	PRODUCTOS DECA LAVAM.SOB. COLOR B. EPOQUE (GE-17)	Pza.	488.42	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.5258
881	29	PRODUCTOS DECA PEDESTAL COLOR B. EPOQUE (GE-17)	Pza.	413.00	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.547407
882	29	PRODUCTOS DECA BIDETT COLOR B. EPOQUE (GE-17)	Pza.	1426.04	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.570297
883	29	PRODUCTOS DECA TAPA INOD. BLANCO RAVENA	Pza.	584.96	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.585823
884	29	PRODUCTOS DECA TAPA INODORO DE VILLE (BE-68)	Pza.	165.02	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.600917
885	29	PRODUCTOS DECA TAPA INOD.MONTECARLO (RF-89)	Pza.	258.64	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:24.616372
886	30	ALAMBRE ESTAÑADO MONOPOLAR 18	100 m.	50.95	Importado de archivo SQL - Categoría 30	2025-05-31 20:38:24.631729
887	30	ALAMBRE ESTAÑADO MONOPOLAR 19	100 m.	35.28	Importado de archivo SQL - Categoría 30	2025-05-31 20:38:24.646956
888	30	ALAMBRE ESTAÑADO MONOPOLAR 20	100 m.	29.89	Importado de archivo SQL - Categoría 30	2025-05-31 20:38:24.66289
889	30	CABLE D/RECUB. P/EXTERIOR 2x19	100 m.	128.64	Importado de archivo SQL - Categoría 30	2025-05-31 20:38:24.678174
890	30	CABLE DE BADAJAC/AUTOPORT. 2x20.	100 m.	165.70	Importado de archivo SQL - Categoría 30	2025-05-31 20:38:24.693714
891	30	CABLE TEL. P/INTERIORES 2x21	100 m.	68.70	Importado de archivo SQL - Categoría 30	2025-05-31 20:38:24.708964
892	30	CABLE D/RECUB. P/EXTERIOR 2x21	100 m.	137.32	Importado de archivo SQL - Categoría 30	2025-05-31 20:38:24.72443
893	30	CABLE TELF. PJ1NTERIORES 2x20	100 m.	89.93	Importado de archivo SQL - Categoría 30	2025-05-31 20:38:24.741929
894	30	CABLE ENTORCHADO P/lNTERIOR 2x24	100 m.	40.50	Importado de archivo SQL - Categoría 30	2025-05-31 20:38:24.757345
895	30	CABLE ENTORCHADO P/INTERIOR 2x26	100 m.	33.39	Importado de archivo SQL - Categoría 30	2025-05-31 20:38:24.773079
896	30	CABLE ENTORCHADO P/INTERIOR 2x22	100 m.	56.33	Importado de archivo SQL - Categoría 30	2025-05-31 20:38:24.788333
897	31	LADRILLO ADOBITO DE 1ra. 5x11x22 \\'\\'60/m2\\'\\'	Mil	1.36	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:24.80758
898	31	LADRILLO ADOBITO 2da (5x11x22)	Mil	1.01	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:24.822777
899	31	LADRILLO CERAMICO 3 HUECOS (8x12x25) 44/m2	Mil	1.13	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:24.837935
900	31	LADRILLO DE 4 HUECO TAPIQUE (8x12x25) 42/m2	Mil	0.83	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:24.853706
901	31	LADRILLO DE 6 HUECO (10x15x25) 25/m2	Mil	1.01	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:24.869503
902	31	LADRILLO Esp. DE 6 HUECOS (10x15x40) 18/m2	Pza	0.83	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:24.885001
903	31	LADRILLO SUPER DE 6 HUECOS (10x15x40) 15/m2	Mil	1.01	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:24.900164
904	31	LADRILLO  DE 8 HUECOS (10x20x25) 20/m2	Mil	0.87	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:24.915508
905	31	LADRILLO DE 12 HUECOS (10x30x40) 8.33/m2	Pza.	0.73	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:24.930783
906	31	LADRILLO DE 21 HUECOS (7x25x12.5) 44/m2	Pza.	0.97	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:24.94728
907	31	LADRILLO GAMBOTE Esq. (8x12x25) 44/m2	Pza.	1.01	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:24.962454
908	31	LADRILLO COMPLEMENO No 8 (8x20x25)  20/m2	Mil	2.97	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:24.977545
909	31	LADRILLO COMPLEMENTO No 9 (9x20x37) 10/m2	Mil	2.73	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:24.993711
910	32	LOSETA DISEÑADA DE 100x100x2.5cm. (material)	M2	3.36	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:25.009161
911	32	LOSETAS CON INSTALACION EN MADERA	M2	3.36	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:25.026801
912	32	LOSETAS ACUSTICAS (material)	M2	3.19	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:25.044177
913	32	LOSETAS CON INSTALACION  EN MADERA	M2	2.85	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:25.06518
914	32	LOSETAS MOLDEADAS (material)	M2	8.11	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:25.084772
915	32	LOSETA DOBLE \\'\\'S\\'\\'. CONCRETEC (32 pzas./m2)	Pza.	2.85	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:25.102251
916	33	MADERA MARA DE 1ra	P2.	12.67	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.117531
917	33	MADERA DE CONSTRUCCION	P2.	3.20	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.1366
918	33	MADERA ASERRADA ALMENDRILLO	P2.	7.77	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.151917
919	33	MADERA OCHOO	P2.	3.20	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.167564
920	33	MADERA ROBLE DE 1ra.	P2.	10.99	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.182427
921	33	MADERA  TAJIBO	P2.	7.77	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.197825
922	33	MACHIMBRE DE MARA	P2.	13.75	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.213279
923	33	MACHIMBRE CEDRO	P2	6.95	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.228602
924	33	MACHIEMBRE LAUREL	P2	7.43	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.243812
925	33	MACHIEMBRE PALO MARIA	P2	7.77	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.258962
926	33	PARQUET MARA	m2	41.33	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.274813
927	33	PARQUET ROBLE	m2	41.19	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.290743
928	33	PARQUET TA.JIBO	m2	63.59	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.306284
929	33	PARQUET ALMENDRILLO	m2	44.71	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.321741
930	33	PARQUET QUINA - QUINA	M2.	53.31	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.337015
931	33	ZOCALO MARA 3\\'\\'	ml.	8.92	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.352239
932	33	ZOCALO TARARA 3\\'\\'	ml.	10.63	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.36742
933	33	ZOCALO DE MARA 4\\'\\'	ml.	10.63	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.382713
934	33	ZOCALO TARARA 4\\'\\'	ml.	12.67	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:25.398164
935	34	VENESTA PALO MARIA 244x122x4 mm. (1cara)	Pza.	110.45	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.412222
936	34	MULTILAMINADOS SEREBO 244x122x6 mm.	Pza.	103.25	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.427429
937	34	MULTILAMINADOS SEREBO 244x122x8 mm.	Pza.	137.32	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.445232
938	34	MULTILAMINADOS SEREBO 244x122x10 mm.	Pza.	172.22	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.4615
939	34	MULTILAMINADOS SEREBO 244x122x12 mm.	Pza.	206.36	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.476724
940	34	MULTILAMINADOS SEREBO 244x122x15 mm.	Pza.	255.28	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.491898
941	34	MULTILAMINADOS SEREBO 244x122x18 mm.	Pza.	310.11	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.507707
942	34	TABLES ENCHAPADO MARA 244x122x16 mm.	Pza.	318.87	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.523617
943	34	TABLES ENCHAPADO MARA 244x122x19 mm.	Pza.	346.73	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.538983
944	34	TABLES MELAMINICO (1cara) 410x122x9 mm.	Pza.	306.23	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.554388
945	34	TABLES MELAMINICO (1cara) 410x122x12 mm.	Pza.	335.27	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.569672
946	34	TABLES MELAMINICO (1 cara) 410x122x15 mm.	Pza.	362.55	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.58535
947	34	TABLES MELAMINICO (1cara) 410x122x19 mm.	Pza.	395.98	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.601231
948	34	TABLES MELAMINICO (2caras) 410x122x9 mm.	Pza.	423.18	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.616835
949	34	TABLES MELAMINICO (2caras) 410x122x12 mm.	Pza.	451.60	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.632199
950	34	TABLES MELAMINICO (2caras) 410x122x15mm.	Pza.	477.97	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.647533
951	34	TABLES MELAMINICO (2caras) 410x122x19 mm.	Pza.	512.89	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.667
952	34	TABLEX RUSTICO 410x183x9 mm.	Pza.	309.40	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.682212
953	34	TABLEX RUSTICO 410x183x12 mm.	Pza.	552.87	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:25.697742
954	35	MANGUERA 3/8\\'\\' LISA	M.	4.41	Importado de archivo SQL - Categoría 35	2025-05-31 20:38:25.712966
955	35	MANGUERA 1/2\\'\\' LISA	M.	5.03	Importado de archivo SQL - Categoría 35	2025-05-31 20:38:25.72817
956	35	MANGUERA 1/2\\'\\' ESTRIADA	M.	6.05	Importado de archivo SQL - Categoría 35	2025-05-31 20:38:25.743481
957	35	MANGUERA 5/8\\'\\'	M	6.58	Importado de archivo SQL - Categoría 35	2025-05-31 20:38:25.758837
958	35	MANGUERA 3/4	M	8.27	Importado de archivo SQL - Categoría 35	2025-05-31 20:38:25.774231
959	35	MANGUERA 3/8\\'\\' LISA	M.	11.14	Importado de archivo SQL - Categoría 35	2025-05-31 20:38:25.789397
960	36	MOSAICO MARMOLADO DE 30x30	M2.	162.79	Importado de archivo SQL - Categoría 36	2025-05-31 20:38:25.804773
961	36	MOSAICO MARMOLADO DE 20x20	M2.	125.30	Importado de archivo SQL - Categoría 36	2025-05-31 20:38:25.819994
962	36	MOSAICO GRANITICO DE 30x30	M2.	123.50	Importado de archivo SQL - Categoría 36	2025-05-31 20:38:25.83526
963	36	MOSAICO GRANITICO DE 20x20	M2.	116.25	Importado de archivo SQL - Categoría 36	2025-05-31 20:38:25.850389
964	36	MOSAICO CORRIENTE DE 25x25	M2.	50.14	Importado de archivo SQL - Categoría 36	2025-05-31 20:38:25.865627
965	36	MOSAICO CORRIENTE DE 20x20	M2.	48.25	Importado de archivo SQL - Categoría 36	2025-05-31 20:38:25.881397
966	36	ZOCALO MARMOLADO DE 10x30	MI.	44.77	Importado de archivo SQL - Categoría 36	2025-05-31 20:38:25.896605
967	36	ZOCALO GRANITICO DE 10x30	MI.	44.77	Importado de archivo SQL - Categoría 36	2025-05-31 20:38:25.913552
968	36	ZOCALO CORRIENTE DE 10x20	MI.	8.11	Importado de archivo SQL - Categoría 36	2025-05-31 20:38:25.929873
969	37	MALLA VARILLAS 3.4 mm. DE 10x10 cm.	M2.	18.38	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:25.945728
970	37	MALLA VARILLAS 3.4 mm. DE 15x15 cm.	M2.	13.98	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:25.962017
971	37	MALLA VARILLAS 3.4 mm. DE 20x20 cm.	M2.	12.17	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:25.978277
972	37	MALLA VARILLAS 3.4 mm. DE 25x25 cm.	M2.	10.78	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:25.993631
973	37	MALLA VARILLAS 4.2 mm. DE 10x10 cm.	M2.	24.81	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:26.009041
974	37	MALLA VARILLAS 4.2 mm. DE 15x15 cm.	M2.	17.88	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:26.025114
975	37	MALLA VARILLAS 4.2 mm. DE 20x20 cm.	M2.	15.00	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:26.044115
976	37	MALLA VARILLAS 4.2 mm. DE 25x25 cm.	M2.	17.22	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:26.060167
977	37	MALLA VARILLAS 6.0 mm. DE 10x10 cm.	M2.	37.33	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:26.077516
978	37	MALLA VARILLAS 6.0 mm. DE 20x20 cm.	M2.	21.40	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:26.092933
979	37	MALLA VARILLAS 6.0 mm. DE 25x25 cm.	M2.	19.56	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:26.108793
980	37	MALLA VARILLAS 6.0 mm. DE 30x30 cm.	M2.	16.03	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:26.128607
981	37	MALLA VARILLAS 8.0 mm. DE 10x10 cm.	M2.	60.59	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:26.144084
982	37	MALLA VARILLAS 8.0 mm. DE 20x20 cm.	M2.	33.11	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:26.160015
983	37	MALLA VARILLAS 8.0 mm. DE 30x30 cm.	M2.	33.57	Importado de archivo SQL - Categoría 37	2025-05-31 20:38:26.175375
984	38	INTERRUPTOR SIMPLE ESMALTADO	Pza	12.48	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.19096
985	38	CONMUTADOR ESMALTADO	Pza.	15.85	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.206284
986	38	PULSADOR ESMALTADO	Pza	14.89	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.243371
987	38	ENCHUFE PL/RED ESMALTADO	Pza.	12.48	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.263715
988	38	DIMMER ESMALTADO	Pza.	111.51	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.279229
989	38	ENCHUFE TELEFONO ESMALTADO	Pza.	30.07	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.295035
990	38	ENCHUFE TV ESMALTADO	Pza	35.69	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.310431
991	38	INTERRUPTOR SIMPLE ALUMINIO	Pza	25.30	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.326624
992	38	INTERR. CON LUZ/PILOTO ALUM.	Pza	33.24	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.342663
993	38	CONMUTADOR ALUMINIO	Pza.	30.54	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.35724
994	38	PULSADORALUMINIO	Pza	27.85	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.372479
995	38	ENCHUFE PL/RED ALUMINIO	Pza	25.15	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.387877
996	38	DIMMER ALUMINIO	Pza	152.04	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.403083
997	38	ENCHUFE TELEFONO ALUMINIO	Pza	45.55	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.418307
998	38	ENCHUFE TV ALUMINIO	Pza	44.20	Importado de archivo SQL - Categoría 38	2025-05-31 20:38:26.43344
999	39	DE PIEDRA PIZARRA NATURAL 60x60	Pza.	326.92	Importado de archivo SQL - Categoría 39	2025-05-31 20:38:26.448984
1000	39	DE PIEDRA PIZARRA NATURAL 70x70	Pza.	374.58	Importado de archivo SQL - Categoría 39	2025-05-31 20:38:26.465328
1001	39	DE PIEDRA PIZARRA NATURAL 80x80	Pza.	520.17	Importado de archivo SQL - Categoría 39	2025-05-31 20:38:26.480686
1002	39	DE PIEDRA PIZARRA SEMIPULIDA 60x60	Pza.	436.99	Importado de archivo SQL - Categoría 39	2025-05-31 20:38:26.495819
1003	39	DE PIEDRA PIZARRA SEMIPULIDA 70x70	Pza.	499.42	Importado de archivo SQL - Categoría 39	2025-05-31 20:38:26.51109
1004	39	DE PIEDRA PIZARRA SEMIPULIDA 80x80	Pza.	624.08	Importado de archivo SQL - Categoría 39	2025-05-31 20:38:26.526482
1005	40	LATEX TRADICIONAL MONOPOL	GI	93.74	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.54267
1006	40	LATEX TRADICIONAL MONOPOL	18 Lt.	444.29	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.55776
1007	40	PINTURA LATEX 2000 MONOPOL	GI.	66.73	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.572938
1008	40	PINTURA LATEX 2000 MONOPOL	18 Lt.	303.91	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.59249
1009	40	LATEX TEXTURADOR MONOPOL	GI.	102.57	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.60795
1010	40	LATEX TEXTURADOR MONOPOL	18 Lt.	491.76	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.622413
1011	40	REVEST. RUSTICO ENLUCIDO BLANCO MONOPOL	GI.	101.37	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.638517
1012	40	REVEST. RUSTICO ENLUCIDO BLANCO MONOPOL	18 Lt.	470.61	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.653683
1013	40	SELLADOR DE PAREDES TRANSPARENTE MONOPOL	GI.	58.42	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.668253
1014	40	SELLADOR DE PAREDES TRANSPARENTE MONOPOL	18 Lt.	255.77	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.683643
1015	40	SELLADOR PARE. BLANCO MONOPOL	GI.	66.03	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.69967
1016	40	SELLADOR PARE. BLANCO MONOPOL	18 Lt.	297.69	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.715068
1017	40	MASA ACRIL. EXT. BLANCA MONOPOL	GI.	69.28	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.730622
1018	40	MASA ACRIL. EXT. BLANCA MONOPOL	18 Lt.	308.95	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.746243
1019	40	SUPERLATEX ACRILICO MONOPOL	GI	126.98	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.761865
1020	40	SUPERLATEX ACRILICO MONOPOL	18 Lt.	610.30	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.777113
1021	40	LATEX SATINADO MONOPOL	GI.	131.99	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.791229
1022	40	LATEX SATINADO MONOPOL	18 Lt.	638.55	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.8064
1023	40	PINTURA SINTET.BRILLO MONOPOL	GI.	131.99	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.821623
1024	40	PINTURA SINTET. BRILLO MONOPOL	18 Lt.	612.90	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.836757
1025	40	MONOLAC (SECADO RAPIDO) MONOPOL	Gl.	220.57	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.85198
1026	40	MONOLAC (SECADO RAPIDO) MONOPOL	18Lt.	1058.38	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.867534
1027	40	PINTURA SINTET MATE MONOPOL	Gl.	137.24	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.882699
1028	40	PINTURA SINTET. MATE MONOPOL	18Lt.	627.11	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.897819
1029	40	ANTICORROSIVA OXIDO DE HIERRO MATE CAOBA MONOPOL	Gl.	124.39	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.912956
1030	40	ANTICORROSIVA OXIDO DE HIERRO MATE CAOBA MONOPOL	18 Lt.	566.80	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.928731
1031	40	ANTICORROSIVA CROMATO DE ZINC MONOPOL	GI.	143.68	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.944426
1032	40	ANTICORROSIVA CROMATO DE ZINC MONOPOL	18 Lt.	660.35	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.959915
1033	40	PINT. HORNO ALQUIDICA MONOPOL	GI.	255.25	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.97522
1034	40	PINT. HORNO ALQUIDICA MONOPOL	18 Lt.	1256.63	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:26.991259
1035	40	ALPEX MONOPOL	GI.	271.89	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.007697
1036	40	ALPEX MONOPOL	18 Lt.	1315.54	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.024393
1037	40	PINTURA P/PISCINAS BLANCA MONOPOL	GI.	206.37	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.041508
1038	40	PINTURA P/PISCINAS BLANCA MONOPOL	18 Lt.	396.28	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.056952
1039	40	ASFALTEX MONOPOL	GI.	176.95	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.072155
1040	40	ASFALTEX MONOPOL	18 Lt.	828.28	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.087728
1041	40	IMPERMEABILIZANTE SILICONADO PARA CONCRETO MONOPOL	10 Lt.	294.91	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.102255
1042	40	PINTURA DE DEMARCACION DE CALLES BLANCO MONOPOL	GI	202.57	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.117928
1043	40	PINTURA DE DEMARCACION DE CALLES BLANCO MONOPOL	18 Lt.	971.90	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.133078
1044	40	PINTURA DEPORT. BLANCA MONOPOL	GI.	243.64	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.148085
1045	40	PINTURA DEPORT. BLANCA MONOPOL	18 Lt.	1207.93	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.162168
1046	40	BARNIZ COPAL Env. 3.6 Lt.	Galon	101.37	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.176182
1047	40	BARNIZ FILTRO SOLAR  Env. 3.6 Lt.	Galon	136.44	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.191397
1048	40	BARNIZ POLIURETANO Env.  3.6 Lt.	Galon	123.03	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.206511
1049	40	BARNIZ CRISTAL BRILL. MONOPOL	18 Lt.	564.20	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.221713
1050	40	BARNIZ MARINO FILTRO SOLAR BRILLOSO MONOPOL	GI.	164.11	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.236945
1051	40	BARNIZ MARINO FILTRO SOLAR BRILLOSO MONOPOL	18 Lt.	768.12	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.25268
1052	40	MASILLA P/MADERA MONOPOL	 GI.	92.38	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.267905
1053	40	SELLADOR P/PARED  Env. 3.6 Lts.	Galon	116.63	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.282939
1054	40	SELLADOR P/MADERA  Env. 18 Lts.	Galon	486.02	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.298015
1055	40	TAPA PORO MONOPOL	 GI.	144.84	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.314012
1056	40	TAPA PORO MONOPOL	18 Lt.	670.58	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.329693
1057	40	CARPICOLA MONOPOL	GI.	96.12	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.345419
1058	40	CARPICOLA MONOPOL	l8Lt.	455.20	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.360529
1059	40	PEGATEX (REV.P/ALFOMB.) MONOPOL	18 Lt.	393.70	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.376658
1060	40	PEGATUBO PVC MONOPOL (1 Lts.)	GI.	364.23	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.391983
1061	40	PEGA ALFOMBRA MONOPOL	Galon	171.92	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.407922
1062	40	LACABRILL	GI.	153.20	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.423278
1063	40	LACABRILL	18 Lt.	712.87	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.438938
1064	40	PINTURA PARA MADERA  KEM-PENTA (antitermita)	Lt.	98.10	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.454029
1065	40	BARNIZ PISOTHANE	GI.	164.11	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.47067
1066	40	BARNIZ PISOTHANE	18 Lt.	603.86	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.487501
1067	40	PINTURA PARA PIZARRAS	GI.	133.40	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.503056
1068	40	PINTURA PARA PIZARRAS	18 Lt.	602.66	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.51834
1069	40	TINTE LATEX	10Lt.	1088.69	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.536151
1070	40	BROCHA 1 1/2\\'\\' MONOPOL	Pza.	4.66	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.551363
1071	40	BROCHA 2\\'\\' MONOPOL	Pza.	5.62	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.566803
1072	40	BROCHA 2 1/2\\'\\' MONOPOL	Pza.	6.97	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.582083
1073	40	BROCHA 3\\'\\' MONOPOL	Pza.	9.42	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.59707
1074	40	BROCHA 4\\'\\' MONOPOL	Pza.	14.89	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.612123
1075	40	BROCHA 5\\'\\' MONOPOL	Pza.	20.14	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.62739
1076	40	BROCHA 6\\'\\' MONOPOL	Pza.	25.66	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.643616
1077	40	LATEX KEM AGUA MATE	GI.	90.12	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.660062
1078	40	LATEX KEM AGUA MATE	18 Lt.	242.56	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.674364
1079	40	LATEX KEM AGUA MATE	18 Lt.	415.89	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.695323
1080	40	LATEX EXCELLO	GI.	77.97	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.710644
1081	40	LATEX EXELLO	18 Lt.	381.22	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.726235
1082	40	LATEX EXCELLO CONTRATISTA	GI.	72.76	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.741708
1083	40	LATEX EXCELLO CONTRATISTA	18 Lt.	337.92	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.756967
1084	40	SELLADOR PARA PAREDES KEM	G1.	74.23	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.772973
1085	40	SELLADOR PARA PAREDES KEM	18 Lt.	310.45	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.788196
1086	40	PINTURA OLEO MATE EXCELLO	Gl.	110.51	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.803407
1087	40	PINTURA OLEO MATE EXCELLO	18 Lt.	565.21	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.818637
1088	40	PINTURA OLEO SEMIBRILLO KEM-GLO	Gl.	129.94	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.834479
1089	40	PINTURA OLEO SEMIBRILLQ KEM-GLO	18 Lt.	620.88	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.849689
1090	40	PINTURA EXCELLO ACEITE BRILLO	Gl.	106.27	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.864949
1091	40	PINTURA EXCELLO ACEITE BRILLO	18 Lt.	548.36	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.880065
1092	40	PINTURA KEM LUSTRAL EXTRA RESIST.	Gl.	121.49	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.895357
1093	40	PINTURA KEM LUSTRAL EXTRA RESIST.	18 Lt.	598.92	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.910982
1094	40	PINTURA GALVITE ANTICORROSIVO	Gl.	104.62	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.92622
1095	40	PINTURA GALV1TE ANTICORROSIVO	18 Lt.	544.95	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.94149
1096	40	PRESERV. CONTRA TERMITAS	Gl.	84.40	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.956585
1097	40	TINTE MINERAL TRANSPARENTE	Gl.	111.32	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.972194
1098	40	BARNIZ COPAL BRILLO	Gl.	82.64	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:27.987442
1099	40	BARNIZ COPAL BRILLO	18 Lt.	469.61	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:28.002778
1100	40	BARNIZ BRILLO REXPAR	Gl.	141.71	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:28.018632
1101	40	BARNIZ BRILLO REXPAR	18 Lt.	700.19	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:28.033925
1102	40	BARNIZ MATE	18 Lt.	717.05	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:28.050048
1103	40	SELLADOR CONCENTRADO	Gl.	119.79	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:28.065393
1104	40	SELLADOR CONCENTRADO	18 Lt.	575.33	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:28.080721
1105	40	ACEITE DE LINAZA	Gl.	81.01	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:28.095889
1106	40	AGUARRAZ MINERAL Env. 3.6 Lts.	Gl.	52.29	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:28.111487
1107	40	THINNER ACRILICO	Gl.	87.28	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:28.126861
1108	41	PISOPAX REFORZADO 30.5x30x5x1.6mm.	M2.	48.90	Importado de archivo SQL - Categoría 41	2025-05-31 20:38:28.142024
1109	41	PAVIFLEX 30x30x3m.	M2.	51.13	Importado de archivo SQL - Categoría 41	2025-05-31 20:38:28.157377
1110	41	DURAFLEX 30x30 cm. e=3 mm.	M2.	58.87	Importado de archivo SQL - Categoría 41	2025-05-31 20:38:28.172523
1111	41	ZOCALOS DE VINIL 1.20x7.5 cm.	MI.	12.99	Importado de archivo SQL - Categoría 41	2025-05-31 20:38:28.187816
1112	41	HUELLAS DE ESCALERA 1.20x0.30x0.05mm.	MI	51.78	Importado de archivo SQL - Categoría 41	2025-05-31 20:38:28.202961
1113	41	CONTRA  HUELLAS  P/ESCALERA	MI.	18.38	Importado de archivo SQL - Categoría 41	2025-05-31 20:38:28.21821
1114	41	PISO TRANSPARENTE 0.60 cm. ANCHO	MI.	51.78	Importado de archivo SQL - Categoría 41	2025-05-31 20:38:28.233422
1115	41	PISO CERAMICO NACIONAL 20x20	M2.	53.64	Importado de archivo SQL - Categoría 41	2025-05-31 20:38:28.249278
1116	41	PISO CERAMICO ESMALT. 20x25 (clasico capri)	M2.	78.87	Importado de archivo SQL - Categoría 41	2025-05-31 20:38:28.265345
1117	41	PISO LAMINADO ROYSOL PISO DOMESTICO DOBLE NATURAL	M2.	189.81	Importado de archivo SQL - Categoría 41	2025-05-31 20:38:28.282109
1118	41	PISO LAMINADO ROYSOL PISO DOMESTICO INTENSIVO NAT.	M2.	222.73	Importado de archivo SQL - Categoría 41	2025-05-31 20:38:28.297489
1119	41	PISO LAMINADO ROYSOL PISO ALTO TRAFICO ROBLE NAT.	M2.	318.21	Importado de archivo SQL - Categoría 41	2025-05-31 20:38:28.31306
1120	41	PISO LAMINADO ROYSOL SUB CAPA ROYSOL	M2.	12.99	Importado de archivo SQL - Categoría 41	2025-05-31 20:38:28.328495
1121	42	PLANCHA DE 1/4\\'\\'	Hoja	105.91	Importado de archivo SQL - Categoría 42	2025-05-31 20:38:28.344622
1122	42	PLANCHA DE 1/32\\'\\'	Hoja	120.15	Importado de archivo SQL - Categoría 42	2025-05-31 20:38:28.360146
1123	42	PLANCHA DE 1/16\\'\\'	Hoja	216.31	Importado de archivo SQL - Categoría 42	2025-05-31 20:38:28.375545
1124	42	PLANCHA DE 2 mm.	Hoja	333.23	Importado de archivo SQL - Categoría 42	2025-05-31 20:38:28.390842
1125	42	PLANCHA DE 1/8\\'\\'	Hoja	468.34	Importado de archivo SQL - Categoría 42	2025-05-31 20:38:28.406765
1126	42	PLANCHA DE 3/16\\'\\'	Hoja	661.39	Importado de archivo SQL - Categoría 42	2025-05-31 20:38:28.422809
1127	42	PLANCHA DE 1/4\\'\\'	Hoja	855.72	Importado de archivo SQL - Categoría 42	2025-05-31 20:38:28.438778
1128	42	PLANCHA DE 5/16\\'\\'	Hoja	1255.26	Importado de archivo SQL - Categoría 42	2025-05-31 20:38:28.45403
1129	42	PLANCHA DE 3/8\\'\\'	Hoja	1441.06	Importado de archivo SQL - Categoría 42	2025-05-31 20:38:28.469314
1130	43	PLANCHA ACRIL. 1x2-2 1.00x2.00-2	Hoja	305.03	Importado de archivo SQL - Categoría 43	2025-05-31 20:38:28.484953
1131	43	PLANCHAS ACRIL. 1x2-3 1.00x2.00-3	Hoja	468.73	Importado de archivo SQL - Categoría 43	2025-05-31 20:38:28.50025
1132	43	PLANCHAS ACRIL. 1x2-5 1.00x2.00-5	Hoja	800.39	Importado de archivo SQL - Categoría 43	2025-05-31 20:38:28.51538
1133	43	PLANCHAS ACRIL. 1.20x2.40-3	Hoja	717.05	Importado de archivo SQL - Categoría 43	2025-05-31 20:38:28.530531
1134	43	PLANCHAS ACRIL. 1.20x2.40-5	Hoja	1217.46	Importado de archivo SQL - Categoría 43	2025-05-31 20:38:28.547752
1135	43	PLANCHAS ACRIL. 1.00x2.00x1	M2	155.55	Importado de archivo SQL - Categoría 43	2025-05-31 20:38:28.563011
1136	43	PLANCHAS ACRIL. 0.98x1.80	Hoja	159.40	Importado de archivo SQL - Categoría 43	2025-05-31 20:38:28.578493
1137	44	POLITUBO 1/2\\'\\' 100 mts.	Rollo	431.75	Importado de archivo SQL - Categoría 44	2025-05-31 20:38:28.594825
1138	44	POLITUBO 3/4\\'\\' 100 mts.	Rollo	575.48	Importado de archivo SQL - Categoría 44	2025-05-31 20:38:28.611568
1139	44	POLITUBO 1\\'\\' 100 mts.	Rollo	846.49	Importado de archivo SQL - Categoría 44	2025-05-31 20:38:28.631269
1140	44	POLITUBO 1 1/2 100 mts.	Rollo	1383.51	Importado de archivo SQL - Categoría 44	2025-05-31 20:38:28.649802
1141	44	POLITUBO 2\\'\\' 50 mts.	Rollo	911.45	Importado de archivo SQL - Categoría 44	2025-05-31 20:38:28.666172
1142	45	CHAPA DOBLE PERILLA INTERIOR	Pza	120.30	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.684551
1143	45	CHAPA CHINA	Pza	44.82	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.724786
1144	45	CERRADURA TUBULAR S/PASO	Pza	99.55	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.743111
1145	45	CERRADURA TUBULAR BAÑO	Pza	113.70	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.758851
1146	45	CERRADURA TUBULAR DORMITORIO	Pza	138.49	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.777148
1147	45	CERRADURA TUBULAR ACCESO	Pza	125.20	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.793139
1148	45	CERRADURA CILINDRICA S/PASO	Pza	123.00	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.81012
1149	45	CERRADURA CILINDRICA BAÑO	Pza	131.26	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.826226
1150	45	CERRADURA CILINDRICA DORMITORIO	Pza	154.52	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.841437
1151	45	CERRADURA CILINDRICA ACCESO	Pza	154.52	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.856948
1152	45	CERRADURA SOBREPONER ACCESO	Pza	111.19	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.872569
1153	45	CERR. SOBREPONER ACCESO c/cadena	Pza	131.45	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.889781
1154	45	CERR. SOBREPONER ACCESO c/seguro	Pza	117.08	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.90743
1155	45	PICAPORTE DORADO DE 11/2\\'\\'	Pza	19.03	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.937646
1156	45	PICAPORTE DORADO DE 2\\'\\'	Pza	20.76	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.952687
1157	45	PICAPORTE DE ALUMINIO DE 2\\'\\'	Pza	24.97	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.968347
1158	45	PICAPORTE DE ALUMINIO DE 21/2\\'\\'	Pza.	8.77	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.983542
1159	45	PICAPORTE DE ALUMINIO DE 3\\'\\'	Pza.	11.97	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:28.999605
1160	45	PICAPORTE EMBUTIDO 10 cm.	Pza	14.85	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.015143
1161	45	PICAPORTE EMBUTIDO 15cm.	Pza	29.71	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.030348
1162	45	PICAPORTE EMBUTIDO 30 cm.	Pza	39.48	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.045577
1163	45	PICAPORTE DE BRONCE 15 cm.	Pza	46.06	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.060815
1164	45	BISAGRA SENCILLA DE 2\\'\\'	Par	25.66	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.076155
1165	45	BISAGRA SENCILLA DE 3\\'\\'	Par	17.88	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.091318
1166	45	BISAGRA SENCILLA DE 4\\'\\'	Par	13.98	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.10669
1167	45	BISAGRA SENCILLA DE 5\\'\\'	Par	3.49	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.122209
1168	45	BISAGRA COLONIAL DE 2\\'\\'	Par	6.23	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.137877
1169	45	BISAGRA COLONIAL DE 3\\'\\'	Par	4.70	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.153353
1170	45	CHAPA PAPAIZ c/bola o manivela int.	Pza	216.68	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.168825
1171	45	CHAPA PAPAIZ c/bola o manivela ext.	Pza	143.75	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.183952
1172	45	CHAPA PAPAIZ c/bola o manivela baño	Pza	198.54	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.199225
1173	45	CHAPA BRASIL c/bola o manivela int.	Pza	148.80	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.214385
1174	45	CHAPA BRASIL c/bola o manivela ext.	Pza	156.75	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.229493
1175	45	CHAPA ALIANCA c/bola p/baño	Pza.	51.32	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.244694
1176	45	CHAPA CON ALIANCA c/manivela p/baño	Pza.	51.32	Importado de archivo SQL - Categoría 45	2025-05-31 20:38:29.260808
1177	46	COLMAJUNTAS SL (2.5 Kg.)	Pza	1044.22	Importado de archivo SQL - Categoría 46	2025-05-31 20:38:29.276661
1178	46	IGAS NEGRO (4 Kg.)	Pza	385.35	Importado de archivo SQL - Categoría 46	2025-05-31 20:38:29.291759
1179	46	SELLA TECHOS (0.25 Kg.)	Pza	25.99	Importado de archivo SQL - Categoría 46	2025-05-31 20:38:29.307181
1180	46	TAPAGOTEROS (1.0 Kg.)	Pza	75.06	Importado de archivo SQL - Categoría 46	2025-05-31 20:38:29.322921
1181	46	RED DEVIL ACRILICO SILICONIZADO	Pza	34.78	Importado de archivo SQL - Categoría 46	2025-05-31 20:38:29.338055
1182	47	SOGA DE POLIETILENO DE 1/8\\'\\'	MI.	2.70	Importado de archivo SQL - Categoría 47	2025-05-31 20:38:29.353249
1183	47	SOGA DE POLIETILENO DE 3/16\\'\\'	MI.	4.70	Importado de archivo SQL - Categoría 47	2025-05-31 20:38:29.368731
1184	47	SOGA DE POLIETILENO DE 1/4\\'\\'	MI.	6.67	Importado de archivo SQL - Categoría 47	2025-05-31 20:38:29.385043
1185	47	SOGA DE POLITILENO DE 1/2\\'\\'	MI.	15.00	Importado de archivo SQL - Categoría 47	2025-05-31 20:38:29.401126
1186	47	SOGA DE PLIETILENO DE 5/8\\'\\'	MI.	10.92	Importado de archivo SQL - Categoría 47	2025-05-31 20:38:29.416767
1187	47	SOGA DE PLASTICO 1/4\\'\\'	MI.	3.49	Importado de archivo SQL - Categoría 47	2025-05-31 20:38:29.432283
1188	47	SOGA DE PLASTICO 1/2\\'\\'	MI.	6.05	Importado de archivo SQL - Categoría 47	2025-05-31 20:38:29.447695
1189	47	SOGA DE PLASTICO 3/4\\'\\'	MI.	11.46	Importado de archivo SQL - Categoría 47	2025-05-31 20:38:29.463219
1190	48	TANQUE PLASICO ALVHER 600 Lt.	Pza.	1419.42	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.478603
1191	48	TANQUE DURALIT DE 500 lts. COMPLETO	Pza.	623.63	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.493768
1192	48	TANQUE DURALIT DE 1.000 lts. COMPLETO	Pza.	1687.43	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.509218
1193	48	TANQUE DURALIT DE 2.000 lts. COMPLETO	Pza.	3426.88	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.524739
1194	48	TANQUE CILINDRI. CAMPEON DE 250 lts.	Pza.	722.77	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.539952
1195	48	TANQUE CILINDRI. CAMPEON DE 500 lts.	Pza.	1379.92	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.555844
1196	48	TANQUE CILINDRI. CAMPEON DE 1.000 lts	Pza.	253804.94	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.571166
1197	48	TANQUE CILINDRI. CAMPEON DE 2.000 Lt.	Pza.	5038.55	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.586336
1198	48	TANQUE CILINDRI. CAMPEON DE 5.000 Lt.	Pza.	12089.68	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.602074
1199	48	TANQUE CILINDRI. CAMPEON DE 10.000 Lt.	Pza.	18623.69	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.617731
1200	48	TANQUE CILINDRI. CAMPEON DE 20.000 Lt.	Pza.	29270.88	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.63333
1201	48	TANQUE PLAST. CARMEN  CONIC 1000 Lt.	Pza.	3054.32	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.648324
1202	48	TANQUE PLAST. CARMEN. CONIC. 2000 Lt.	Pza.	4894.44	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.663497
1203	48	CISTERNA PLAST. CARMEN CILINDRICO	2000 Lts.	7191.92	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:29.679057
1204	31	LADRILLO GAMBOTE 18H 25x12x6.5 cm.	Pza	1.15	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:29.694358
1205	31	LADRILLO CELOSIA 12x16x16 cm.	Pza	1.03	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:29.709367
1206	31	LADRILLO 6H 24x15x11.5 cm.	Pza	1.15	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:29.725388
1207	49	TEJA COLOR DE Ho. PLANA	Pza.	5.67	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:29.74059
1208	49	TEJA COLOR DE Ho. DOBLE ROMANA	Pza.	5.67	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:29.755576
1209	49	CUMBRERA COLOR DE HORMIGON	Pza.	10.08	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:29.770687
1210	50	TIERRA SELECCIONADA	M3.	70.25	Importado de archivo SQL - Categoría 50	2025-05-31 20:38:29.786133
1211	50	ABONO VEGETAL (TURBA)	M3.	166.85	Importado de archivo SQL - Categoría 50	2025-05-31 20:38:29.801305
1212	50	ABONO ORGANICO	M3.	149.33	Importado de archivo SQL - Categoría 50	2025-05-31 20:38:29.816455
1213	50	ABONO PREPARADO	M3.	140.57	Importado de archivo SQL - Categoría 50	2025-05-31 20:38:29.831547
1214	50	TIERRA NEGRA	M3.	131.77	Importado de archivo SQL - Categoría 50	2025-05-31 20:38:29.846801
1215	50	TIERRA NATURAL	M3.	61.51	Importado de archivo SQL - Categoría 50	2025-05-31 20:38:29.862041
1216	50	ADOBE DE TIERRA	Pza.	0.52	Importado de archivo SQL - Categoría 50	2025-05-31 20:38:29.88013
1217	50	SEMILLA RAY GRASS	Kg.	70.25	Importado de archivo SQL - Categoría 50	2025-05-31 20:38:29.896013
1218	50	CESPED NATURAL (TEPES)	M2.	24.62	Importado de archivo SQL - Categoría 50	2025-05-31 20:38:29.911801
1219	50	TURBA MOLIDA	M3.	131.77	Importado de archivo SQL - Categoría 50	2025-05-31 20:38:29.928104
1220	52	TUBO Ho. So. DIAMETRO 100mm. x 1.0m.	MI.	18.57	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:29.943463
1221	52	TUBO Ho. So. 120mm.	MI.	33.76	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:29.958572
1222	52	TUBO Ho. So. 150mm.	MI.	42.15	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:29.973623
1223	52	TUBO Ho. So. 200mm.	MI.	60.77	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:29.988737
1224	52	TUBO Ho. So. 250mm.	MI.	106.27	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.00493
1225	52	TUBO Ho. So. 300mm.	MI.	163.67	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.020149
1226	52	TUBO Ho. So. 350mm.	MI.	210.91	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.035521
1227	52	TUBO Ho. So. 400mm.	MI.	308.72	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.050511
1228	52	TUBO Ho. So. 450mm.	MI.	376.25	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.066227
1229	52	TUBO Ho. So. 500mm.	MI.	548.36	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.081299
1230	52	UBO Ho. So. 600mm.	Ml.	639.41	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.09517
1231	52	TUBO Ho. So. 800mm.	MI.	787.93	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.110906
1232	52	TUBO Ho. So. 100mm.	MI.	939.79	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.126523
1233	52	TUBO Ho. So. Perforado Diam.100mm.x1.0m.P/drenaje	MI.	38.80	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.141631
1234	52	TUBO Ho. So. 120mm. P/DRENAJE	Ml.	52.29	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.15659
1235	52	TUBO Ho. So. 150mm. P/DRENAJE	Ml	67.43	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.171521
1236	52	TUBO Ho. So. 200mm. P/DRENAJE	Ml	116.40	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.186805
1237	52	TUBO DE Ho. 16\\'\\' P/DRENAJE	Ml	172.07	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:30.20224
1238	53	TUBO L = 6m. D = 110 mm.	Pza.	50.14	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.217446
1239	53	TUBO L = 6m. D = 160 mm.	Pza.	90.77	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.23288
1240	53	TUBO L = 6m. D = 200 mm.	Pza.	131.10	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.247998
1241	53	TUBO L = 6m. D = 250 mm.	Pza.	191.53	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.262993
1242	53	TUBO L = 6m. D = 315 mm.	Pza.	296.07	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.277954
1243	53	TUBO L = 6m. D = 400 mm.	Pza.	457.24	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.293705
1244	53	TUBO L = 6m. D = 450 mm.	Pza.	614.65	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.308696
1245	53	TUBO L = 6m. D = 500 mm.	Pza.	651.47	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.323885
1246	53	CODO 45º D = 110 mm.	Pza.	34.25	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.339215
1247	53	CODO 45º D = 160 mm.	Pza.	73.05	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.354994
1248	53	CODO 90º D = 110 mm.	Pza.	78.48	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.369962
1249	53	CODO 90º D = 160 mm.	Pza.	166.21	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.38486
1250	53	TEE REDUCIDA  D = 110 mm.	Pu.	109.37	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.39991
1251	53	TEE REDUCIDA  D = 160 mm.	Pza.	308.60	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.415917
1252	53	YEE REDUCIDA  D = 110 mm.	Pza.	155.38	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.431038
1253	53	YEE REDUCIDA  D = 160mm.	Pza.	359.73	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.446221
1254	53	ADAPTADOR Espiga 4 x 110 mm.	Pza.	30.35	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.461911
1255	53	ADAPTADOR Espiga 6 x 160 mm.	Pza.	61.23	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.477427
1256	53	ADAPTADOR Espiga 8 x 200 mm.	Pza.	102.09	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.492493
1257	53	SILAS YEE D = 160 x 110 mm.	Pza.	60.41	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.508183
1258	53	SILAS YEE D = 200 x 110 mm.	Pza.	97.53	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.523448
1259	53	SILAS YEE D = 200 x 160 mm.	Pza.	158.61	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.539009
1260	53	SILAS YEE D = 250 x 110 mm.	Pza.	118.11	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.554321
1261	53	SILAS YEE D = 250 x 160 mm.	Pza.	165.85	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.569425
1262	53	SILAS YEE D = 315 x 110 mm.	Pza.	119.08	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.584662
1263	53	SILAS YEE D = 315 x 160 mm.	Pza.	167.19	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.599794
1264	53	SILAS  YEE D = 400 x 110 mm.	Pza.	121.12	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.61595
1265	53	SILAS YEE D = 400 x 160 mm.	Pza.	170.40	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.631799
1266	53	SILAS YEE D = 450 x 110 mm.	Pza.	722.58	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.646833
1267	53	SILAS YEE D = 450 x 160 mm.	Pza.	1013.31	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.661736
1268	53	SILAS YEE D = 500 x 110 mm.	Pza.	880.58	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.676939
1269	53	SILAS YEE D = 500 x 160 mm.	Pza.	1237.05	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.692052
1270	53	SILAS TEE D = 160 x 110 mm.	Pza.	60.41	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.707466
1271	53	SILAS TEE D = 200 x 110 mm.	Pza.	97.53	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.722833
1272	53	SILAS TEE D = 200 x 160 mm.	Pza.	158.61	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.738215
1273	53	SILAS TEE D = 250 x 110 mm.	Pza.	118.11	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.754381
1274	53	SILAS TEE D = 250 x 160 mm.	Pza.	165.85	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.769943
1275	53	SILAS TEE D = 315 x 110 mm.	Pza.	119.08	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.786207
1276	53	SILAS TEE D = 315 x 160 mm.	Pza.	167.19	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.80136
1277	53	SILAS TEE D = 400 x 110 mm.	Pza.	121.12	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.817772
1278	53	SILAS TEE D = 400 x 160 mm.	Pza.	170.40	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.833276
1279	53	SILAS TEE D = 450 x 110 mm.	Pza.	722.58	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.848663
1280	53	SILAS TEE D = 450 x 160 mm.	Pza.	1013.31	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.863711
1281	53	SILAS TEE D = 500 x 110 mm.	Pza.	879.02	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.879204
1282	53	SILAS TEE D = 500 x 160 mm.	Pza.	1237.05	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:30.894483
1283	54	COLLAR DE DERIV. 2\\'\\'x1/2 PAVCO	Pza.	29.48	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:30.909651
1284	54	COLLAR DE DERIV. 2\\'\\'x3/4\\'\\' PAVCO	Pza.	29.48	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:30.924765
1285	54	COLLAR DE DERIV. 2 1/2\\'\\'x3/4\\'\\' PAVCO	 Pza.	35.46	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:30.940073
1286	54	COLLAR DE DERIV. 3\\'\\'x1/2\\'\\' PAVCO	Pza.	43.07	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:30.955213
1287	54	COLLAR DE DERIV. 3\\'\\'x3/4\\'\\' PAVCO	Pza.	43.07	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:30.970327
1288	54	COLLAR DE DERIV. 4x1/2\\'\\' PAVCO	Pza.	51.45	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:30.985673
1289	54	COLLAR DE DERIV. 4\\'\\'x3/4\\'\\' PAVCO	Pza.	51.45	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.00087
1290	54	COLLAR DE DERIV. 6\\'\\'x1/2\\'\\' PAVCO	Pza.	75.95	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.016355
1291	54	COLLAR DE DERIV. 6\\'\\'x3/4\\'\\' PAVCO	Pza	75.95	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.03175
1292	54	COLLAR DE DERIV. 8\\'\\'x1\\'\\' PAVCO	Pza.	226.89	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.047246
1293	54	TUBO DESAGUE PVC L= 4 m. 1 1/2\\'\\'	Tubo	38.29	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.062599
1294	54	TUBO DESAGUE PVC L= 4m. 42\\'\\'	Tubo	55.00	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.078487
1295	54	TUBO DESAGUE PVC L= 4 m. 3\\'\\'	Tubo	80.15	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.09376
1296	54	TUBO DESAGUE PVC L= 4 m. 4\\'\\'	Tubo	95.65	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.109035
1297	54	TUBO DESAGUE PVC L= 6m. 6\\'\\'	Tubo	103.76	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.124975
1298	54	TUBO ROSCA PVC L= 6 m. 1/2\\'\\'	Tubo	47.78	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.141141
1299	54	TUBO ROSCA PVC L= 6 m. 3/4\\'\\'	Tubo	62.99	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.156539
1300	54	TUBO ROSCA PVC L= 6 m. 1\\'\\' clase 6 (NB)	Tubo	94.47	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.171757
1301	54	TUBO ROSCA PVC L= 6 m. 1 1/2\\'\\'	Tubo	155.21	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.187509
1302	54	TUBO (JS) PVC  L=4m. 2\\'\\'	Tubo	40.84	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.202672
1303	54	TUBO (JS) PVC  L= 4m. 3\\'\\'	Tubo	54.33	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.217475
1304	54	TUBO (JS) PVC  L= 4m. 4\\'\\'	Tubo	79.96	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.233177
1305	54	TUBO (JS) PVC  L= 4m. 6\\'\\'	Tubo	120.94	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.248901
1306	54	TUBO (JS) PVC  L=6m. 1/2\\'\\'	Tubo	55.71	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.264547
1307	54	TUBO (JS) PVC  L= 6m. 3/4	Tubo	70.72	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.279655
1308	54	TUBO (JS) PVC  L= 6m. 1\\'\\'	Tubo	111.51	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.294805
1309	54	TUBO (JR-JS) PVC  L= 6m. 3\\'\\'	Tubo	176.51	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.309982
1310	54	TUBO (JR-JS) PVC  L= 6m. 4\\'\\'	Tubo	241.77	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.325353
1311	54	TUBO (JR -JS) PVC  L= 6m. 6\\'\\'	Tubo	394.13	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.342258
1312	54	TUBO (JR-JS) PVC  L=6m. 8\\'\\' clase 9 (NB)	Tubo	475.79	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.358276
1313	54	TUBO (JR-JS) PVC  L= 6m. 2\\'\\'	Tubo	669.16	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.374036
1314	54	TUBO (JR-JS) PVC  L= 6m. 6\\'\\'	Tubo	87.42	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.392068
1315	54	TUBO (JR-JS) PVC  L= 6m. 8\\'\\' clase 12 (NB)	Tubo	163.67	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.407322
1316	25	LIJA PARA MADERA	Hoja	4.83	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:31.426258
1317	54	TUBO (JS) PVC  L= 6m. 3/4\\'\\'	Pza.	60.03	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.442159
1318	54	TUBO (JR-JS) PVC  L= 6m. 3\\'\\'	Pza.	6.23	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.45962
1319	54	COPLAS 1\\'\\' PVC	Pza.	8.41	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.475114
1320	54	COPLAS 1 1/2\\'\\' PVC TIGRE - BRAS.	Pza.	16.72	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.490492
1321	54	COPLAS 2\\'\\' PVC TIGRE - BRAS.	Pza.	23.44	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.507004
1322	54	UNION UNIVERSAL 1/2\\'\\' PVC TIGRE- BRAS.	Pza.	12.48	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.525051
1323	54	UNION UNIVERSAL 3/4\\'\\' PVC TIGRE - BRAS.	Pza.	16.72	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.541494
1324	54	UNION UNIVERSAL 1\\'\\' PVC TIGRE - BRAS.	Pza.	21.09	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.556683
1325	54	UNION UNIVERSAL 1 1/2\\'\\' PVC TIGRE - BRAS.	Pza.	49.43	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.572664
1326	54	UNION UNIVERSAL 2\\'\\' PVC TIGRE - BRAS.	Pza.	64.45	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.587754
1327	54	CODO PVC P/DESAGUE 2\\'\\'	Pza.	8.11	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.602777
1328	54	CODO PVC P/DESAGUE 2 1/2\\'\\'	Pza.	10.08	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.623017
1329	54	CODO PVC P/DESAGUE 3\\'\\'	Pza.	15.31	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.638339
1330	54	CODO PVC P/DESAGUE 4\\'\\'	Pza.	17.49	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.655244
1331	54	TEE PVC P/DESAGUE 2\\'\\'	Pza.	10.08	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.670709
1332	54	TEE PVC P/DESAGUE 2 1/2\\'\\'	Pza.	13.69	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.728255
1333	54	TEE PVC P/DESAGUE 3\\'\\'	Pza.	18.02	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.743575
1334	54	TEE PVC P/DESAGUE 4\\'\\'	Pza.	6.95	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.759062
1335	54	YEE PVC P/DESAGUE 2\\'\\'	Pza.	9.95	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.773308
1336	54	YEE PVC P/DESAGUE 2 1/2\\'\\'	Pza.	13.98	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.788677
1337	54	YEE PVC P/DESAGUE 3\\'\\'	Pza.	18.38	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.803987
1338	54	YEE PVC P/DESAGUE 4\\'\\'	Pza.	25.66	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.819069
1339	54	YEE REDUCCION PVC PARA DESAGUE 4\\'\\'x 1 1/2\\'\\'	Pza.	17.58	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.834424
1340	54	YEE REDUCCION PVC PARA DESAGUE 4\\'\\'x 2\\'\\'	Pza.	19.56	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.852533
1341	54	YEE REDUCCION PVC PARA DESAGUE 4\\'\\'x 2 1/2\\'\\'	Pza.	21.58	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.870087
1342	54	YEE REDUCCION PVC PARA DESAGUE 4\\'\\'x 3\\'\\'	Pza.	24.13	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.885948
1343	54	YEE REDUCCION PVC PARA DESAGUE 3\\'\\'x 2\\'\\'	Pza.	19.93	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.90122
1344	54	CAJA CIFONADA PVC ( 3 ENTRADAS)	Pza.	97.53	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.917489
1345	54	CAJA CIFONADA PVC (4 ENTRADAS)	Pza.	83.17	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.933005
1346	54	CODO PVC E=40 P/DESAGUE 1 1/2\\'\\'	Pza.	12.48	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.949109
1347	54	CODO PVC E=40 P/DESAGUE 2\\'\\'	Pza.	15.00	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.964737
1348	54	CODO PVC E=40 P/DESAGUE 2 1/2\\'\\'	Pza.	31.45	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.980491
1349	54	CODO PVC E=40 P/DESAGUE 3\\'\\'	Pza.	47.59	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:31.995674
1350	54	CODO PVC E=40 P/DESAGUE 4\\'\\'	Pza.	68.35	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.011186
1351	54	YEE PVC E=40 P/DESAGUE 1 1/2\\'\\'	Pza.	16.72	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.026976
1352	54	YEE PVC E=40 P/DESAGUE 2\\'\\'	Pza.	22.51	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.042151
1353	54	YEE PVC E=40 P/DESAGUE 2 1/2\\'\\'	Pza.	47.56	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.057392
1354	54	YEE PVC E=40 P/DESAGUE 3\\'\\'	Pza.	62.07	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.072664
1355	54	YEE PVC E=40 P/DESAGUE 4\\'\\'	Pza.	68.16	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.088069
1356	54	TEE PVC E=40 P/DESAGUE 2\\'\\'	Pza.	19.44	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.103962
1357	54	TEE PVC E=4O P/DESAGUE 21/2\\'\\'	Pza.	41.65	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.119205
1358	54	TEE PVC E=4O PIDESAGUE 3\\'\\'	Pza.	54.13	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.134511
1359	54	TEE PVC E=40 PIDESAGUE 4\\'\\'	Pza.	81.84	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.151111
1360	54	CAJA RECEPTORA P/DESAGUE 6\\'\\'x20 cm	Pza.	146.76	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.169447
1361	54	CAJA RECEPTORA P/DESAGUE 6\\'\\'x25 cm	Pza.	167.46	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.184582
1362	54	CAJA RECEPTORA P/DESAGUE 6\\'\\'x30 cm	Pza.	186.27	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.199656
1363	54	CAJA RECEPTORA P/DESAGUE 6\\'\\'x35 cm	Pza.	205.67	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.214801
1364	54	CAJA RECEPTORA P/DESAGUE 6\\'\\'x40 cm	Pza.	226.60	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.229927
1365	54	CODO PVC CLASE 9 P/DESAGUE 2\\'\\'	Pza.	12.83	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.245888
1366	54	CODO PVC CLASE 9 P/DESAGUE 4\\'\\'	Pza.	60.25	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.26166
1367	54	YEE PVC CLASE 9 P/DESAGUE 2\\'\\'	Pza.	17.88	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.277332
1368	54	YEE PVC CLASE 9 P/DESAGUE 4\\'\\'	Pza.	74.72	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.297508
1369	54	TEE PVC CLASE 9 P/DESAGUE 2\\'\\'	Pza.	15.00	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.313229
1370	54	TEE PVC CLASE 9 P/DESAGUE 4\\'\\'	Pza.	73.58	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.333431
1371	54	CODO DE 90º DE 1/2\\'\\'	Pza.	3.05	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.349458
1372	54	CODO DE 90º DE 3/4\\'\\'	Pza.	4.23	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.364843
1373	54	CODO DE 90º DE 1\\'\\'	Pza.	28.36	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.380289
1374	54	CODO DE 45º DE 1/2\\'\\'	Pza.	11.32	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.395564
1375	54	CODO DE 45º DE 1/2\\'\\'	Pza.	16.03	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.410709
1376	54	CODO DE 45º DE 1\\'\\'	Pza.	21.09	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.425967
1377	54	CODO DE 90º DE 3/4\\'\\'	Pza.	55.34	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.441087
1378	54	CODO 90º (JR) 3\\'\\'	Pza.	70.00	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.456003
1379	54	CODO 90º (JR) 4\\'\\'	Pza.	142.55	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.471411
1380	54	CODO 90º 6\\'\\'	Pza.	476.28	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.486734
1381	54	CODO 90º 8\\'\\'	Pza.	1167.55	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.502079
1382	54	CODO 45º 1/2\\'\\'	Pza.	3.71	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.518028
1383	54	CODO 45º 3/4\\'\\'	Pza.	5.53	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.532252
1384	54	CODO 45º 1\\'\\'	Pza.	7.95	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.547763
1385	54	CODO 45º 1 1/2\\'\\'	Pza.	16.89	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.563658
1386	54	CODO 45º  2\\'\\'	Pza.	29.48	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.578983
1387	54	CODO 45º 2 1/2\\'\\'	Pza.	60.77	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.594242
1388	54	CODO 45º 3\\'\\'	Pza.	70.84	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.609565
1389	54	CODO 45º 4\\'\\'	Pza.	127.03	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.624701
1390	54	CODO 45º 6\\'\\'	Pza.	487.26	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.640771
1391	54	CODO 46º 8\\'\\'	Pza.	1118.62	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.656095
1392	54	CODO DE 90º REDUCCION DE 3/4\\'\\'x1/2\\'\\'	Pza.	4.08	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.671366
1393	54	CODO DE 90º REDUCCION 1\\'\\'x3/4\\'\\'	Pza.	5.03	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.68668
1394	54	REDUCCION 3/4\\'\\'x1/2\\'\\'	Pza.	2.22	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.702068
1395	54	REDUCCION 1\\'\\'x1/2\\'\\'	Pza.	2.85	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.717473
1396	54	REDUCCION 1\\'\\'x3/4\\'\\'	Pza.	4.41	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.732736
1397	54	COPLA 1 1/4\\'\\'	Pza.	5.74	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.748043
1398	54	COPLA 1 1/2\\'\\'0	Pza.	7.95	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.763585
1399	54	COPLA 2\\'\\'	Pza.	12.31	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.778845
1400	54	COPLA 2 1/2\\'\\'	Pza.	25.30	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.793974
1401	54	COPLA 3\\'\\'	Pza.	37.60	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.809092
1402	54	COPLA 4\\'\\'	Pza.	64.45	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.824781
1403	54	TAPON HEMBRA 1/2\\'\\'	Pza.	2.36	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.840128
1404	54	TAPON HEMBRA 3/4\\'\\'	Pza.	3.05	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.856009
1405	54	TAPON HEMBRA 1\\'\\'	Pza.	3.71	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.871531
1406	54	TAPON MACHO 1/2\\'\\'	Pza.	7.77	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.886798
1407	54	TAPON MACHO 3/4\\'\\'	Pza.	12.83	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.901983
1408	54	TAPON MACHO 1\\'\\'	Pza.	26.68	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.917252
1409	54	TAPON HEMBRA 3\\'\\'	Pza.	32.02	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.932573
1410	54	TAPON HEMBRA 4\\'\\'	Pza.	64.45	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.948031
1411	54	TAPON HEMBRA 6\\'\\'	Pza.	226.60	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.963785
1412	54	UNION UNIVERSAL 1/2\\'\\'	Pza.	16.48	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.980401
1413	54	UNION UNIVERSAL 3/4\\'\\'	Pza.	18.88	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:32.998096
1414	54	UNION UNIVERSAL 1\\'\\'	Pza.	27.66	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.013535
1415	25	CARRETILLA SIN NEUMATICO	Pza.	316.65	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:33.028838
1416	54	TEE 3/4\\'\\'	Pza.	30.07	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.043948
1417	54	TEE 1\\'\\'	Pza.	72.05	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.058297
1418	54	TEE 3\\'\\'	Pza.	81.01	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.07369
1419	54	TEE 4\\'\\'	Pza.	165.02	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.088903
1420	54	TEE 8\\'\\'	Pza.	730.93	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.104166
1421	54	TEE REDUCCION 3/4\\'\\'x1/2\\'\\' C/ROSCA	Pza.	12.31	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.12221
1422	54	TEE REDUCCION 1\\'\\'x3/4\\'\\' C/ROSCA	Pza.	17.22	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.137617
1423	54	TEE REDUCCION (JR) 4\\'\\'x3\\'\\'	Pza.	730.93	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.152885
1424	54	TEE REDUCCION (JR) 8\\'\\'x4\\'\\'	Pza.	730.93	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.168393
1425	54	ADAPTADOR MACHO 1/2\\'\\'	Pza.	2.00	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.183891
1426	54	ADAPTADOR MACHO 3/4\\'\\'	Pza.	2.56	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.19892
1427	54	ADAPTADOR MACHO 1\\'\\'	Pza.	4.41	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.213952
1428	54	ADAPTADOR MACHO 1 1/4\\'\\'	Pza.	6.75	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.229145
1429	54	ADAPTADOR MACHO 1 1/2\\'\\'	Pza.	8.11	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.244197
1430	54	ADAPTADOR MACHO 2\\'\\'	Pza.	10.99	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.259563
1431	54	ADAPTADOR MACHO 3\\'\\'	Pza.	81.98	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.275182
1432	54	ADAPTADOR MACHO 4\\'\\'	Pza.	105.10	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.290629
1433	54	ADAPTADOR HEMBRA 1 1/2\\'\\'	Pza.	10.45	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.305729
1434	54	ADAPTADOR HEMBRA 2\\'\\'	Pza.	16.03	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.320909
1435	54	CRUZ  1\\'\\'	Pza.	29.89	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.336229
1436	54	CRUZ 1 1/2\\'\\'	Pza.	43.33	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.35371
1437	54	CRUZ 2\\'\\'	Pza.	65.27	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.368979
1438	54	CRUZ 4\\'\\'	Pza.	254.77	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.384606
1439	54	REDUCCION 3/4 x 1/2\\'\\'	Pza.	1.67	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.399803
1440	54	REDUCCION  1\\'\\' x 1/2\\'\\'	Pza.	2.56	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.416278
1441	54	REDUCCION 1\\'\\' x 3/4\\'\\'	Pza.	2.56	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.431699
1442	54	REDUCCION 3/4\\'\\'x1/2\\'\\'	Pza.	8.77	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.44686
1443	54	REDUCCION  1\\'\\'x1/2\\'\\'	Pza.	8.77	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.46186
1444	54	REDUCCION  1\\'\\'x3/4\\'\\'	Pza.	8.41	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.476995
1445	54	REDUCCION  11/2\\'\\'x3/4\\'\\'	Pza.	11.67	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.492527
1446	54	REDUCCION  3\\'\\'x2\\'\\'	Pza.	11.67	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.508295
1447	54	REDUCCION  4\\'\\'x2\\'\\'	Pza.	11.67	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.52443
1448	54	REDUCCION BUJE 2\\'\\'x 1 1/2\\'\\'	Pza.	11.67	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.539724
1449	54	REDUCCION BUJE 2 1/2\\'\\' x 2\\'\\'	Pza.	16.17	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.554404
1450	54	REDUCCION BUJE 3\\'\\' x 2\\'\\'	Pza.	29.48	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.569594
1451	54	REDUCCION BUJE 3\\'\\' x 2 1/2\\'\\'	Pza.	29.48	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.585014
1452	54	REDUCCION BUJE 4\\'\\'x2\\'\\'	Pza.	55.34	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.60016
1453	54	REDUCCION BUJE 4\\'\\' x 3\\'\\'	Pza.	55.34	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.61545
1454	54	REDUCCION BUJE 6\\'\\' x 3\\'\\'	Pza.	221.51	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.630769
1455	54	REDUCCION BUJE 6\\'\\' x 4\\'\\'	Pza.	221.51	Importado de archivo SQL - Categoría 54	2025-05-31 20:38:33.64604
1456	55	CAÑERIA HIDRO 3- 1/2\\'\\'	Pza.	95.98	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.668582
1457	55	CAÑERIA HIDRO 3- 3/4\\'\\'	Pza.	149.63	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.691497
1458	55	CAÑERIA HIDRO 3- 1\\'\\'	Pza.	220.01	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.706817
1459	55	CAÑERIA HIDRO 3 COVERTHOR 1/2\\'\\'	Pza.	113.88	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.722039
1460	55	CAÑERIA HIDRO 3 COVERTHOR 3/4\\'\\'	Pza.	178.30	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.736249
1461	55	CAÑERIA HIDRO 3 COVERTHOR 1\\'\\'	Pza.	267.95	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.752096
1462	55	CODO IPS ROSCA 3 1/2\\'\\'	Pza.	3.35	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.767124
1463	55	CODO IPS ROSCA 3/4\\'\\'	Pza.	4.89	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.782827
1464	55	CODO IPS ROSCA 1\\'\\'	Pza.	14.15	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.797948
1465	55	CODO IPS ROSCA 1 1/2\\'\\'	Pza.	15.36	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.814667
1466	55	CODO IPS ROSCA 2\\'\\'	Pza.	35.61	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.829722
1467	55	TEE 1/2\\'\\'  ROSCA	Pza.	4.89	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.845131
1468	55	TEE 3/4  ROSCA	Pza.	7.11	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.868231
1469	55	TEE 1\\'\\'  ROSCA	Pza.	14.15	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.884093
1470	25	LIJA PARA PARED	Hoja	4.83	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:33.900888
1471	55	CRUZ 3/4\\'\\' IPS ROSCA	Pza.	14.52	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.915998
1472	55	CRUZ 1\\'\\' IPS ROSCA	Pza.	39.13	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.931116
1473	55	CRUZ 1 1/2\\'\\' IPS ROSCA	Pza.	41.33	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.947001
1474	55	CRUZ 2\\'\\' IPS ROSCA	Pza.	61.23	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.962645
1475	55	CODO HIDRO 3 FUSION 1/2\\'\\'	Pza.	5.21	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.977726
1476	55	CODO HIDRO 3 FUSION 3/4\\'\\'	Pza.	8.27	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:33.993136
1477	55	CODO HIDRO 3 FUSION 1\\'\\'	Pza.	11.97	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.008528
1478	55	CODO HIDRO 3 FUSION 1 1/2\\'\\'	Pza.	52.62	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.024084
1479	55	CODO HIDRO 3 FUSION 2\\'\\'	Pza.	77.77	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.039464
1480	55	TEE 3/4\\'\\' HIDRO 3 FUSION	Pza.	12.31	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.054719
1481	55	TEE 1\\'\\' HIDRO 3 FUSION	Pza.	18.57	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.069738
1482	55	TEE 1 1/2\\'\\' HIDRO 3 FUSION	Pza.	73.58	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.084809
1483	55	CUPLA 3/4\\'\\' HIDRO 3 FUSION	Pza.	6.75	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.099939
1484	55	CUPLA 1\\'\\' HIDRO 3 FUSION	Pza.	9.80	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.115161
1485	55	CUPLA 1 1/2\\'\\' HIDRO 3 FUSION	Pza.	37.11	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.130576
1486	55	CUPLA 2\\'\\' HIDRO 3 FUSION	Pza.	69.17	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.145621
1487	55	UNION DOBLE FUSION 1\\'\\' HIDRO 3	Pza.	62.27	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.160606
1488	55	UNION DOBLE FUSION 1 1/2\\'\\' HIDRO 3	Pza.	112.37	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.176027
1489	55	UNION DOBLE FUSION 2\\'\\' HIDRO 3	Pza.	232.85	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.191027
1490	55	TUBERIA 1/2\\'\\' x 3.OO Mts. PAVCO	Pza.	54.50	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.207489
1491	55	TUBERIA 3/4\\'\\' x 3.OO Mts. PAVCO	Pza.	92.11	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.222705
1492	55	TUBERIA 1\\'\\' x 3.00 Mts. PAVCO	Pza.	164.00	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.237718
1493	55	CODO 90º  1/2\\'\\' C/C PAVCO	Pza	3.19	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.252749
1494	55	CODO 9Oº 3/4\\'\\' C/C PAVCO	Pza	6.75	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.267233
1495	55	CODO 45º 1/2\\'\\' C/C PAVCO	Pza	4.70	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.282916
1496	55	CODO 45\\'\\' 3/4\\'\\' C/C PAVCO	Pza	9.65	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.297913
1497	55	CODO 9Oº 1/2\\'\\' Camp./Rosca PAVCO	Pza	20.76	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.312925
1498	55	TEE 1/2\\'\\' PAVCO	Pza	4.70	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.328149
1499	55	TEE 3/4\\'\\' PAVCO	Pza	9.48	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.343682
1500	55	COPLA 1/2\\'\\' PAVCO	Pza	3.71	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.358806
1501	55	COPLA 3/4\\'\\' PAVCO	Pza	4.41	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.374023
1502	55	ADAPTADOR MACHO 1/2\\'\\' PAVCO	Pza	3.71	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.389116
1503	55	ADAPTADOR MACHO 3/4\\'\\' PAVCO	Pza	5.88	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.404409
1504	55	ADAPTADQR HEMBRA 1/2\\'\\' PAVCO	Pza	6.58	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.419627
1505	55	ADAPTADOR HEMBRA 3/4\\'\\' PAVCO	Pza	7.95	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.434874
1506	55	TAPON HEMBRA 3/4\\'\\' PAVCO	Pza	6.05	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.449997
1507	55	TAPON HEMBRA 1/2\\'\\' PAVCO	Pza	4.89	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.466194
1508	55	UNION PATENTE 1/2\\'\\' PAVCO	Pza	46.75	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.481461
1509	55	UNION PATENTE 3/4\\'\\' PAVCO	Pza	65.27	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.496688
1510	55	REDUCCION BUJE 3/4\\'\\' x l/2\\'\\' PAVCO	Pza	2.36	Importado de archivo SQL - Categoría 55	2025-05-31 20:38:34.511824
1511	56	VIDRIO PLANO INCOLORO 2mm.	M2	72.23	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.52698
1512	56	VIDRIO PLANO INCOLORO 3 mm.	M2.	86.27	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.542236
1513	56	VIDRIO PLANO INCOLORO 4 mm.	M2.	142.92	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.55827
1514	56	VIDRIO PLANO INCOLORO 5 mm.	M2.	166.69	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.573414
1515	56	VIDRIO PLANO INCOLORO 6 mm.	M2.	197.71	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.588629
1516	56	VIDRIO PLANQ INCOLORO 8 mm.	M2.	323.60	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.603879
1517	56	VIDRIO PLANO INCOLORO 10 mm.	M2.	423.30	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.619024
1518	56	VIDRIO CATEDRAL INCOLORO 3 mm.	M2.	84.53	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.63404
1519	56	VIDRIO CATEDRAL INCOLORO 4mm.	M2.	89.75	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.649026
1520	56	VIDRIO CATEDRAL COLOR 4 mm.	M2.	120.80	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.663908
1521	56	VIDRIO CATEDRAL COLOR 5 mm.	M2.	158.94	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.678772
1522	56	VIDRIO RAYBAN C/ BRONCE 3 mm.	M2.	175.28	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.693737
1523	56	VIDRIO RAYBAN C/ BRON. GRIS 4 mm.	M2.	204.67	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.709201
1524	56	VIDRIO RAYBAN C/ BRON. GRIS 5 mm.	M2.	241.25	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.724454
1525	56	VIDRIO COLOMBIANO VIDRIO CLARO 2 mm. (2.40 x 1.27)	M2.	44.00	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.739716
1526	56	VIDRIO COLOMBIANO VIDRIO CLARO 3 mm. (2.40 x 1.60)	M2.	61.09	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.755539
1527	56	VIDRIO COLOMBIANO VIDRIO CLARO 4 mm. (2.40 x 2.00)	M2.	90.40	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.770628
1528	56	VIDRIO COLOMBIANO VIDRIO CLARO 5 mm. (2.40 x 2.00)	M2.	115.92	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.785531
1529	56	VIDRIO COLOMBIANO VIDRIO CLARO 6 mm. (2.40 x 2.00)	M2	143.60	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.800499
1530	56	VIDRIO COLOMBIANO VIDRIO BRONCE 3 mm. (2.40 x 1.60)	M2.	71.39	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.815584
1531	56	VIDRIO COLOMBIANO VIDRIO BRONCE 4 mm. (2.40 x 2.00)	M2.	97.86	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.830744
1532	56	VIDRIO COLOMBIANO VIDRIO BRONCE 5 mm. (2.40 x 2.00)	M2.	122.35	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.846525
1533	56	VIDRIO COLOMBIANO VIDRIO BRONCE 6 mm. (2.40 x 2.00)	M2.	148.68	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.862034
1534	56	VIDRIO COLOMBIANO VIDRIO ESPEJO 3 mm. (2.40 x 1.40)	M2.	101.60	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.877171
1535	56	VIDRIO COLOMBIANO VIDRIO CATEDRAL 3 mm. (1.30 x 2.20)	M2.	57.01	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.892338
1536	56	VIDRIO COLOMBIANO VIDRIO CATEDRAL 3 mm. (1.30 x 240)	M2.	57.19	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.907447
1537	56	VIDRIO COLOMBIANO VIDRIO CATEDRAL 4 mm. (1.30 x 2.20)	M2.	81.01	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.934288
1538	56	VIDRIO COLOMBIANO VIDRIO CATEDRAL BRONCE 4 mm. (1.30 x 2.40)	M2.	91.93	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.949311
1539	56	VIDRIO MEXICANO VIDRIO CLARO FLOAT MEXICANO 3 mm. (1.83 x 2.44)	M2.	77.27	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.964321
1540	56	VIDRIO MEXICANO VIDRIO CLARO FLOAT MEXICANO 4 mm. (2.13 x 3.30)	M2.	102.09	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.979437
1541	56	VIDRIO MEXICANO VIDRIO CLARO FLOAT MEXICANO 5 mm. (2.13 x 3.30)	M2.	131.77	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:34.994483
1542	56	VIDRIO MEXICANO VIDRIO CLARO FLOAT MEXICANO 6 mm. (2.44 x 3.30)	M2.	160.12	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.011204
1543	56	VIDRIO MEXICANO VIDRIO CLARO FLOAT MEXICANO 9.5 mm. (2.44 x 3.30)	M2.	287.94	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.026338
1544	56	VIDRIO MEXICANO VIDRIO BRONCE GRIS MEXICANO 4 mm. (3.30 x 2.13)	M2.	120.15	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.041519
1545	56	VIDRIO MEXICANO VIDRIO BRONCE GRIS MEXICANO 5 mm. (3.30 x 2.13)	M2.	148.14	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.056799
1546	56	VIDRIO MEXICANO VIDRIO BRONCE GRIS MEXICANO 6 mm. (3.30 x 2.13)	M2.	182.04	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.071849
1547	56	VIDRIO MEXICANO VIDRIO AZUL PIROLITICO MEXICANO 6mm. (2.13 x 3.30)	M2	355.68	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.087032
1548	56	VIDRIO MEXICANO VIDRIO VITROSOL PIROLITICO MEXICANO 6 mm. (2.13 x 3.30)	M2	320.90	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.102346
1549	56	VIDRIO MEXICANO VIDRIO TINTEX PIROLITICO MEXICANO 6 mm. (2.30 x 3.30)	M2.	320.90	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.117676
1550	56	VIDRIO MEXICANO ESPEJO INCOLORO 3mm.	 M2.	171.94	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.133023
1551	56	VIDRIO MEXICANO ESPEJO INCOLORO 4mm.	 M2.	234.32	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.148188
1552	56	VIDRIO MEXICANO ESPEJO INCOLORO 5 mm.	M2.	265.21	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.163417
1553	56	VIDRIO MEXICANO ESPEJO COLOR BRONCE-GRIS 3 mm	M2.	267.58	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.178635
1554	56	VIDRIO MEXICANO ESPEJO COLOR BRONCE-GRIS 4 mm	M2.	271.14	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.193828
1555	56	VIDRIO MEXICANO ESPEJO COLOR BRONCE-GRIS 5 mm	M2.	304.00	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.20891
1556	56	VIDRIO MEXICANO VIDRIO LAMINADO INCOLORO 6 mm.	M2.	865.53	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.224082
1557	56	VIDRIO MEXICANO VIDRIO LAMINADO COLOR 5mm.	M2.	842.91	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.239079
1558	56	VIDRIO MEXICANO VIDRIO  LAMINADO COLOR 6 mm.	M2.	890.65	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.253227
1559	25	MASILLA PARA VIDRIO	Kgr.	8.03	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:35.268523
1560	56	BURLETE PARA VIDRIO (50 M)	ROLLO	224.53	Importado de archivo SQL - Categoría 56	2025-05-31 20:38:35.283732
1561	1	FIERRO CORRUGADO	Kg.	11.30	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:35.299843
1562	16	CEMENTO BLANCO	Kgr.	7.16	Importado de archivo SQL - Categoría 16	2025-05-31 20:38:35.315153
1563	16	CEMENTO PORTLAND FANCESA (50 Kgr. 47,5BS)	Kg	1.00	Importado de archivo SQL - Categoría 16	2025-05-31 20:38:35.331032
1564	57	GASOLINA ESPECIAL	Lt.	5.99	Importado de archivo SQL - Categoría 57	2025-05-31 20:38:35.346084
1565	57	GASOLINA PREMIUM	Lt.	7.66	Importado de archivo SQL - Categoría 57	2025-05-31 20:38:35.36155
1566	57	GAS LICUADO	Kgr.	3.58	Importado de archivo SQL - Categoría 57	2025-05-31 20:38:35.376744
1567	57	DIESEL	Lt.	5.96	Importado de archivo SQL - Categoría 57	2025-05-31 20:38:35.391686
1568	32	BALDOSA PARA PISO DE (5x40x60cm.)	Pza.	22.48	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:35.407195
1569	32	BALDOSA PARA PISO DE (5x30x30cm.)	M2	62.60	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:35.42235
1570	14	CAMARA SEPTICA DE 250 Lt.	Pza.	630.30	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:35.438038
1571	14	CAMARA SEPTICA 2.000	Pza.	4320.17	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:35.453187
1572	14	CAMARA SEPTICA 5.000	Pza	10688.71	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:35.468393
1573	14	CAMARA SEPTICA DE 10.000	Pza:	16814.94	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:35.483372
1574	29	BAÑO FORRUM-DORICA 3PZA COMPLETA	Jgo.	3363.14	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.498258
1575	29	BAÑO DECA-MONTECARLO 3 PZA CIACC	Jgo.	3033.51	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.513143
1576	29	BAÑERA 1.50x0.70 CON GRIFERIA	Pza.	1705.08	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.528173
1577	29	BAÑERA 1.67x0.75 CON GRIFERIA	Pza	1868.29	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.542191
1578	29	BAÑ. HIDROM. 1.70x0.80 C/MOT	Pza	1833.00	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.557358
1579	29	BAÑ.HIDROM. CIRC. D=1.5m. C/MOT.	Pza.	5555.83	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.572495
1580	29	BAÑ. HIDROM. CIRC. D=1.8m. C/MOT	Pza.	7395.22	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.587944
1581	29	BAÑ. HIDROM. ESQUI. R=1.5m. C/MOT	Pza.	7893.57	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.602967
1582	29	INODORO FERRUM - DORICA	Pza.	2080.97	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.618219
1583	29	INODORO FERRUM - ADRIAICA	Pza.	2390.22	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.633614
1584	29	TINA BLANCA CON GRIFERIA	Pza	2245.00	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.649412
1585	29	BIDETT BLANCO CON GRIFERIA	Pza	622.25	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.664793
1586	29	LAVAMANOS BLANCO CON GRIFERIA	Pza	647.81	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.75832
1587	29	LAVAPLATOS C/2 DEPOS Y 1 FREGAD.	Pza	902.84	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.773746
1588	29	LAVAPLATOS C/1 DEPOS Y 1 FREGAD.	Pza	584.53	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:35.788964
1589	46	SIKAFLEX 1 -A (720 gr.)	Pza	282.11	Importado de archivo SQL - Categoría 46	2025-05-31 20:38:35.804567
1590	32	LOSETA ONDUL. 10 cm. (32 pza/m2)	Pza	3.38	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:35.82091
1591	32	LOSETA HEXAGONAL 10 cm. (34pza/m2	Pza	2.91	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:35.835298
1592	7	ALAMBRE TEJIDO	M2.	5.77	Importado de archivo SQL - Categoría 7	2025-05-31 20:38:35.850702
1593	7	ALAMBRE CON PUAS GALV. TRIPLE	Rollo	291.45	Importado de archivo SQL - Categoría 7	2025-05-31 20:38:35.865916
1594	10	CERAMICA ESMALTADA BRAS. 30x30	M2.	135.31	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:35.880979
1595	12	CALEFON ELECTRICO RHEN 50 Gl.	Pza.	4121.50	Importado de archivo SQL - Categoría 12	2025-05-31 20:38:35.896052
1596	12	CALEFON ELECTRICO RHEN 65 Gl.	Pza.	6339.49	Importado de archivo SQL - Categoría 12	2025-05-31 20:38:35.913211
1597	14	CAMARA SEPTICA DE 250	Lt.	609.39	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:35.929331
1598	14	CAMARA SEPTICA DE 1000 Lt.	Pza.	2136.65	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:35.945752
1599	14	CAMARA SEPTICA 2000 Lt.	Pza	4320.17	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:35.961358
1600	14	CAMARA SEPTICA DE 5000 Lt.	Pza.	10688.71	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:35.97759
1601	14	CAMARA SEPTICA DE 10000 Lt.	Pza.	16814.94	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:35.993097
1602	17	LOSETA TEXPOR 1.21x5x60.5x2.50	Pza.	56.83	Importado de archivo SQL - Categoría 17	2025-05-31 20:38:36.008357
1603	17	LOSETA REVIPOR 1.21x5x60.5x2.5	Pza.	47.35	Importado de archivo SQL - Categoría 17	2025-05-31 20:38:36.023413
1604	18	CLAVOS DE 1\\'\\' Y 11/2\\'\\' (25mm. Y 37mm.)	Kg.	12.21	Importado de archivo SQL - Categoría 18	2025-05-31 20:38:36.03853
1605	19	CALAMINA ONDULADA No 33	M2.	34.03	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.053563
1606	19	CALAMINA ONDULADA No 33 1.80x0.70	Unid.	39.68	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.069062
1607	19	CALAMINA ONDULADA No 32	M2.	30.17	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.083999
1608	19	CALAMINA ONDULADA No 33 1.80x0.80	Unid.	48.80	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.099551
1609	19	CALAMINA ONDULADA No 33 2.15x0.80	Unid.	57.45	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.114783
1610	19	CALAMINA ONDULADA No 33 2.45x0.80	Unid.	65.79	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.129762
1611	19	CALAMINA ONDULADA No 33 3x0.80	Unid.	82.32	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.1452
1612	19	CALAMINA ONDULADA No 32 1.80x0.90	Unid.	49.08	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.161048
1613	19	CALAMINA ONDULADA No 32 0.90x2.15	Unid.	57.94	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.176116
1614	19	CALAMINA ONDULADA No 32 2.45x0.90	Unid.	65.68	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.191201
1615	19	CALAMINA ONDULADA No 28	M2.	48.80	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.206406
1616	19	CALAMINA ONDULADA No 28 1.80x0.80	Unid.	70.12	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.221621
1617	19	CALAMINA ONDULADA No 28 2.15x0.80	Unid.	82.97	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.236835
1618	19	CALAMINA ONDULADA No 28 2.45x0.80	Unid.	94.07	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.251996
1619	19	CALAMINA ONDULADA No 28 3x0.80	Unid.	116.21	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.26704
1620	19	CALAMINA PLANA No 30	M2.	43.32	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.282081
1621	19	CALAMINA PLANA No 30 2x1	Unid.	86.68	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.297032
1622	19	CALAMINA PLANA No 28	M2.	48.93	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.31252
1623	19	CALAMINA PLANA No 28 2x1	Unid.	97.88	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.328117
1624	19	CALAMINA PLANA No 26	M2.	49.82	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.343316
1625	22	TORNILLO P/MADERA 5/8\\'\\'x 6\\'\\'	Doc.	2.71	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:36.358497
1626	22	TORNILLO P/MADERA 5/8\\'\\'x 5\\'\\'	Doc.	2.40	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:36.373536
1627	22	TORNILLO P/MADERA 5/8\\'\\'x4\\'\\'	Doc.	2.08	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:36.389082
1628	1	CAMARA D=60 cm PROFUNDIDAD	Pza	439.07	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:36.404598
1629	22	TIRAFONDOS DE 3  x 1/4	Pza	3.20	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:36.419905
1630	1	CAMARA D= 60 cm, 80 cm PROFUNDIDAD	Pza	526.90	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:36.43511
1631	1	CAMARA D= 60 cm, 100 cm PROFUNDIDAD	Pza	585.47	Importado de archivo SQL - Categoría 1	2025-05-31 20:38:36.450176
1632	22	TORNILLO DE FIJACION	Pza	11.53	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:36.4656
1633	25	FLEXOMETRO 3 m	Pza	10.74	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:36.480851
1634	25	FLEXOMETRO 5 m	Pza	15.71	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:36.496145
1635	25	CORTADORA DE CERAMICA	Pza	531.71	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:36.511318
1636	29	BAÑO FERRUM - DORICA 3Pza  C/ACC	Jgo	3363.14	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:36.526509
1637	29	BAÑO DECA - MONTECARLO 3PZA C/ACC	Jgo	3033.51	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:36.541611
1638	29	INODORO FERRUM - FLOREN T/BAJO	Pza	1336.08	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:36.557824
1639	7	ALAMBRE TEJIDO	M2	5.77	Importado de archivo SQL - Categoría 7	2025-05-31 20:38:36.573003
1640	9	ALFOMBRA TAPISOL DISMAT	M2	98.57	Importado de archivo SQL - Categoría 9	2025-05-31 20:38:36.588193
1641	10	CERAMICA ESMALTADA BRAS. 30X30	M2	135.31	Importado de archivo SQL - Categoría 10	2025-05-31 20:38:36.60227
1642	12	CALEFON ELECTRICO RHEN 50 GI	Pza	3.20	Importado de archivo SQL - Categoría 12	2025-05-31 20:38:36.619975
1643	12	CALEFON ELECTRICO RHEN 65 GI	Pza	4.83	Importado de archivo SQL - Categoría 12	2025-05-31 20:38:36.642779
1644	14	CAMARA SEPTICA DE 250 Lt	Pza	609.39	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:36.666261
1645	14	CAMARA SEPTICA DE 1000 Lt	Pza	2136.65	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:36.682547
1646	14	CAMARA SEPTICA DE 2000Lt	Pza	4320.17	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:36.697693
1647	14	CAMARA SEPTICA DE 5000 Lt	Pza	10688.71	Importado de archivo SQL - Categoría 14	2025-05-31 20:38:36.725251
1648	16	CEMENTO PORTLAND VIACHA	Kg	1.00	Importado de archivo SQL - Categoría 16	2025-05-31 20:38:36.740619
1649	17	LOSETAS TEXPOR 1.21x5x60.5x2.5	Pza	56.83	Importado de archivo SQL - Categoría 17	2025-05-31 20:38:36.755834
1651	18	CLAVOS DE 1\\" Y 1 1/2\\" (25mm. y 37 mm.)	Kg	12.21	Importado de archivo SQL - Categoría 18	2025-05-31 20:38:36.786465
1652	19	CALAMINA ONDULADA No 33	M2	34.03	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.801449
1653	19	CALAMINA ONDULADA No 33  1.80x0.70	Unid.	39.68	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.816988
1654	19	CALAMINA ONDULADA No 33  1.80x0.80	Unid.	48.80	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.832085
1655	19	CALAMINA ONDULADA No 33  2.15x0.80	Unid.	57.45	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.847129
1656	19	CALAMINA ONDULADA No 33  2.45x0.80	Unid.	65.79	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.862333
1657	19	CALAMINA ONDULADA No 32	M2	30.17	Importado de archivo SQL - Categoría 19	2025-05-31 20:38:36.877431
1658	22	TIRAFONDOS  DE 3x 1/4	Pza	3.20	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:36.892694
1659	22	TORNILLO P/MADERA 5/8\\"x4\\"	Doc.	2.08	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:36.907962
1660	22	TORNILLO P/MADERA 5/8\\"x5\\"	Doc.	2.40	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:36.923259
1661	22	TORNILLO P/MADERA 5/8\\"x6\\"	Doc.	2.71	Importado de archivo SQL - Categoría 22	2025-05-31 20:38:36.938418
1662	23	GAVION MACCAFERRI 1.5x1x1/SD	Pza	305.90	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:36.954111
1663	23	GAVION MACCAFERRI 2x1x0.5/CD	Pza	286.79	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:36.969274
1664	23	GAVION MACCAFERRI 2x1x1/SD	Pza	382.31	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:36.984995
1665	23	GAVION MACCAFERRI 2x1x1/CD	Pza	420.51	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.000884
1666	23	GAVION MACCAFERRI 3x1x1/CD	Pza	611.50	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.016011
1667	23	GAVION MACCAFERRI 4x1x1/CD	Pza	802.80	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.031813
1668	23	GAVION MACCAFERRI 5x1x1/CD	Pza	993.94	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.046866
1669	23	GAVION MACCAFERRI 5x2x1/CD	Pza	1604.94	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.061904
1670	23	GAVION MACCAFERRI 4x1x 0.5/CD	Pza	554.35	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.077419
1671	23	GAVION MACCAFERRI 5x1x0.5/CD	Pza	688.21	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.092813
1672	23	COLCHONETA RENO MA. 4x2x0.17	Pza	757.50	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.107979
1673	23	COLCHONETA RENO MA. 5x2x0.17	Pza	971.00	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.123053
1674	23	COLCHONETA RENO MA. 6x2x0.17	Pza	1144.68	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.137247
1675	23	GAVION CORINSA 1.5x1x0.5	Pza	219.22	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.152908
1676	23	GAVION CORINSA 1.5x1x1	Pza	308.29	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.168318
1677	23	GAVION CORINSA 2x1x0.5	Pza	282.93	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.184414
1678	23	GAVION CORINSA 2x1x1/SD	Pza	369.63	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.199562
1679	23	GAVION CORINSA 3x1x0.5	Pza	410.37	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.218272
1680	23	GAVION CORINSA 3x1x1	Pza	570.89	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.233528
1681	23	GAVION CORINSA 4x1x0.5	Pza	536.52	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.249017
1682	23	COLCHONETA CORINSA. 3x2x0.30	Pza	462.55	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.264312
1683	23	COLCHONETA CORINSA. 3x2x0.23	Pza	437.03	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.279854
1684	23	COLCHONETA CORINSA. 4x2x0.30	Pza	602.83	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.295086
1685	23	COLCHONETA CORINSA. 4x2x0.17	Pza	540.37	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.309255
1686	23	COLCHONETA CORINSA. 5x2x0.30	Pza	746.77	Importado de archivo SQL - Categoría 23	2025-05-31 20:38:37.324312
1687	25	CARRETILLA SIN NEUMATICO	Pza	316.65	Importado de archivo SQL - Categoría 25	2025-05-31 20:38:37.339435
1688	26	IGOL INCOLORO	15 Kg	1061.17	Importado de archivo SQL - Categoría 26	2025-05-31 20:38:37.354834
1689	27	UNITOP 620 REVEST. P/FACHADAS (21Kg)	Pza	678.92	Importado de archivo SQL - Categoría 27	2025-05-31 20:38:37.370419
1690	29	BAÑO FERRUM -DORICA. 3PZA. C/ACC.	Jgo.	3363.14	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:37.385813
1691	29	BAÑERA 1.50x0.70 CON GRIFERIA	Pza	1705.08	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:37.400951
1692	29	BAÑ. HIDROM. 1.70x0.80 C/MOT.	Pza	1833.00	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:37.415954
1693	29	BAÑ. HIDROM. CIRC. D=1.5 m. C/MOT.	Pza	5555.83	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:37.431192
1694	29	BAÑ. HIDROM. CIRC. D=1.8 m. C/MOT.	Pza	7395.22	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:37.445354
1695	29	BAÑ. HIDROM. ESQUI. R=1.5m. C/MOT.	Pza	7893.57	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:37.461255
1696	29	INODORO BLANCO T/ALTO C/ACC.	Pza	625.91	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:37.477357
1697	29	INODORO FERRUM-FLOREN. T/BAJO	Pza	1336.08	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:37.492433
1698	29	INODORO FERRUM-DORICA	Pza	2080.97	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:37.507609
1699	29	INODORO FERRUM-ADRIATICA	Pza	2390.22	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:37.524029
1700	29	LAVAPLATOS C/2 DEPOS. Y 2 FREGAD.	Pza	1251.86	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:37.539411
1701	29	LAVAPLATOS C/2 DEPOS. Y 1 FREGAD.	Pza	872.11	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:37.556056
1702	29	LAVAPLATOS C/1 DEPOS. Y 1 FREGAD.	Pza	563.65	Importado de archivo SQL - Categoría 29	2025-05-31 20:38:37.571188
1703	31	LADRILLO 6H 24x18x12 cm.	Pza	1.29	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.58597
1704	31	LADRILLO 6H 12x18x12 cm.	Pza	0.97	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.601177
1705	31	LADRILLO 6H  24x15x11.5cm	Pza	1.11	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.615264
1706	31	LADRILLOS 6H 12x18x12cm	Pza	0.79	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.630341
1707	31	LADRILLO 6H 24x15x9.5cm	Pza	0.97	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.645389
1708	31	LADRILLO 6H 22.5x15x9.5cm	Pza	0.97	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.660392
1709	31	LADRILLO 3H 24x15x8cm	Pza	0.82	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.676952
1710	31	LADRILLO 2H 24x12x6.5cm	Pza	0.70	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.69207
1711	31	LADRILLO GAMBOTE 18H 25x12x6.5cm	Pza	1.11	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.707235
1712	31	LADRILLO CELOSIA 12x16x16cm	Pza	0.97	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.723896
1713	31	CERAMICA P/LOSA ALiVIANADA 13cm	Pza	2.79	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.740695
1714	31	CERAMICA P/LOSA ALIVIANADA 10cm.	Pza	2.60	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.756137
1715	32	LOSETA ONDUL 10cm. (32pza/m2)	Pza	3.36	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:37.771452
1716	32	LOSETA DOBLET 10cm.	Pza	3.36	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:37.786473
1717	32	LOSETA DOBLET 8cm.	Pza	3.07	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:37.801477
1718	32	LOSETA HEXAG. 10cm. (34pza/m2)	Pza	2.71	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:37.818756
1719	32	LOSETA  HEX. CONCRETEC. (12pzas/m2)	Pza	7.88	Importado de archivo SQL - Categoría 32	2025-05-31 20:38:37.834276
1720	33	PARQUET MARA CON DISEÑO	M2	47.35	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:37.849342
1721	33	ZOCALO CEDRO 3\\" (75mm.)	MI.	7.23	Importado de archivo SQL - Categoría 33	2025-05-31 20:38:37.864688
1722	31	ZOCALO TAJIBO 3\\" (75mm.)	MI.	10.92	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.880352
1723	31	ZOCALO TAJIBO 4\\" (100mm.)	MI.	13.06	Importado de archivo SQL - Categoría 31	2025-05-31 20:38:37.895669
1724	34	VENESTA SEREBO 244x122x4 mm.	Pza	71.10	Importado de archivo SQL - Categoría 34	2025-05-31 20:38:37.910797
1725	40	BARNIZ CRISTAL BRILL. MONOPOL	GL.	117.03	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:37.92784
1726	40	MARSILLA P/MADERA MONOPOL	GL.	87.85	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:37.943024
1727	40	SELLADOR P/MADERA MONOPOL	GL.	110.95	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:37.959136
1728	40	PEGAPARTKET (PEG. P/PARKET)	GL.	190.23	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:37.973181
1729	40	ANTITERMITAS	GL.	93.29	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:37.987218
1730	40	ANTITERMITAS	18Lt.	330.49	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:38.002206
1731	40	THINNER UNIVERSAL	GL.	69.00	Importado de archivo SQL - Categoría 40	2025-05-31 20:38:38.017471
1732	46	SIKAFLEX 1-A (720gr.)	Pza	272.50	Importado de archivo SQL - Categoría 46	2025-05-31 20:38:38.033502
1733	46	SIKAFLEX 11-FC  (370gr)	Pza	208.15	Importado de archivo SQL - Categoría 46	2025-05-31 20:38:38.048855
1734	47	SOGA DE 3/4\\"  (20mm.)	MI.	14.61	Importado de archivo SQL - Categoría 47	2025-05-31 20:38:38.064265
1735	47	SOGA DE PLASTICO 3/16\\"  (5mm)	MI.	2.57	Importado de archivo SQL - Categoría 47	2025-05-31 20:38:38.079899
1736	48	TANQUE BICAPA NEGRO 400Lts.	Pza	953.32	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:38.095184
1737	48	TANQUE BICAPA NEGRO 600 Lts.	Pza	1245.69	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:38.11157
1738	48	TANQUE BICAPA NEGRO 1100 Lts.	Pza	1957.37	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:38.127619
1739	48	TANQUE BICAPA NEGRO 2500 Lts.	Pza	4385.32	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:38.144919
1740	48	TANQUE BICAPA COLOR 400 Lts.	Pza	1042.31	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:38.159254
1741	48	TANQUE BICAPA COLOR 600 Lts.	Pza	1347.37	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:38.17468
1742	48	TANQUE BICAPA COLOR 1100 Lts.	Pza	2122.71	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:38.190121
1743	48	TANQUE BICAPA COLOR 2500 Lts.	Pza	4766.68	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:38.205694
1744	48	TANQUE TRICAPA COLOR 400 Lts.	Pza	1372.80	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:38.221808
1745	48	TANQUE TRICAPA COLOR 600 Lts.	Pza	1677.79	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:38.237258
1746	48	TANQUE TRICAPA COLOR 1100 Lts.	Pza	2631.12	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:38.252557
1747	48	TANQUE  TRICAPA  COLOR 2500 Lts.	Pza	6215.61	Importado de archivo SQL - Categoría 48	2025-05-31 20:38:38.268527
1748	49	TEJA DUNTEX COLONIAL	Pza	2.57	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.283769
1749	49	CUMBRERA COLONIAL	Pza	7.97	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.299439
1750	49	TEJA DUNTEX FRANCESA	Pza	2.79	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.314521
1751	49	CUMBRERA FRANCESA	Pza	7.97	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.330355
1752	49	TEJA ALEMANA 44cm. TECERBOL	Pza	2.33	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.345657
1753	49	TEJA COLONIAL 50cm. TECERBOL	Pza	2.33	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.361926
1754	49	TEJA ESPAÑOLA 40cm. TECERBOL	Pza	3.07	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.377158
1755	49	TEJA ESPAÑOLA 50cm. TECERBOL	Pza	3.20	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.393023
1756	49	TEJA CHICAGO 43cm. TECERBOL	Pza	3.36	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.408489
1757	49	TEJA FRANCESA 43cm. TECERBOL	Pza	3.36	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.427071
1758	49	CUMBRERA 40cm. TECERBOL	Pza	7.00	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.442708
1759	49	TEJA ROMANA 40cm. INCERPAZ	Pza	2.42	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.457837
1760	49	TEJA ESPAÑOLA 40cm. INCERPAZ	Pza	2.42	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.473202
1761	49	TEJA COLONIAL 40cm. INCERPAZ	Pza	1.61	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.490623
1762	49	TEJA ROMANA  O ESPAÑOLA	M2	46.23	Importado de archivo SQL - Categoría 49	2025-05-31 20:38:38.506992
1763	52	TUBO DE Ho. 4\\" P/DESAGUE (100mm.)	MI.	17.51	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.521368
1764	52	TUBO DE Ho. 6\\" P/DESAGUE (150 mm.)	MI.	35.64	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.53704
1765	52	TUBO DE Ho. 8\\" P/DESAGUE (200mm.)	MI.	47.17	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.552573
1766	52	TUBO DE Ho. 10\\"  P/DESAGUE (250mm.)	MI.	76.39	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.569774
1767	52	TUBO DE Ho. 12\\" P/DESAGUE (300mm.)	MI.	135.31	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.585293
1768	52	TUBO DE Ho. 16\\" P/DESAGUE (400 mm.)	MI.	178.48	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.600748
1769	52	TUBO DE Ho. 18\\" P/DESAGUE  (460 mm.)	MI.	200.12	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.615998
1770	52	TUBO DE Ho. 22\\" P/DESAGUE (560mm.)	MI.	252.31	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.631729
1771	52	TUBO DE Ho. 24\\" P/DESAGUE (610mm.)	MI.	321.00	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.648248
1772	52	TUBO DE Ho. 28\\"  P/DESAGUE  (700mm.)	MI.	346.68	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.663446
1773	52	TUBO DE Ho. 32\\" P /DESAGUE  (800mm.)	MI.	407.83	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.681144
1774	52	TUBO DE Ho. 40\\" P/DESAGUE	MI.	573.47	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.7006
1775	52	TUBO DE Ho. 48\\" P/DESAGUE	MI.	675.32	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.720542
1776	52	TUBO DE Ho. 4\\" P/DRENAJE	MI.	21.35	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.736905
1777	52	TUBO DE Ho. 6\\" P/DRENAJE	MI.	76.39	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.752232
1778	52	TUBO DE Ho. 8\\" P/DRENAJE	MI.	55.50	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.767491
1779	52	TUBO DE Ho. 10\\" P/DRENAJE	MI.	82.83	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.786285
1780	52	TUBO DE Ho. 12\\" P/DRENAJE	MI.	143.97	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.804695
1781	52	TUBO DE Ho. 16\\" P/DRENAJE	MI.	172.07	Importado de archivo SQL - Categoría 52	2025-05-31 20:38:38.820261
1782	53	TUBO CAMPANA E-40  L=6m. 1/2\\"	Tubo	53.91	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:38.835666
1783	53	TUBO DESAGUE PVC L= 6m 2 1/2\\"	Tubo	77.68	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:38.855807
1784	53	TUBO CAMPANA E-40 L= 6m. 2\\"	Tubo	234.15	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:38.871179
1785	53	TUBO CAMPANA E-40 L= 6m. 3\\"	Tubo	460.77	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:38.886453
1786	53	TUBO CAMPANA E-40  L= 6m. 4\\"	Tubo	647.92	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:38.902733
1787	53	TUBO CAMPANA E-40 L= 6m. 6\\"	Tubo	1188.12	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:38.917928
1788	53	TUBO CAMPANA E-40 L= 6m. 8\\"	Tubo	1953.07	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:38.933097
1789	53	TUBO CAMPANA E-40 L= 6m. 10\\"	Tubo	2973.80	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:38.948677
1790	53	TUBO CLASE 6  L=6m. 3\\" (75mm.)	Tubo	84.56	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:38.964193
1791	53	TUBO CLASE 9 L= 6m. 2\\" (50mm.)	Tubo	158.40	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:38.979734
1792	53	TUBO CLASE 9 L= 6m. 2 1/2\\" (60mm.)	Tubo	246.50	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:38.996816
1794	53	TUBO CLASE 9 L= 6m. 4\\" (100mm.)	Tubo	542.14	Importado de archivo SQL - Categoría 53	2025-05-31 20:38:39.028084
1793	53	TUBO CLASE 9 L= 6m. 3\\" (75mm.)	Tubo	456.04	Importado de archivo SQL - Categoría 53	2025-06-02 00:04:09.002
1650	41	LOSETAS REVIPOR 1.21x5x60.5x2.5	Pza	47.35	Importado de archivo SQL - Categoría 17	2025-06-02 00:07:56.719
\.


--
-- Data for Name: price_settings; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.price_settings (id, usd_exchange_rate, inflation_factor, global_adjustment_factor, last_updated, updated_by) FROM stdin;
1	6.9600	1.0000	1.0000	2025-05-31 20:43:19.754041	Sistema
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.projects (id, name, client, location, start_date, created_at, updated_at, user_id, status, city, country, equipment_percentage, administrative_percentage, utility_percentage, tax_percentage, social_charges_percentage) FROM stdin;
1	Casa Residencial Los Pinos	Juan Carlos Mendez	Zona Sur, La Paz	2024-01-15 00:00:00	2025-05-31 16:39:34.115861	2025-05-31 16:39:34.115861	\N	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
2	Edificio Comercial Plaza Central	Constructora ABC S.R.L.	Centro, Santa Cruz	2024-02-01 00:00:00	2025-05-31 16:39:34.115861	2025-05-31 16:39:34.115861	\N	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
3	Casa de Campo El Palmar	Maria Rodriguez	Cochabamba	2024-03-10 00:00:00	2025-05-31 16:39:34.115861	2025-05-31 16:39:34.115861	\N	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
4	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:29:28.192719	2025-05-31 21:29:28.192719	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
5	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:33:05.938417	2025-05-31 21:33:05.938417	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
6	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:34:40.041719	2025-05-31 21:34:40.041719	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
7	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:36:36.937948	2025-05-31 21:36:36.937948	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
8	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:39:04.200115	2025-05-31 21:39:04.200115	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
9	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:42:10.180463	2025-05-31 21:42:10.180463	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
10	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:44:54.755562	2025-05-31 21:44:54.755562	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
11	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:45:50.746764	2025-05-31 21:45:50.746764	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
12	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:48:29.618399	2025-05-31 21:48:29.618399	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
13	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:49:46.737182	2025-05-31 21:49:46.737182	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
14	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:52:06.738216	2025-05-31 21:52:06.738216	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
15	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:52:53.329543	2025-05-31 21:52:53.329543	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
16	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:54:47.110519	2025-05-31 21:54:47.110519	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
17	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 21:56:44.266834	2025-05-31 21:56:44.266834	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
18	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 22:00:47.658553	2025-05-31 22:00:47.658553	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
19	Ampliacion Sra tunchis	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 22:07:57.295396	2025-05-31 22:07:57.295396	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
23	a sculpture of a woman's face	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-05-31 23:46:15.817282	2025-05-31 23:46:15.817282	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
26	Ampliacion Sra tunchis2	Sra tunchis	lostiluchis 4564	2025-05-31 00:00:00	2025-06-01 00:34:39.249503	2025-06-01 00:34:39.249503	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
29	1233	dfdf	fefe	2025-05-31 00:00:00	2025-06-01 00:50:33.809471	2025-06-01 00:50:33.809471	2	planning	\N	Bolivia	5.00	8.00	15.00	3.09	71.18
33	Ampliacion Sra tunchis	dfdf	lostiluchis 4564	2025-05-31 00:00:00	2025-06-01 01:23:42.787447	2025-06-01 01:23:42.787447	2	planning	La Paz	Bolivia	5.00	8.00	15.00	3.09	71.18
37	casa de 2	juan perez	irpavoi	2025-06-01 00:00:00	2025-06-01 11:10:50.193202	2025-06-01 11:10:50.193202	2	planning	Santa Cruz	Bolivia	5.00	8.00	15.00	3.09	71.18
38	casa3	juan	irpaivis	2025-06-01 00:00:00	2025-06-01 12:11:19.44724	2025-06-01 12:11:19.44724	3	planning	Santa Cruz	Bolivia	5.00	8.00	15.00	3.09	71.18
39	casa de 2	434	4545	2025-06-01 00:00:00	2025-06-01 13:47:10.76457	2025-06-01 13:47:10.76457	3	planning	Santa Cruz	Bolivia	5.00	8.00	15.00	3.09	71.18
40	CASA 001	Kasis	Arena 1	2025-06-01 00:00:00	2025-06-01 16:17:25.893527	2025-06-01 16:17:25.893527	163	planning	Santa Cruz	Bolivia	5.00	8.00	15.00	3.09	71.18
41	casa 3	juan	la calle	2025-06-02 00:00:00	2025-06-03 02:24:12.704484	2025-06-03 02:24:12.704484	3	planning	Santa Cruz	Bolivia	5.00	8.00	15.00	3.09	71.18
42	1	323	3232	2025-06-02 00:00:00	2025-06-03 02:26:57.553952	2025-06-03 02:26:57.553952	3	planning	Cochabamba	Bolivia	5.00	8.00	15.00	3.09	71.18
43	tres	e	122	2025-06-02 00:00:00	2025-06-03 02:35:04.524976	2025-06-03 02:35:04.524976	3	planning	Cochabamba	Bolivia	5.00	8.00	15.00	3.09	71.18
\.


--
-- Data for Name: supplier_companies; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.supplier_companies (id, user_id, company_name, business_type, description, address, city, country, phone, whatsapp, website, facebook, logo_url, image_urls, membership_type, membership_expires_at, is_active, is_verified, rating, review_count, created_at, updated_at, speciality) FROM stdin;
1	4	MOWREY ELEVATOR	wholesaler	Empresa especializada en eléctrica con años de experiencia en el mercado boliviano.	Calle Quijarro Nº 81	Santa Cruz	Bolivia	337-2064	337-2064			\N	\N	free	\N	t	t	4.20	34	2025-06-01 09:14:57.645157	2025-06-01 13:00:55.261	herramientas
4	7	AMC	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Cochabamba Nº661 337-1727 336-7393	Santa Cruz	Bolivia					\N	\N	free	\N	t	t	4.20	44	2025-06-01 09:14:58.124634	2025-06-01 13:00:55.296	general
5	8	ASSINCO	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	C/Horacio Rios Nº24	Santa Cruz	Bolivia	337-0203	337-0203			\N	\N	free	\N	t	t	4.20	39	2025-06-01 09:14:58.287636	2025-06-01 13:00:55.314	general
9	12	FENG SHUI	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Maestra Feng shui: Alexandra Staht 9	Santa Cruz	Bolivia	760-2272	760-2272			\N	\N	free	\N	t	t	4.20	37	2025-06-01 09:14:58.930717	2025-06-01 13:00:55.332	general
10	13	Import. LA POPULAR	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av. Cañoto Nº707 Esq.Isabel La Católica	Santa Cruz	Bolivia	333-7460	333-7460			\N	\N	free	\N	t	t	4.20	52	2025-06-01 09:14:59.092897	2025-06-01 13:00:55.353	general
13	16	INDUSTRIAS SER	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Parque Industrial P.I.6	Santa Cruz	Bolivia	346-8744	346-8744			\N	\N	free	\N	t	t	4.20	50	2025-06-01 09:14:59.554713	2025-06-01 13:00:55.372	general
14	17	Ferreteria ALEXIS	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Entre 4º Anillo y 3 pasos al Frente	Santa Cruz	Bolivia	349-8717	349-8717			\N	\N	free	\N	t	t	4.20	35	2025-06-01 09:14:59.711618	2025-06-01 13:00:55.396	general
15	18	FERROBOLIVIA	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	3º Anillo Interno/ Av. Piraí	Santa Cruz	Bolivia	354-0414	354-0414			\N	\N	free	\N	t	t	4.20	21	2025-06-01 09:14:59.868672	2025-06-01 13:00:55.419	acero
16	19	SOBOCE	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Km. 23 Carretera al Norte tel.(2)240-6040	Santa Cruz	Bolivia					\N	\N	free	\N	t	t	4.20	35	2025-06-01 09:15:00.021766	2025-06-01 13:00:55.437	general
17	20	WEIDLING S.A.	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	3º Anillo Interno Avenida Santos Dumont	Santa Cruz	Bolivia	355-6424	355-6424			\N	\N	free	\N	t	t	4.20	30	2025-06-01 09:15:00.185696	2025-06-01 13:00:55.458	general
18	21	COMEL S.R.L.	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Carretera al Norte Km. 28	Santa Cruz	Bolivia	923-2519	923-2519			\N	\N	free	\N	t	t	4.20	30	2025-06-01 09:15:00.340174	2025-06-01 13:00:55.479	general
19	22	EMCONCIMET	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av. Buch C/ Las Vegas Nº179	Santa Cruz	Bolivia	330-0374	330-0374			\N	\N	free	\N	t	t	4.20	50	2025-06-01 09:15:00.49785	2025-06-01 13:00:55.501	general
20	23	FLECHA DE ORO	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av.Virgen de Cotoca Nº 2610	Santa Cruz	Bolivia	346-2661	346-2661			\N	\N	free	\N	t	t	4.20	47	2025-06-01 09:15:00.64971	2025-06-01 13:00:55.519	general
22	25	METANIQA Ltda.	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av. El Trompillo Nº660	Santa Cruz	Bolivia	358-4203	358-4203			\N	\N	free	\N	t	t	4.20	49	2025-06-01 09:15:00.958483	2025-06-01 13:00:55.544	general
23	26	METCO Ltda.	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av. Don Bosco 159 Casilla:366	Santa Cruz	Bolivia	334-5624	334-5624			\N	\N	free	\N	t	t	4.20	35	2025-06-01 09:15:01.110561	2025-06-01 13:00:55.565	general
25	28	ERGOVIAL Ltda. (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.		Santa Cruz	Bolivia	344-3349	344-3349			\N	\N	free	\N	t	t	4.20	52	2025-06-01 09:15:01.419656	2025-06-01 13:00:55.585	general
26	29	ESCOBOL U.P. (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Av.Grigotá esq.Omar Chavez Pasillo "B" Of.23	Santa Cruz	Bolivia	354-3041	354-3041			\N	\N	free	\N	t	t	4.20	44	2025-06-01 09:15:01.570046	2025-06-01 13:00:55.603	general
27	30	FERRACÓN Ltda. (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	b.Hamacas, calle 1 Oeste Nº 3215	Santa Cruz	Bolivia	341-6408	341-6408			\N	\N	free	\N	t	t	4.20	18	2025-06-01 09:15:01.759013	2025-06-01 13:00:55.621	general
29	32	GRANCO (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Avenida Beni Nº 277 Oficina 112	Santa Cruz	Bolivia	342-3700	342-3700			\N	\N	free	\N	t	t	4.20	20	2025-06-01 09:15:02.092213	2025-06-01 13:00:55.641	general
30	33	HAGA (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.		Santa Cruz	Bolivia	348-8178	348-8178			\N	\N	free	\N	t	t	4.20	9	2025-06-01 09:15:02.24459	2025-06-01 13:00:55.657	general
31	34	HOLLWEG (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Lagunilla Nº 443	Santa Cruz	Bolivia	351-5857	351-5857			\N	\N	free	\N	t	t	4.20	31	2025-06-01 09:15:02.393006	2025-06-01 13:00:55.676	general
32	35	HOSSEN (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Av. 26 De Febrero Nº 636	Santa Cruz	Bolivia	357-8080	357-8080			\N	\N	free	\N	t	t	4.20	28	2025-06-01 09:15:02.550904	2025-06-01 13:00:55.694	general
33	36	MINERVA Ltda. (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	5º anillo Nº 300 entre Av. Grigotá y Radial 17 1/2	Santa Cruz	Bolivia	353-3929	353-3929			\N	\N	free	\N	t	t	4.20	5	2025-06-01 09:15:02.713056	2025-06-01 13:00:55.712	general
34	37	NOGAL Constr.S.R.L. (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Av.San Martin-Equipetrol Norte	Santa Cruz	Bolivia	341-2677	341-2677	www.nogalconstrucciones.com		\N	\N	free	\N	t	t	4.20	28	2025-06-01 09:15:02.865045	2025-06-01 13:00:55.733	general
35	38	CRISNER	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Av. San Martín Nºo 15 75 \\r\\n\\r\\n	Santa Cruz	Bolivia	334-1665	334-1665			\N	\N	free	\N	t	t	4.20	21	2025-06-01 09:16:55.206561	2025-06-01 13:00:55.75	general
36	39	GEMA ORIENTAL	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Av.Ingavi Nº601\\r\\n\\r\\n	Santa Cruz	Bolivia	332-7492	332-7492			\N	\N	free	\N	t	t	4.20	32	2025-06-01 09:16:55.365777	2025-06-01 13:00:55.768	general
38	41	BOLIVIAN ELECTRIC	wholesaler	Empresa especializada en eléctrica con años de experiencia en el mercado boliviano.	Av.Santa Cruz Nº 382\\r\\n\\r\\n	Santa Cruz	Bolivia	348-7575	348-7575			\N	\N	free	\N	t	t	4.20	45	2025-06-01 09:16:55.690176	2025-06-01 13:00:55.786	electricos
39	42	EQUICOMST	wholesaler	Empresa especializada en eléctrica con años de experiencia en el mercado boliviano.	Av. Banzer Km. 2.5 c/ 4 Nº 100\\r\\n\\r\\n	Santa Cruz	Bolivia	342-0721	342-0721			\N	\N	free	\N	t	t	4.20	23	2025-06-01 09:16:55.844145	2025-06-01 13:00:55.805	electricos
40	43	FABOCELT	wholesaler	Empresa especializada en eléctrica con años de experiencia en el mercado boliviano.	Av. Tomás de Lezo Nº392\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	349-8549	349-8549			\N	\N	free	\N	t	t	4.20	36	2025-06-01 09:16:56.008904	2025-06-01 13:00:55.823	electricos
42	45	MERCANTIL LEON	wholesaler	Empresa especializada en eléctrica con años de experiencia en el mercado boliviano.	Av. Viedma Nº 51\\r\\n\\r\\n	Santa Cruz	Bolivia	332-6174	332-6174			\N	\N	free	\N	t	t	4.20	27	2025-06-01 09:16:56.323207	2025-06-01 13:00:55.843	general
44	47	INTERDECO	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	3º Anillo Interno Entre Alemana y Mutualista\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	343-6363	343-6363			\N	\N	free	\N	t	t	4.20	50	2025-06-01 09:16:56.634685	2025-06-01 13:00:55.863	general
45	48	Herramundo Industrial	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av.Paraguá Nº82 entre 2º y 3º anillo\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	347-7988	347-7988			\N	\N	free	\N	t	t	4.20	20	2025-06-01 09:16:56.788754	2025-06-01 13:00:55.881	herramientas
46	49	NUPRA	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Carretera a Cotoca 4º Anillo\\r\\n\\r\\n	Santa Cruz	Bolivia	349-3373	349-3373			\N	\N	free	\N	t	t	4.20	29	2025-06-01 09:16:56.952585	2025-06-01 13:00:55.902	general
49	52	ICAFAL ICIL Ltda.	retailer	Empresa especializada en electro mecánica con años de experiencia en el mercado boliviano.	Carretera a Cotoca Km. 7 1/2\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	347-7793	347-7793			\N	\N	free	\N	t	t	4.20	31	2025-06-01 09:16:57.453405	2025-06-01 13:00:55.923	general
50	53	INSACRUZ	retailer	Empresa especializada en electro mecánica con años de experiencia en el mercado boliviano.	Av.Ejercito Nacional Nº 49\\r\\n\\r\\n	Santa Cruz	Bolivia	333-3827	333-3827			\N	\N	free	\N	t	t	4.20	44	2025-06-01 09:16:57.61198	2025-06-01 13:00:55.941	general
52	55	PHILIPS S.A.	retailer	Empresa especializada en electro mecánica con años de experiencia en el mercado boliviano.	Calle Independencia Nº209\\r\\ntet.332-1486\\r\\n	Santa Cruz	Bolivia					\N	\N	free	\N	t	t	4.20	36	2025-06-01 09:16:57.925926	2025-06-01 13:00:55.957	general
55	58	Casa&Construcción	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Avenida Santa Cruz Nº 893\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	364-3015	364-3015			\N	\N	free	\N	t	t	4.20	47	2025-06-01 09:16:58.395844	2025-06-01 13:00:55.975	general
56	59	CEREBO	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	3ºAnillo Int.a 20 Mts.mano Izquier.Canal Cotoca\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	360-3773	360-3773			\N	\N	free	\N	t	t	4.20	12	2025-06-01 09:16:58.549088	2025-06-01 13:00:55.993	general
58	61	FINNING	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Carretera al Norte km. 3 1/2\\r\\n3\\r\\n\\r\\n	Santa Cruz	Bolivia	342-9688	342-9688			\N	\N	free	\N	t	t	4.20	46	2025-06-01 09:16:58.871176	2025-06-01 13:00:56.011	general
59	62	MAGENSA Ltda.	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	km5 1/2 carretera al Norte \\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	342-8000	342-8000			\N	\N	free	\N	t	t	4.20	33	2025-06-01 09:16:59.028529	2025-06-01 13:00:56.029	general
61	64	MUEBLES      BOLIVAR	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Avenida Paraguá Nº 3305\\r\\n\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	347-2750	347-2750			\N	\N	free	\N	t	t	4.20	18	2025-06-01 09:16:59.465798	2025-06-01 13:00:56.047	maderas
64	67	MUEBLES  E.H.M. s.r.l.	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	4º anillo entre Avenida Paraguá y Mutualista\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	346-6054	346-6054			\N	\N	free	\N	t	t	4.20	15	2025-06-01 09:16:59.933075	2025-06-01 13:00:56.067	maderas
65	68	MUEBLES   FENIX S.A.	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Av.Brasil entre 2º y 3º Anillo\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	346-2655	346-2655			\N	\N	free	\N	t	t	4.20	38	2025-06-01 09:21:05.364828	2025-06-01 13:00:56.085	maderas
66	69	MUEBLES   Formas&Tendencias	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Burapucú Nº47 Avenida Roca y Coronado\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	353-4110	353-4110			\N	\N	free	\N	t	t	4.20	22	2025-06-01 09:21:05.571702	2025-06-01 13:00:56.103	maderas
67	70	GRAMAR      (mosaico/marmol)	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Canal Cotoca esq.2º An./Av.Banzer C/Ohoó2030\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	346-7341	346-7341			\N	\N	free	\N	t	t	4.20	12	2025-06-01 09:21:05.747552	2025-06-01 13:00:56.121	ceramicos
69	72	MUEBLES   LA FAROLA	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Avenida René Moreno Nº331\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	336-2216	336-2216			\N	\N	free	\N	t	t	4.20	29	2025-06-01 09:21:39.262191	2025-06-01 13:00:56.139	maderas
71	74	MUEBLES   MOBILIER	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Avenida Argamosa Nº 108\\r\\n\\r\\n	Santa Cruz	Bolivia	332-6869	332-6869			\N	\N	free	\N	t	t	4.20	46	2025-06-01 09:21:39.611482	2025-06-01 13:00:56.159	maderas
72	75	MUEBLERIA INTI	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Calle Buenos Aires Nº141\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	334-7882	334-7882			\N	\N	free	\N	t	t	4.20	20	2025-06-01 09:21:39.797567	2025-06-01 13:00:56.177	maderas
73	76	Muebles FATIMA	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Calle 21 de Mayo Nº 163\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	333-3895	333-3895			\N	\N	free	\N	t	t	4.20	16	2025-06-01 09:21:39.97636	2025-06-01 13:00:56.195	maderas
74	77	MUEBLES HURTADO	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Calle 24 de septiembre esq. Buenos Aires\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	357-9651	357-9651			\N	\N	free	\N	t	t	4.20	23	2025-06-01 09:21:40.232497	2025-06-01 13:00:56.214	maderas
75	78	MUEBLES NAHI S.R.L.	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Avenida Argamosa esq. Charcas Nº 111\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	333-7308	333-7308			\N	\N	free	\N	t	t	4.20	41	2025-06-01 09:21:40.402124	2025-06-01 13:00:56.231	maderas
76	79	MUEBLES OPEN LINE	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	2º Anillo Nº 560 / Av. Virgen de Cotoca y Brasil\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	333-2434	333-2434			\N	\N	free	\N	t	t	4.20	5	2025-06-01 09:21:40.580393	2025-06-01 13:00:56.249	maderas
77	80	 MUEBLES  QUALITÉ S.R.L.	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Parque Industrial P.I.50 Manzana 05\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	346-7771	346-7771			\N	\N	free	\N	t	t	4.20	8	2025-06-01 09:21:40.764383	2025-06-01 13:00:56.269	maderas
78	81	MUELES  SION S.R.L.	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Av.Grigotá 4º Anillo 1/2 cuadra lado Norte \\r\\n	Santa Cruz	Bolivia	352-7773	352-7773			\N	\N	free	\N	t	t	4.20	52	2025-06-01 09:21:40.931682	2025-06-01 13:00:56.288	general
80	83	MUEBLES    TUMA HERMANOS	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Av.Monseñor Rivero Nº302\\r\\n\\r\\n	Santa Cruz	Bolivia	332-3930	332-3930			\N	\N	free	\N	t	t	4.20	46	2025-06-01 09:21:41.288007	2025-06-01 13:00:56.306	maderas
82	85	PINTURAS   BOINCOS S.A.	retailer	Empresa especializada en ambiental con años de experiencia en el mercado boliviano.	Av.Pedro Ribera M. Nº1000 /Alemana y Mutualista\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	342-0669	342-0669			\N	\N	free	\N	t	t	4.20	25	2025-06-01 09:21:41.637464	2025-06-01 13:00:56.324	pinturas
83	86	PINTURAS   CASA COLOR(Coral)	retailer	Empresa especializada en ambiental con años de experiencia en el mercado boliviano.	Av.26 de Febrero Nº2 2ºAnillo casi esq.Grigotá\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	354-1416	354-1416			\N	\N	free	\N	t	t	4.20	8	2025-06-01 09:21:41.809417	2025-06-01 13:00:56.342	pinturas
84	87	PINTURAS  PIARLI	retailer	Empresa especializada en ambiental con años de experiencia en el mercado boliviano.	Avenida Escuadrón Velasco Nº315 z/El Pari\\r\\n5\\r\\n3\\r\\n	Santa Cruz	Bolivia	770-0146	770-0146			\N	\N	free	\N	t	t	4.20	9	2025-06-01 09:21:41.985936	2025-06-01 13:00:56.362	pinturas
86	89	PINTURAS  SADIP	retailer	Empresa especializada en ambiental con años de experiencia en el mercado boliviano.	Barrio Hamacas Calle 5 Oeste Nº19\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	343-7646	343-7646			\N	\N	free	\N	t	t	4.20	29	2025-06-01 09:21:42.331868	2025-06-01 13:00:56.381	pinturas
87	90	PITURAS   Sherwin Williams	retailer	Empresa especializada en ambiental con años de experiencia en el mercado boliviano.	Avenida Roca y Coronado y 4º Anillo\\r\\n\\r\\n	Santa Cruz	Bolivia	351-5255	351-5255			\N	\N	free	\N	t	t	4.20	21	2025-06-01 09:21:42.505325	2025-06-01 13:00:56.397	general
89	92	R & M Importaciones   (Porcelanato,randas)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	2do. Anillo esquina Mutualista\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	347-0700	347-0700			\N	\N	free	\N	t	t	4.20	45	2025-06-01 09:21:42.862671	2025-06-01 13:00:56.415	general
92	95	INNOVA          (Publicidad/Gigant)	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Av.Roque Aguilera Nº 730\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	354-4465	354-4465			\N	\N	free	\N	t	t	4.20	31	2025-06-01 09:21:43.370073	2025-06-01 13:00:56.433	general
93	96	LOGOS          (Publicidad/Gigant)	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	2ºAn. Av.26 de Febrero Nº665/Pablo Roca e Inga\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	357-8249	357-8249			\N	\N	free	\N	t	t	4.20	44	2025-06-01 09:21:43.542047	2025-06-01 13:00:56.451	general
94	97	MAHS           (Publicidad/Gigant)	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	4ºAn. Nº597 ente Av.San Martin y Canal Isutu\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	344-7501	344-7501			\N	\N	free	\N	t	t	4.20	32	2025-06-01 09:21:43.711463	2025-06-01 13:00:56.469	general
96	99	NEON STAR       (Publicidad/Gigant)	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Av.Roca y Coronado Nº 379\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	354-1133	354-1133			\N	\N	free	\N	t	t	4.20	34	2025-06-01 09:21:44.114711	2025-06-01 13:00:56.487	general
97	100	STILO   (Publicidad/Gigant)	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Av.Roque Aguilera/ Av.El Palmar y R.Coronado\\r\\n\\r\\n	Santa Cruz	Bolivia	353-6000	353-6000			\N	\N	free	\N	t	t	4.20	9	2025-06-01 09:21:44.284931	2025-06-01 13:00:56.506	general
99	102	OF.TEC.de Servicios         (Refacciones)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Calle Fray del Pilar Nº118\\r\\n\\r\\n	Santa Cruz	Bolivia	336-9398	336-9398			\N	\N	free	\N	t	t	4.20	40	2025-06-01 09:21:44.682017	2025-06-01 13:00:56.525	general
100	103	PLASMAR          (Tuberias)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Parque Industrial \\r\\n\\r\\n	Santa Cruz	Bolivia	346-3039	346-3039			\N	\N	free	\N	t	t	4.20	20	2025-06-01 09:22:03.629215	2025-06-01 13:00:56.543	general
101	104	Talleres V & M      (Varidades)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av. La Salle entre 3º y 4º Anillo Nº180 B/Brígida\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	343-1623	343-1623			\N	\N	free	\N	t	t	4.20	47	2025-06-01 09:22:03.843003	2025-06-01 13:00:56.561	general
103	106	C M Cruceña        (Vidrios)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Calle 24 De Septiembre Nº248\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	333-8027	333-8027			\N	\N	free	\N	t	t	4.20	43	2025-06-01 09:22:04.214168	2025-06-01 13:00:56.58	vidrios
105	108	GEMA ORIENTAL               ( Vidrios)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Calle 21 de Mayo Nº285\\r\\n\\r\\n	Santa Cruz	Bolivia	332-7492	332-7492			\N	\N	free	\N	t	t	4.20	50	2025-06-01 09:22:04.639664	2025-06-01 13:00:56.598	vidrios
106	109	MIL METALES S.R.L.         (Vidrios)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av.Banzer 5º Anillo Km4 \\r\\n\\r\\n	Santa Cruz	Bolivia	342-5381	342-5381			\N	\N	free	\N	t	t	4.20	29	2025-06-01 09:22:04.835944	2025-06-01 13:00:56.616	acero
107	110	PersiAluVid.         (Vidrios)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Calle Vallegrande Nº 321\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	333-7504	333-7504			\N	\N	free	\N	t	t	4.20	21	2025-06-01 09:22:05.024302	2025-06-01 13:00:56.634	vidrios
109	112	San Silvestre       (Vidrios)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av.Prefecto Rivas Nº494 Alto San Pedro\\r\\n\\r\\n	Santa Cruz	Bolivia	353-6809	353-6809			\N	\N	free	\N	t	t	4.20	17	2025-06-01 09:22:05.394097	2025-06-01 13:00:56.654	vidrios
110	113	SANTA CRUZ               (Vidrios)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Florida Nº 597\\r\\n\\r\\n	Santa Cruz	Bolivia	334-6530	334-6530			\N	\N	free	\N	t	t	4.20	34	2025-06-01 09:22:05.578372	2025-06-01 13:00:56.673	vidrios
111	114	Vid.y Marquet.FITO         (Vidrios)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Aroma Nº 339\\r\\n\\r\\n	Santa Cruz	Bolivia	336-1256	336-1256			\N	\N	free	\N	t	t	4.20	12	2025-06-01 09:22:05.782782	2025-06-01 13:00:56.691	vidrios
112	115	VIDRIERIA CORTEZ       (Vidrios)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Calle Aroma Nº 673\\r\\n\\r\\n	Santa Cruz	Bolivia	336-5100	336-5100			\N	\N	free	\N	t	t	4.20	44	2025-06-01 09:22:05.975981	2025-06-01 13:00:56.709	vidrios
113	116	VIDRIOS Ltda.	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Barrio Guapay C/Jaime Roman Nº90\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	342-1313	342-1313			\N	\N	free	\N	t	t	4.20	20	2025-06-01 09:22:06.155628	2025-06-01 13:00:56.727	vidrios
115	118	CONPRET         (Viguetas Prensad)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Carrt.Cotoca diag. al Matader. bajr 2cuad.al sud\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	364-2830	364-2830			\N	\N	free	\N	t	t	4.20	32	2025-06-01 09:22:06.521587	2025-06-01 13:00:56.747	cemento
116	119	PALMASOLA         (Viguetas y Postes)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av. Palmasola Barrio el Transportista 6º anillo\\r\\ntel.356-38-10\\r\\n\\r\\n	Santa Cruz	Bolivia					\N	\N	free	\N	t	t	4.20	13	2025-06-01 09:22:06.71264	2025-06-01 13:00:56.764	cemento
118	121	ADESA             (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Agustin Landívar Calle 7 Nº47\\r\\n(?)\\r\\n	Santa Cruz	Bolivia	344-8472	344-8472			\N	\N	free	\N	t	t	4.20	18	2025-06-01 09:22:07.083464	2025-06-01 13:00:56.782	general
120	123	ALEXANDRA       (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	\\r\\n\\r\\n	Santa Cruz	Bolivia	343-1515	343-1515			\N	\N	free	\N	t	t	4.20	29	2025-06-01 09:22:07.44341	2025-06-01 13:00:56.8	general
121	124	Amboró Constructora	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Av. Alemana c/ Sidra Nº 2100\\r\\n\\r\\n	Santa Cruz	Bolivia	346-9719	346-9719			\N	\N	free	\N	t	t	4.20	19	2025-06-01 09:22:07.635244	2025-06-01 13:00:56.818	general
122	125	Anglarill Amboró        (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	c/ Cidra Nº 2100 ó Las Totaquis Nº 2015\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	346-9713	346-9713			\N	\N	free	\N	t	t	4.20	9	2025-06-01 09:22:07.818509	2025-06-01 13:00:56.836	general
123	126	APOLO Ltda.          (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Av.San Aurelio 3º anillo Externo\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	352-6895	352-6895	www.constapolo.com.bo		\N	\N	free	\N	t	t	4.20	42	2025-06-01 09:22:24.870747	2025-06-01 13:00:56.853	general
124	127	ARIES Ltda.                (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Ayacucho Nº 593 Segundo Piso\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	334-6792	334-6792			\N	\N	free	\N	t	t	4.20	14	2025-06-01 09:22:25.065272	2025-06-01 13:00:56.869	general
127	130	COBOC            (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	\\r\\n	Santa Cruz	Bolivia	345-2166	345-2166			\N	\N	free	\N	t	t	4.20	28	2025-06-01 09:22:25.604803	2025-06-01 13:00:56.887	general
130	133	CONPROPET Ltda.      (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Carretera a Cochabamba Km. 7 1/2\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	352-4777	352-4777			\N	\N	free	\N	t	t	4.20	39	2025-06-01 09:22:26.154249	2025-06-01 13:00:56.907	general
132	135	CRUCEÑA Ltda.         (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	4º anillo Nº 300 entre Av. Grigotá y Radial 17 1/2\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	352-4548	352-4548			\N	\N	free	\N	t	t	4.20	41	2025-06-01 09:22:26.527213	2025-06-01 13:00:56.924	general
134	137	ICAFAL-ICIL Ltda.          (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Carretera a Cotoca Km- 7 1/2\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	347-7794	347-7794			\N	\N	free	\N	t	t	4.20	23	2025-06-01 09:22:27.173962	2025-06-01 13:00:56.942	general
135	138	INPOCRUZ       (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Calle Charca Nº 88\\r\\n\\r\\n	Santa Cruz	Bolivia	333-7551	333-7551			\N	\N	free	\N	t	t	4.20	35	2025-06-01 09:22:27.350137	2025-06-01 13:00:56.962	general
137	140	LA MANSION          (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	\\r\\n\\r\\n	Santa Cruz	Bolivia	346-7037	346-7037			\N	\N	free	\N	t	t	4.20	14	2025-06-01 09:22:27.717972	2025-06-01 13:00:56.98	general
138	141	LACONT U.P.           (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Av. Irala / René Moreno edf.Jenecheru 1º piso\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	336-1266	336-1266			\N	\N	free	\N	t	t	4.20	31	2025-06-01 09:22:27.902828	2025-06-01 13:00:56.999	general
139	142	Laguna Azul             (Condominio)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	\\r\\n5\\r\\n	Santa Cruz	Bolivia	333-1122	333-1122	www.lagunaazul.com		\N	\N	free	\N	t	t	4.20	51	2025-06-01 09:22:28.085698	2025-06-01 13:00:57.015	general
140	143	LGSE     (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Calle José Vasquez Nº 29 B. El trompillo\\r\\n\\r\\n	Santa Cruz	Bolivia	357-5630	357-5630			\N	\N	free	\N	t	t	4.20	31	2025-06-01 09:22:28.26181	2025-06-01 13:00:57.033	general
141	144	MEDITERRANEO           (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	B. Ramafa c/ Chaco Nº 50\\r\\n\\r\\n	Santa Cruz	Bolivia	352-6517	352-6517			\N	\N	free	\N	t	t	4.20	9	2025-06-01 09:22:28.444936	2025-06-01 13:00:57.051	general
142	145	PENTAGONO S.R.L.       (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	c/Cellar Nº79,Entre 24 de septiembre y Libertad\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	337-2889	337-2889			\N	\N	free	\N	t	t	4.20	32	2025-06-01 09:22:46.589074	2025-06-01 13:00:57.07	general
144	147	SERTECCON  S.R.L.           (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Edif.Oriente 5º piso,of.103,Ballivian/Chuquisaca\\r\\n\\r\\n	Santa Cruz	Bolivia	335-0073	335-0073			\N	\N	free	\N	t	t	4.20	43	2025-06-01 09:22:46.95368	2025-06-01 13:00:57.086	general
145	148	TALSA         (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Asaí Nº 67\\r\\n\\r\\n	Santa Cruz	Bolivia	345-2476	345-2476			\N	\N	free	\N	t	t	4.20	7	2025-06-01 09:22:47.140268	2025-06-01 13:00:57.104	general
2	5	CASA CIMAR	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av.Brasil Nº320	Santa Cruz	Bolivia	334-7213	334-7213			\N	\N	free	\N	t	t	4.20	20	2025-06-01 09:14:57.805792	2025-06-01 13:00:57.151	general
3	6	Coprodumat	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Calle 21 de Mayo Nº 233	Santa Cruz	Bolivia	333-1976	333-1976			\N	\N	free	\N	t	t	4.20	12	2025-06-01 09:14:57.961711	2025-06-01 13:00:57.169	general
6	9	ELECTROFRIO	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av.Santa Cruz Nº 898 2º Anillo	Santa Cruz	Bolivia	337-1184	337-1184			\N	\N	free	\N	t	t	4.20	11	2025-06-01 09:14:58.444712	2025-06-01 13:00:57.187	electricos
7	10	ALFA Ltda.	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Calle Arenales Nº 67	Santa Cruz	Bolivia	335-1211	335-1211			\N	\N	free	\N	t	t	4.20	26	2025-06-01 09:14:58.609126	2025-06-01 13:00:57.205	general
8	11	Comercial DIANA	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av. Uruguay Nº 463	Santa Cruz	Bolivia	337-0542	337-0542			\N	\N	free	\N	t	t	4.20	7	2025-06-01 09:14:58.774618	2025-06-01 13:00:57.223	general
11	14	PERFIL	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av. Virgen de Cotoca Nº 2225	Santa Cruz	Bolivia	348-8152	348-8152			\N	\N	free	\N	t	t	4.20	11	2025-06-01 09:14:59.250125	2025-06-01 13:00:57.241	general
12	15	FIBRAR	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av.Cañoto Nº 140 Teléfono no habilitado	Santa Cruz	Bolivia	336-7771	336-7771			\N	\N	free	\N	t	t	4.20	25	2025-06-01 09:14:59.399535	2025-06-01 13:00:57.259	general
21	24	GOSALVEZ	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Carretera al Norte Km.8	Santa Cruz	Bolivia	342-1023	342-1023			\N	\N	free	\N	t	t	4.20	51	2025-06-01 09:15:00.801342	2025-06-01 13:00:57.277	general
24	27	San Silvestre	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	C/ 1,paralela Av.Santos Dumont, pas. 5º Anillo 8	Santa Cruz	Bolivia	356-0050	356-0050			\N	\N	free	\N	t	t	4.20	32	2025-06-01 09:15:01.265332	2025-06-01 13:00:57.295	general
28	31	GLOBAL. Ltda. (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Av. Santa Cruz Nº 709	Santa Cruz	Bolivia	364-6939	364-6939			\N	\N	free	\N	t	t	4.20	37	2025-06-01 09:15:01.916459	2025-06-01 13:00:57.317	general
37	40	SIPROTEQ S.R.L.	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Calle Velasco Nº 320\\r\\n\\r\\n	Santa Cruz	Bolivia	337-6096	337-6096			\N	\N	free	\N	t	t	4.20	5	2025-06-01 09:16:55.5265	2025-06-01 13:00:57.335	general
41	44	MAKOSE Electrocable	wholesaler	Empresa especializada en eléctrica con años de experiencia en el mercado boliviano.	Av. Grigotá Nº 694 Esq. 2º Anillo\\r\\n\\r\\n	Santa Cruz	Bolivia	354-0861	354-0861			\N	\N	free	\N	t	t	4.20	25	2025-06-01 09:16:56.16303	2025-06-01 13:00:57.354	electricos
43	46	GERIMEX	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Prolongacion Paraguá 4º Anillo\\r\\n\\r\\n	Santa Cruz	Bolivia	349-1818	349-1818			\N	\N	free	\N	t	t	4.20	6	2025-06-01 09:16:56.476093	2025-06-01 13:00:57.375	general
47	50	EL PORVENIR	retailer	Empresa especializada en electro mecánica con años de experiencia en el mercado boliviano.	Av.Cañoto Nº356\\r\\n\\r\\n	Santa Cruz	Bolivia	332-2289	332-2289			\N	\N	free	\N	t	t	4.20	11	2025-06-01 09:16:57.124466	2025-06-01 13:00:57.394	general
48	51	HONNEN Ltda.	retailer	Empresa especializada en electro mecánica con años de experiencia en el mercado boliviano.	Av. El Trompillo Esq. Chaco\\r\\n\\r\\n	Santa Cruz	Bolivia	352-4483	352-4483			\N	\N	free	\N	t	t	4.20	24	2025-06-01 09:16:57.293306	2025-06-01 13:00:57.411	general
51	54	INSERTEC	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Calle Aroma Nº 395\\r\\n\\r\\n	Santa Cruz	Bolivia	347-2121	347-2121			\N	\N	free	\N	t	t	4.20	9	2025-06-01 09:16:57.769603	2025-06-01 13:00:57.429	general
53	56	SIMEL	retailer	Empresa especializada en electro mecánica con años de experiencia en el mercado boliviano.	Radial 19 y Piraí / 3º Anillo Interno\\r\\n\\r\\n	Santa Cruz	Bolivia	352-6948	352-6948			\N	\N	free	\N	t	t	4.20	37	2025-06-01 09:16:58.08309	2025-06-01 13:00:57.446	general
54	57	Barraca 15 de Agosto	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av. 2 de Agosto/ 4º y 5º Anillo\\r\\n\\r\\n	Santa Cruz	Bolivia	347-5906	347-5906			\N	\N	free	\N	t	t	4.20	22	2025-06-01 09:16:58.240007	2025-06-01 13:00:57.464	general
57	60	CONSERCO HNOS.	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Calle Barrón Nº358\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	333-4241	333-4241			\N	\N	free	\N	t	t	4.20	47	2025-06-01 09:16:58.706391	2025-06-01 13:00:57.482	general
60	63	AMOBLARTE	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Calle Seoane Nº132, edif.Baldivieso\\r\\n\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	339-5737	339-5737			\N	\N	free	\N	t	t	4.20	20	2025-06-01 09:16:59.308619	2025-06-01 13:00:57.5	general
62	65	MUEBLES   CARPINTE ART s.r.l	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Seoane Nº 10 esq. 24 de Septiembre\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	339-1664	339-1664			\N	\N	free	\N	t	t	4.20	44	2025-06-01 09:16:59.620133	2025-06-01 13:00:57.518	maderas
63	66	MUEBLES  CORIMEXO	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Parque Industrial Manzana 5\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	349-1999	349-1999			\N	\N	free	\N	t	t	4.20	28	2025-06-01 09:16:59.775527	2025-06-01 13:00:57.536	maderas
70	73	MUEBLES       LUQUE	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Av.Viedma Nº216 esquina Warnes\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	334-0110	334-0110			\N	\N	free	\N	t	t	4.20	19	2025-06-01 09:21:39.435518	2025-06-01 13:00:57.574	maderas
79	82	MUEBLES   SOMAIN	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Calle Bunos Aires Nº 56\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	336-6066	336-6066			\N	\N	free	\N	t	t	4.20	19	2025-06-01 09:21:41.10465	2025-06-01 13:00:57.592	maderas
81	84	PINTURAS   AMERICAN Chemical	retailer	Empresa especializada en ambiental con años de experiencia en el mercado boliviano.	Parque Industrial P.I.30 a 700m. De Emacruz\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	364-4500	364-4500			\N	\N	free	\N	t	t	4.20	48	2025-06-01 09:21:41.461924	2025-06-01 13:00:57.61	pinturas
85	88	PINTURAS  PINCEL Ltda.	retailer	Empresa especializada en ambiental con años de experiencia en el mercado boliviano.	Av.Grigotá Nº258 entre 3º y 4º anillo\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	354-3131	354-3131			\N	\N	free	\N	t	t	4.20	5	2025-06-01 09:21:42.160203	2025-06-01 13:00:57.628	pinturas
88	91	Fed. De Constructores   (plomeria)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Calle Ballivian Nº28\\r\\n\\r\\n	Santa Cruz	Bolivia	334-9388	334-9388			\N	\N	free	\N	t	t	4.20	31	2025-06-01 09:21:42.691606	2025-06-01 13:00:57.651	general
90	93	S.P.P.          (Pisos)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Barrio Sirari , calles Las Begonias 6\\r\\n\\r\\n	Santa Cruz	Bolivia	341-0200	341-0200			\N	\N	free	\N	t	t	4.20	17	2025-06-01 09:21:43.034655	2025-06-01 13:00:57.669	ceramicos
91	94	ARTECOM S.R.L.       (Publicidad/Gigant)	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Av.El Trompillo Nº 366 e2º anillo\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	351-5455	351-5455			\N	\N	free	\N	t	t	4.20	30	2025-06-01 09:21:43.200951	2025-06-01 13:00:57.685	general
95	98	MARTIN GRAPHICS        (Publicidad/Gigant)	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Av.Roque Aguilera Nº120 3º An. Int.lado transito\\r\\n \\r\\n	Santa Cruz	Bolivia	351-6377	351-6377			\N	\N	free	\N	t	t	4.20	44	2025-06-01 09:21:43.945608	2025-06-01 13:00:57.703	general
98	101	T&C PUBLICIDAD        (Publicidad/Gigant)	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	2º An. Av.26 de febr. Nº769 lado Coop. Sn Martin\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	356-7027	356-7027			\N	\N	free	\N	t	t	4.20	26	2025-06-01 09:21:44.457805	2025-06-01 13:00:57.721	general
102	105	WEICAS          (Quincalleria)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Av.Santos Dumont 3º Anillo Interno\\r\\n\\r\\n	Santa Cruz	Bolivia	355-6424	355-6424			\N	\N	free	\N	t	t	4.20	22	2025-06-01 09:22:04.031227	2025-06-01 13:00:57.739	general
104	107	Crist.Templ.d.Garcia             (Vidrios)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Avenida Banzer Nº 900\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	345-1745	345-1745			\N	\N	free	\N	t	t	4.20	53	2025-06-01 09:22:04.397614	2025-06-01 13:00:57.757	vidrios
108	111	VIDRIOS     ROBERT	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Avenida Isabel La Católica Nº 460 \\r\\n	Santa Cruz	Bolivia	358-1174	358-1174			\N	\N	free	\N	t	t	4.20	8	2025-06-01 09:22:05.213592	2025-06-01 13:00:57.775	vidrios
114	117	VITEX vid.Tem.d Seg.          (Vidrios)	retailer	Empresa especializada en materiales con años de experiencia en el mercado boliviano.	Avenida Mutualista Nº209, edf.Las Camelias\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	346-8356	346-8356			\N	\N	free	\N	t	t	4.20	22	2025-06-01 09:22:06.343339	2025-06-01 13:00:57.792	vidrios
119	122	ALEMANA        (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Dr.Alejandro Ramirez Nº2\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	342-0468	342-0468			\N	\N	free	\N	t	t	4.20	44	2025-06-01 09:22:07.264778	2025-06-01 13:00:57.827	general
125	128	BOLSER       (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	km.8 Doble Via La Guardia Calle Apolo Nº 520\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	353-7878	353-7878			\N	\N	free	\N	t	t	4.20	15	2025-06-01 09:22:25.250669	2025-06-01 13:00:57.845	general
126	129	C.A. Construct. Asoc.       (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Av. Busch Nº 164, primer piso, of. 1\\r\\n\\r\\n6\\r\\n	Santa Cruz	Bolivia	333-5479	333-5479			\N	\N	free	\N	t	t	4.20	34	2025-06-01 09:22:25.426657	2025-06-01 13:00:57.864	general
128	131	COFERSA Ltda.     (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Carretera al Norte km. 3 1/2\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	342-7070	342-7070			\N	\N	free	\N	t	t	4.20	21	2025-06-01 09:22:25.782833	2025-06-01 13:00:57.882	general
129	132	CONCICA S.R.L.         (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Carretera al Norte km. 5 1/2 Nº6500\\r\\n\\r\\n	Santa Cruz	Bolivia	342-8268	342-8268			\N	\N	free	\N	t	t	4.20	11	2025-06-01 09:22:25.964705	2025-06-01 13:00:57.899	general
131	134	CONSERVICE               (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Calle Velasco Nº 365\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	332-6515	332-6515			\N	\N	free	\N	t	t	4.20	27	2025-06-01 09:22:26.345641	2025-06-01 13:00:57.917	general
133	136	DAVI       (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Galeria Casco Viejo Planta Alta Local Nº116\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	334-5404	334-5404			\N	\N	free	\N	t	t	4.20	5	2025-06-01 09:22:26.711586	2025-06-01 13:00:57.935	general
136	139	J&P YAMAMOTO   (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Av.Tte.M.Cuellar Nº200 Esq. C.El Fuerte 1ºpiso\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	339-1600	339-1600			\N	\N	free	\N	t	t	4.20	49	2025-06-01 09:22:27.53832	2025-06-01 13:00:57.952	general
143	146	ROMERO&CIA.        (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Calle Ingavi\\r\\n\\r\\n	Santa Cruz	Bolivia	332-6962	332-6962			\N	\N	free	\N	t	t	4.20	42	2025-06-01 09:22:46.771223	2025-06-01 13:00:57.97	general
146	149	TOTY Construcciones              (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	3ºAnillo Ext.c/4 Nº208(Centenario/Roca Coronad \\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	357-8547	357-8547			\N	\N	free	\N	t	t	4.20	8	2025-06-01 09:22:47.326066	2025-06-01 13:00:57.988	general
147	158	HOLLWEG              (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Lagunilla Nº 443\\r\\n\\r\\n	Santa Cruz	Bolivia	351-5857	351-5857			\N	\N	free	\N	t	t	4.20	52	2025-06-01 09:25:12.08519	2025-06-01 13:00:58.006	general
148	159	HOSSEN         (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Av. 26 De Febrero Nº 636\\r\\n\\r\\n	Santa Cruz	Bolivia	357-8080	357-8080			\N	\N	free	\N	t	t	4.20	43	2025-06-01 09:25:12.257325	2025-06-01 13:00:58.024	general
68	71	MUEBLES   LA CUISINE	manufacturer	Empresa especializada en diseño con años de experiencia en el mercado boliviano.	Calle Libertad equina Rafael Peña\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	334-8247	334-8247			\N	\N	free	\N	t	t	4.20	33	2025-06-01 09:21:05.91344	2025-06-01 13:00:57.555	maderas
117	120	ACROPOLIS    (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Av.Buch Nº410 esq. Platanillos\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	336-4936	336-4936	www.acropolisconstructora.com		\N	\N	free	\N	t	t	4.20	16	2025-06-01 09:22:06.901404	2025-06-01 13:00:57.809	general
149	161	NOGAL Constr.S.R.L.            (Constructora)	distributor	Empresa especializada en empresas con años de experiencia en el mercado boliviano.	Av.San Martin-Equipetrol Norte\\r\\n\\r\\n\\r\\n	Santa Cruz	Bolivia	341-2677	341-2677	www.nogalconstrucciones.com		\N	\N	free	\N	t	t	4.20	19	2025-06-01 09:25:12.622998	2025-06-01 13:00:58.042	general
150	162	material de prueba 	manufacturer	cañeria y otros	53 aveirnda 	Santa Cruz	Bolivia	3242	535325325			/uploads/logo-1748783859238.jpg	\N	free	\N	t	f	0.00	0	2025-06-01 12:00:56.466411	2025-06-01 13:17:40.559	plomeria
151	164	Constructora ABC	Construcción	Empresa líder en construcción de edificios residenciales y comerciales con más de 15 años de experiencia	Av. América 1234	La Paz	Bolivia	591-2-234-5678	\N	\N	\N	\N	\N	free	\N	t	f	0.00	0	2025-06-01 19:28:08.248556	2025-06-01 19:28:08.248556	Construcción General
152	165	Materiales Bolivia S.R.L.	Distribución	Distribuidores especializados en cemento, acero, agregados y materiales de construcción de primera calidad	Calle Comercio 567	Santa Cruz	Bolivia	591-3-345-6789	\N	\N	\N	\N	\N	free	\N	t	f	0.00	0	2025-06-01 19:28:08.248556	2025-06-01 19:28:08.248556	Materiales de Construcción
153	166	Ferretería Central	Ferretería	Ferretería completa con herramientas profesionales, equipos de construcción y asesoría técnica especializada	Plaza Central 89	Cochabamba	Bolivia	591-4-456-7890	\N	\N	\N	\N	\N	free	\N	t	f	0.00	0	2025-06-01 19:28:08.248556	2025-06-01 19:28:08.248556	Herramientas y Ferretería
154	167	GUÍA DE PROVEEDORES	General			La Paz	Bolivia		\N		\N	\N	\N	free	\N	t	f	0.00	0	2025-06-01 21:43:38.188843	2025-06-01 21:43:38.188843	General
155	168	EMPRESA                    DIRECCIÓN Y CONTACTO                    PRODUCTO / SERVICIO	General		CERABOL CERAMICA          Sta. Cruz: Carretera Nueva a Camiri Km. 3   • Cerámica Antideslizante	La Paz	Bolivia	591 2) 2800495	\N	www.ceramicadorado.com	\N	\N	\N	free	\N	t	f	0.00	0	2025-06-01 21:43:38.663283	2025-06-01 21:43:38.663283	General
156	169	(591 3) 332-9435 • (591) 721-48330	General		Suc. 1: Av. Cristo Redentor entre 5° y 6° anillo	La Paz	Bolivia		\N		\N	\N	\N	free	\N	t	f	0.00	0	2025-06-01 21:43:39.147972	2025-06-01 21:43:39.147972	General
157	170	(591 3) 345-1177	General		Suc. 2: Av. Fital esq. 4to anillo	La Paz	Bolivia		\N		\N	\N	\N	free	\N	t	f	0.00	0	2025-06-01 21:43:39.64137	2025-06-01 21:43:39.64137	General
158	171	(591 3) 346-2315 • 346-6050	General			La Paz	Bolivia		\N	www.cerabol.com	\N	\N	\N	free	\N	t	f	0.00	0	2025-06-01 21:43:40.114547	2025-06-01 21:43:40.114547	General
159	172	CERATECH S.R.L.           La Paz: Av. Ballivián N° 657, casi esq. 15   • Shingle - Teja Americana.	General	Edif. Sigma Planta Baja, Calacoto          Representantes de TAMKO (Roofing Products)	(591 2) 2791069 • 2795024 • 2797532       en Bolivia.	La Paz	Bolivia	591 2) 2791069	\N	www.construex.com.bo	\N	\N	\N	free	\N	t	f	0.00	0	2025-06-01 21:43:40.578926	2025-06-01 21:43:40.578926	General
160	173	(+591 2) 2284418 - 2117194	General			La Paz	Bolivia		\N		\N	\N	\N	free	\N	t	f	0.00	0	2025-06-01 23:48:05.557288	2025-06-01 23:48:05.557288	General
161	174	(+591) 77790227	General	• Perfiles de aluminio “INDALUM”		La Paz	Bolivia		\N	www.activanlum.comImporta	\N	\N	\N	free	\N	t	f	0.00	0	2025-06-01 23:48:05.976545	2025-06-01 23:48:05.976545	General
162	175	LPZ.: Obrajes esq. Av. Hernando Siles esq. calle 15	General	Provisión de Materiales:	LPZ.: Obrajes esq. Av. Hernando Siles esq. calle 15	La Paz	Bolivia	71539532	\N	www.barrientosteran.comAsistencia	\N	\N	\N	free	\N	t	f	0.00	0	2025-06-01 23:57:20.992359	2025-06-01 23:57:20.992359	General
163	176	baufuhrer.com	General	www.baufuhrer.comNuestros Servicios	LPZ.: Av. José Ballivian Nº 10 Viacha - La Paz	La Paz	Bolivia	70618576	\N	www.baufuhrer.comNuestros	\N	\N	\N	free	\N	t	f	0.00	0	2025-06-01 23:57:59.895757	2025-06-01 23:57:59.895757	General
164	177	Ceramica Dorado	Materiales de Construcción		Agencia Llojeta: Av. Mario Mercado Nº 3005	La Paz	Bolivia	2800495	\N	www.ceramicadorado.com	\N	/uploads/logo-1748923422622.jpeg	\N	free	\N	t	f	0.00	0	2025-06-01 23:58:41.369208	2025-06-03 04:07:35.851	General
\.


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.system_settings (id, setting_key, setting_value, description, updated_at) FROM stdin;
\.


--
-- Data for Name: tools; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.tools (id, name, description, unit, unit_price, is_active, created_at, updated_at) FROM stdin;
1	BOMBA DE AGUA 3HP	Herramienta de construcción: BOMBA DE AGUA 3HP	HR.	24.38	t	2025-06-01 09:30:52.272335	2025-06-01 09:30:52.272335
2	COMPACTADORAS	Herramienta de construcción: COMPACTADORAS	%	32.50	t	2025-06-01 09:30:52.300847	2025-06-01 09:30:52.300847
3	EQUIPO DE SOLDADURA	Herramienta de construcción: EQUIPO DE SOLDADURA	HR.	27.62	t	2025-06-01 09:30:52.316262	2025-06-01 09:30:52.316262
4	HERRAMIENTAS MENORES	Herramienta de construcción: HERRAMIENTAS MENORES	%	9.72	t	2025-06-01 09:30:52.331252	2025-06-01 09:30:52.331252
5	MEZCLADORA	Herramienta de construcción: MEZCLADORA	HR.	39.00	t	2025-06-01 09:30:52.347583	2025-06-01 09:30:52.347583
6	RETROEXCAVADORA	Herramienta de construcción: RETROEXCAVADORA	HR.	299.00	t	2025-06-01 09:30:52.363923	2025-06-01 09:30:52.363923
7	VIBRADORA	Herramienta de construcción: VIBRADORA	HR.	21.12	t	2025-06-01 09:30:52.379965	2025-06-01 09:30:52.379965
8	VOLQUETA	Herramienta de construcción: VOLQUETA	M3	24.38	t	2025-06-01 09:30:52.396066	2025-06-01 09:30:52.396066
9	OTROS	Herramienta de construcción: OTROS	%	1.10	t	2025-06-01 09:30:52.412087	2025-06-01 09:30:52.412087
10	COMPRESORA ATLAS COPCO	Herramienta de construcción: COMPRESORA ATLAS COPCO	HR.	97.50	t	2025-06-01 09:30:52.428253	2025-06-01 09:30:52.428253
11	EQUIPO DE PERFORACION	Herramienta de construcción: EQUIPO DE PERFORACION	HR.	56.88	t	2025-06-01 09:30:52.4527	2025-06-01 09:30:52.4527
12	Prueba de Herramientas	Herramienta de construcción: Prueba de Herramientas	Hr	240.74	t	2025-06-01 09:30:52.468846	2025-06-01 09:30:52.468846
13	ENSAYO	Herramienta de construcción: ENSAYO	HR	7.51	t	2025-06-01 09:30:52.485167	2025-06-01 09:30:52.485167
\.


--
-- Data for Name: user_material_prices; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.user_material_prices (id, user_id, material_id, custom_price, reason, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.users (id, username, password, email, first_name, last_name, role, is_active, created_at, last_login, city, country, user_type) FROM stdin;
31	global_ltda_constructora_	$2b$10$ZAuGdMgMY5HVQhsQMEQnzezp4/MW3RMHnQ2XFpuxDCAA19ps/J8YO	rr_ltda@hotmail.com	GLOBAL.	Ltda. (Constructora)	user	t	2025-06-01 09:15:01.878713	\N	Santa Cruz	Bolivia	supplier
32	granco_constructora_	$2b$10$MdXSByRvJyHWEoiafCOSWO.yAa3wQtBxn.WjzZAq2gxsN/3PWlDSO	granco@cotas.com.bo	GRANCO	(Constructora)	user	t	2025-06-01 09:15:02.058992	\N	Santa Cruz	Bolivia	supplier
33	haga_constructora_	$2b$10$W.8g47qH.XA4a.jLiQ6dW.CAqinOUQFp1ObNj/KUBXuB1CRFyxcsK	haga@cotas.com.bo	HAGA	(Constructora)	user	t	2025-06-01 09:15:02.210628	\N	Santa Cruz	Bolivia	supplier
34	hollweg_constructora_	$2b$10$AMuHKpmDw6/8iSTwHsokvOARhKab1EWrKkDiCWxn1uktKQfzacToC	hollweg_constructora_@empresa.com	HOLLWEG	(Constructora)	user	t	2025-06-01 09:15:02.361125	\N	Santa Cruz	Bolivia	supplier
35	hossen_constructora_	$2b$10$.SPOC1R2Aqu5N1w7RWr13uNRhy1qLcje5hLR0U3XAUVRsncjsNLMq	hossen_constructora_@empresa.com	HOSSEN	(Constructora)	user	t	2025-06-01 09:15:02.510287	\N	Santa Cruz	Bolivia	supplier
36	minerva_ltda_constructora_	$2b$10$EXIpOe2uusyj1YNs6lNWCuyZVrJHZPTpAZXK3obUdQh6TU1qicvMm	minerva@entelnet.bo	MINERVA	Ltda. (Constructora)	user	t	2025-06-01 09:15:02.678203	\N	Santa Cruz	Bolivia	supplier
37	nogal_constr_s_r_l_constructora_	$2b$10$J4awnRbxUn3mPUTEOj8T7e7kj8rorelqQJFZPoBpxHc7oiyhKc7Py	nogal_constr_s_r_l_constructora_@empresa.com	NOGAL	Constr.S.R.L. (Constructora)	user	t	2025-06-01 09:15:02.832597	\N	Santa Cruz	Bolivia	supplier
2	dmarquez	$2b$10$pb0rJT3tTyfsC8GTlRhJNOBwMvZanLZ1sDk6E9kvi1VDh5gnlVHFy	domarquez@yahoo.com	Diego	Marquez	admin	t	2025-05-31 21:09:21.173109	2025-06-03 09:45:21.124	\N	Bolivia	architect
4	mowrey_elevator	$2b$10$IxdfE.PPOzxqXe1kggtrpOTUC9CpIsLI6ekM.5kbRu2VAOYeaa37m	mowrey@cotas.com.bo	MOWREY	ELEVATOR	user	t	2025-06-01 09:14:57.597568	\N	Santa Cruz	Bolivia	supplier
5	casa_cimar	$2b$10$7W.HpVuj/lNBkP3stNoHeuwcS.vBOC6CWzFFbuySJhq4cLiN.AR4i	casacimar@cotas.com.bo	CASA	CIMAR	user	t	2025-06-01 09:14:57.771235	\N	Santa Cruz	Bolivia	supplier
6	coprodumat	$2b$10$YPpbDRfrziQshsBO32jRoOJ0gcTowxNbFERV6EIL/oA3GfKEqjV3.	coprodumat@empresa.com	Coprodumat		user	t	2025-06-01 09:14:57.927262	\N	Santa Cruz	Bolivia	supplier
7	amc	$2b$10$VA2Qfh5fYWzZRLaUUK2DU.GgQx9SwAzcm3ctgHtYqEuzMwKt8bXJy	amc@amc.com.bo	AMC		user	t	2025-06-01 09:14:58.084754	\N	Santa Cruz	Bolivia	supplier
8	assinco	$2b$10$eeMcjanpJM/p19Q2iS03cOovp1NCmVeCCZ.Y2lYYbTYOrv/z3Mgkm	assinco@cotas.com.bo	ASSINCO		user	t	2025-06-01 09:14:58.25329	\N	Santa Cruz	Bolivia	supplier
9	electrofrio	$2b$10$9ti5G/dRGiglSq10aaZAzel3fSkMbzS.TJavlionBYi3QcTb/a8x6	electrofrio@empresa.com	ELECTROFRIO		user	t	2025-06-01 09:14:58.412328	\N	Santa Cruz	Bolivia	supplier
10	alfa_ltda_	$2b$10$puPWQgZlt995X/x6pSiQq.iy1BZ7B1Dr3qXWqu.HQy7b0e3PrbCYK	alfa_ltda_@empresa.com	ALFA	Ltda.	user	t	2025-06-01 09:14:58.576054	\N	Santa Cruz	Bolivia	supplier
11	comercial_diana	$2b$10$xbd1Ha7r.Ho39XAKp0H3Ue6rIyNEKy5ieCJ9Pl2eVutsQnXjLTZqy	diana_meber_16@hotmail.com	Comercial	DIANA	user	t	2025-06-01 09:14:58.740208	\N	Santa Cruz	Bolivia	supplier
12	feng_shui	$2b$10$zXCFOI9ZqR6VIiUJSAdaueJT9c6BYNww4hOlIqQJ/7ydDHPgakSW2	alexandrastaht@gmail.com	FENG	SHUI	user	t	2025-06-01 09:14:58.895921	\N	Santa Cruz	Bolivia	supplier
13	import_la_popular	$2b$10$eIlKTgp8tcU7udxrvjsTYO3xaKiDv8W9WrLiY69xuFHXVeY477H5W	import_lapopular@hotmail.com	Import.	LA POPULAR	user	t	2025-06-01 09:14:59.059368	\N	Santa Cruz	Bolivia	supplier
14	perfil	$2b$10$GrL9faE6HE2F7igqSGZxqu1c.OPgpoiEUsYKme6y/G.LbiGgUlwTS	perfil@bolivia.com	PERFIL		user	t	2025-06-01 09:14:59.215013	\N	Santa Cruz	Bolivia	supplier
15	fibrar	$2b$10$PUhLlY2Dz6VLqt40EOX4jeW4BbWH4RtgRjKtbof0EqiTA6lkJld66	fibrar@empresa.com	FIBRAR		user	t	2025-06-01 09:14:59.36609	\N	Santa Cruz	Bolivia	supplier
16	industrias_ser	$2b$10$ysOCOlAAVEVoFdt/xRXS.OWwPp/RqZ4x86Tm.cwT.1IQVODJ4cNPm	industrias_ser@empresa.com	INDUSTRIAS	SER	user	t	2025-06-01 09:14:59.52272	\N	Santa Cruz	Bolivia	supplier
17	ferreteria_alexis	$2b$10$oSp.LrGkhADNksX44i5Du.fKP5ZMSVMW1OGOXuVCaLoRqoqwSab8a	ferreteria_alexis@empresa.com	Ferreteria	ALEXIS	user	t	2025-06-01 09:14:59.678708	\N	Santa Cruz	Bolivia	supplier
18	ferrobolivia	$2b$10$WBBQhOs/02OzJlSFlGv9hO.VCXELB/BlYlq5U.7JtBmCKXrHX1vWG	ferrobol@cotas.com.bo	FERROBOLIVIA		user	t	2025-06-01 09:14:59.836883	\N	Santa Cruz	Bolivia	supplier
19	soboce	$2b$10$YxRqG6ZJpqWHa0J2NA2dQuYuXqgxosm9Vj9X9kENdByUO6rQ7Uy2K	soboce@empresa.com	SOBOCE		user	t	2025-06-01 09:14:59.988999	\N	Santa Cruz	Bolivia	supplier
20	weidling_s_a_	$2b$10$a0tsVsxORwSe72klXx/zguOc7wmBNV9.YCF.iG7n69kwfzUn1FnXS	weidlingsa_ventas@cotas.com.bo	WEIDLING	S.A.	user	t	2025-06-01 09:15:00.152987	\N	Santa Cruz	Bolivia	supplier
21	comel_s_r_l_	$2b$10$ZEZdBSMoZfWFHCt./A25/.U6SgrEk3Y.Tt2eA6kiVUOoT8f.858eK	comel_s_r_l_@empresa.com	COMEL	S.R.L.	user	t	2025-06-01 09:15:00.303596	\N	Santa Cruz	Bolivia	supplier
22	emconcimet	$2b$10$DaIl6RteXNCJZ7y8k.DfR.v9WoQKhn/dt99RwNVDyLy3EcH0fPyka	emconcimet@hotmail.com	EMCONCIMET		user	t	2025-06-01 09:15:00.463759	\N	Santa Cruz	Bolivia	supplier
23	flecha_de_oro	$2b$10$5kMqZJmnE8joT2AKQBHcEu1PLvwItYdqirecXsQFSDsSPOoqraJpC	flecha_de_oro@empresa.com	FLECHA	DE ORO	user	t	2025-06-01 09:15:00.617672	\N	Santa Cruz	Bolivia	supplier
24	gosalvez	$2b$10$OBgDHiYH6fbNOpfa.C8oLu5mn43vYYMK6PiCf.CbBWvc9uidtrOcC	juangosalvez@hotmail.com	GOSALVEZ		user	t	2025-06-01 09:15:00.7685	\N	Santa Cruz	Bolivia	supplier
25	metaniqa_ltda_	$2b$10$RjlB0RZEzpp0Q.nsIPOVzOhgbUZfI62Fz7Z1ujC3gj93rfEy/nM5O	info@metaniqa.com	METANIQA	Ltda.	user	t	2025-06-01 09:15:00.925117	\N	Santa Cruz	Bolivia	supplier
26	metco_ltda_	$2b$10$jHE6krI53SXrjZx2VYuxYu.2KiExz3qYM4tW2t/mD8SJak1jDgusi	metco-kefer@cotas.com.bo	METCO	Ltda.	user	t	2025-06-01 09:15:01.077781	\N	Santa Cruz	Bolivia	supplier
27	san_silvestre	$2b$10$fo59augOdJtz/56YQwKQp.0v3BV3q5yk8E.RmmgTvxedX1pvvGYHC	san_silvestre@empresa.com	San	Silvestre	user	t	2025-06-01 09:15:01.230935	\N	Santa Cruz	Bolivia	supplier
28	ergovial_ltda_constructora_	$2b$10$zPjvEa1NPCnH7ZlQhWRS0Oz883vpmM132HqXX7saQozRiYspbzHcu	ergovial@ergovial.com	ERGOVIAL	Ltda. (Constructora)	user	t	2025-06-01 09:15:01.385052	\N	Santa Cruz	Bolivia	supplier
29	escobol_u_p_constructora_	$2b$10$K5ND1uMmc3HFwQtNFEXuvOjaoNnV41EMcuigl/ZQ/gbpZBw1lXz9i	escobol3@hotmail.com	ESCOBOL	U.P. (Constructora)	user	t	2025-06-01 09:15:01.536765	\N	Santa Cruz	Bolivia	supplier
30	ferrac_n_ltda_constructora_	$2b$10$ri1UQFWkQXIjvcVipookOuZhjuE915.zXUYG8koH1s1F7z9g8OKBK	ferraconltda@cotas.com.bo	FERRACÓN	Ltda. (Constructora)	user	t	2025-06-01 09:15:01.718757	\N	Santa Cruz	Bolivia	supplier
38	crisner	$2b$10$rFv0HMnOjujOKl85gFYZ0.l5TIcWrNTmmb9OjwzRq./oz1mSl7mwG	ventas@crisner.com/www.crisner.com	CRISNER		user	t	2025-06-01 09:16:55.163456	\N	Santa Cruz	Bolivia	supplier
39	gema_oriental	$2b$10$uLti70n2pIRwkM4Pb6emuejq7q2fdseaud6y33V2mKn4PX7FAgMAS	gema_oriental@yahoo.com	GEMA	ORIENTAL	user	t	2025-06-01 09:16:55.330502	\N	Santa Cruz	Bolivia	supplier
40	siproteq_s_r_l_	$2b$10$5LC8OTcmo4x7ek8WedkzgO6CWcyRKUOaWsrf003.ie88c9krqOQyS	siproteq_s_r_l_@empresa.com	SIPROTEQ	S.R.L.	user	t	2025-06-01 09:16:55.491227	\N	Santa Cruz	Bolivia	supplier
41	bolivian_electric	$2b$10$XrPKiHtGdESSYOUm9uXRo.aQK/e/p00BcjIoK273HFpJdEtWHxSFa	bolivian_electric@empresa.com	BOLIVIAN	ELECTRIC	user	t	2025-06-01 09:16:55.64882	\N	Santa Cruz	Bolivia	supplier
42	equicomst	$2b$10$1RxDoosA30iCyzK2z1u86OA1.HOfNLFTnwPXJLMMqQykbL6iEh8ua	info@equiconst.com	EQUICOMST		user	t	2025-06-01 09:16:55.809902	\N	Santa Cruz	Bolivia	supplier
43	fabocelt	$2b$10$J2N9rU1YUFmlE9fDQBRUWOb35bOGa/r0myXlELGTzjbb91byKEOLC	fabocelt@empresa.com	FABOCELT		user	t	2025-06-01 09:16:55.974107	\N	Santa Cruz	Bolivia	supplier
44	makose_electrocable	$2b$10$RrZlTa7J7cSCwB.Q21wseuyJbgXkN5OB9X6/aGPAdR.o7a3E4jFBO	makos@infonet.com.bo	MAKOSE	Electrocable	user	t	2025-06-01 09:16:56.128043	\N	Santa Cruz	Bolivia	supplier
45	mercantil_leon	$2b$10$4BfpK5FfxjgkuYY/u8vRvul5.MrmMA2yh5Gx0OkNRIg4EVgNSJs4m	mercantilleon@cotas.com.bo	MERCANTIL	LEON	user	t	2025-06-01 09:16:56.287816	\N	Santa Cruz	Bolivia	supplier
46	gerimex	$2b$10$H0J98VpBRn2zFZMhlRiPIuFNIW.eYsiLZ9DLmUviuf6/3CSGbEED2	gerimex@empresa.com	GERIMEX		user	t	2025-06-01 09:16:56.441591	\N	Santa Cruz	Bolivia	supplier
47	interdeco	$2b$10$hTzdv/BhIgBulwHjz/WTSe5UMW4FRlCITTUXpbz1rfwCWfkfFzaZu	interdeco@interdeco.com.bo	INTERDECO		user	t	2025-06-01 09:16:56.599054	\N	Santa Cruz	Bolivia	supplier
48	herramundo_industrial	$2b$10$NySC3/U0QpEJYTAJEJLxa.hjojeDntEc.PUQdiojx5aogv/8PLRIm	herramundo_industrial@empresa.com	Herramundo	Industrial	user	t	2025-06-01 09:16:56.752443	\N	Santa Cruz	Bolivia	supplier
49	nupra	$2b$10$6mMF42y/OY8X3WyozHf0suIHgKzJ9AmQzZOB0Liy97ZJXLRdYz7lG	nupra@sczlogic.com.bo/www.sorimen.com	NUPRA		user	t	2025-06-01 09:16:56.91627	\N	Santa Cruz	Bolivia	supplier
50	el_porvenir	$2b$10$FHMiHD.DRRBrZWy9ml8kU.nhjqCeDgPMK.rhsO/WO7wV0JLin5wH6	el_porvenir@empresa.com	EL	PORVENIR	user	t	2025-06-01 09:16:57.078895	\N	Santa Cruz	Bolivia	supplier
51	honnen_ltda_	$2b$10$VxCTRg/gLQ9l9HeVZ7ts3.jhDQPtDKs.qdSeFsSbcaYwzR7p.j5NG	honnen@honnen.com.bo	HONNEN	Ltda.	user	t	2025-06-01 09:16:57.25983	\N	Santa Cruz	Bolivia	supplier
52	icafal_icil_ltda_	$2b$10$Yu7bJtSqUZrp8AwpaCjhSufr4TtC5/XgM4ch3MfUFoadGcGv3TRCm	info@icafal-icil.com	ICAFAL	ICIL Ltda.	user	t	2025-06-01 09:16:57.41907	\N	Santa Cruz	Bolivia	supplier
53	insacruz	$2b$10$q/292V9WUyvhCTFellifO.pRa8La.ap/8w.PmQuE2JW4lCcWAQB4u	insacruz@empresa.com	INSACRUZ		user	t	2025-06-01 09:16:57.576914	\N	Santa Cruz	Bolivia	supplier
54	insertec	$2b$10$Qb.LPHvxopxNqkoRci/x8eJXRQTj6wQxXk5Ccq3c8P53UfD9sfCAu	insertec@empresa.com	INSERTEC		user	t	2025-06-01 09:16:57.734986	\N	Santa Cruz	Bolivia	supplier
55	philips_s_a_	$2b$10$HlToEt1ogY0uATNn6KA8FuScGTJPFwK41kR3qIteBv5gfEXsubi3m	philips_s_a_@empresa.com	PHILIPS	S.A.	user	t	2025-06-01 09:16:57.885105	\N	Santa Cruz	Bolivia	supplier
56	simel	$2b$10$Hwfm6Lqo.ShuSliuj5Fnw.zDEBptL6LdkfEbow/w.ouMLbP4clOji	simel@empresa.com	SIMEL		user	t	2025-06-01 09:16:58.046578	\N	Santa Cruz	Bolivia	supplier
57	barraca_15_de_agosto	$2b$10$XaaN0cvnM20VJPV75m.A.eDX4f1LEtOAvT94WNN9qNoYTUiSUpTAy	barraca_15_de_agosto@empresa.com	Barraca	15 de Agosto	user	t	2025-06-01 09:16:58.204775	\N	Santa Cruz	Bolivia	supplier
58	casa_construcci_n	$2b$10$OLe.WKkWtiamNmt8UBU8jecXng5JktntyZILI5Eoq6t8lHEY/xhhe	cyc@cotas.com.bo	Casa&Construcción		user	t	2025-06-01 09:16:58.361122	\N	Santa Cruz	Bolivia	supplier
59	cerebo	$2b$10$fzx.XqndE8sUpf72I0mKfu.qRUkPVDmuFv.wxzCh6hTFFJQ.m/Zlm	cerebo@empresa.com	CEREBO		user	t	2025-06-01 09:16:58.515036	\N	Santa Cruz	Bolivia	supplier
60	conserco_hnos_	$2b$10$e325aMktytDfrT/RAH4JFuN9vjjLr1mqcvk1SwdG7SUEFy9a7.0Ea	conserco@cotas.com.bo	CONSERCO	HNOS.	user	t	2025-06-01 09:16:58.671842	\N	Santa Cruz	Bolivia	supplier
61	finning	$2b$10$ovpMVFfZZCQ/Y56wNem2Q.xo39I8J0PFCy9xwwjDi6/BrfZ2R1rky	finning@empresa.com	FINNING		user	t	2025-06-01 09:16:58.833128	\N	Santa Cruz	Bolivia	supplier
62	magensa_ltda_	$2b$10$pdzGVsdk3QpOckPY7LI/WusHlfLd9zLcoo.lf8VSoQy8SIL/AMn3W	magensa@cotas.com.bo	MAGENSA	Ltda.	user	t	2025-06-01 09:16:58.994175	\N	Santa Cruz	Bolivia	supplier
63	amoblarte	$2b$10$tIDZ645EGI6DP2XOYSTMMeTa2A3AXoum/tep6F7bXJgzOS47Vk/kW	gerencia@amoblarte.com.bo	AMOBLARTE		user	t	2025-06-01 09:16:59.273688	\N	Santa Cruz	Bolivia	supplier
64	muebles_bolivar	$2b$10$MP14RqZLjSumAaMRbLAH5O92DT/GqMmRp0SPPx6iBOFQVGawys9fu	mueblesbolivar@mueblesboliva.com	MUEBLES	     BOLIVAR	user	t	2025-06-01 09:16:59.428024	\N	Santa Cruz	Bolivia	supplier
65	muebles_carpinte_art_s_r_l	$2b$10$PE/JDHZMPuDd1LLxRCizu.lr1j4JiZEClOmLBHxlsdrUBG7C.9/lq	carpinteart-bo@hotmail.com	MUEBLES	  CARPINTE ART s.r.l	user	t	2025-06-01 09:16:59.586702	\N	Santa Cruz	Bolivia	supplier
66	muebles_corimexo	$2b$10$v2w1Li0Hd3MIjAPVScau/ewsJdBaSdQWJ6F/F12DrfbN8lk4ZiSMG	corimexo@corimexo.com	MUEBLES	 CORIMEXO	user	t	2025-06-01 09:16:59.739829	\N	Santa Cruz	Bolivia	supplier
67	muebles_e_h_m_s_r_l_	$2b$10$.pOozg/d8p05ZQ8oifJa4OqGM7WQQZX84MPP4ZsYh2jpbuiB7hM5C	ehmuebles_srl@cotas.com.bo	MUEBLES	 E.H.M. s.r.l.	user	t	2025-06-01 09:16:59.899372	\N	Santa Cruz	Bolivia	supplier
68	muebles_fenix_s_a_	$2b$10$Ec/trlrPfs9Gs3.w1KA5I.J45b74dVwgIOiuoTrKGcqmMZ17alFYK	eduardoventas@eduardo-bolivia.com	MUEBLES	  FENIX S.A.	user	t	2025-06-01 09:21:05.305081	\N	Santa Cruz	Bolivia	supplier
69	muebles_formas_tendencias	$2b$10$tjp4mppDg502PGqCoerTBug1MahSCI3MamwWS8gDK6Jgeg55hH7Om	correo@fytdesign.com	MUEBLES	  Formas&Tendencias	user	t	2025-06-01 09:21:05.528495	\N	Santa Cruz	Bolivia	supplier
70	gramar_mosaico_marmol_	$2b$10$.dHaQDYe/Kfl2xo6YrtpNu/YVBZdWZpOALPDdEJV.W1sOXcC02UW2	gramar@cotas.com.bo	GRAMAR	     (mosaico/marmol)	user	t	2025-06-01 09:21:05.705498	\N	Santa Cruz	Bolivia	supplier
71	muebles_la_cuisine	$2b$10$/WZzwB8JTnvUwX3iwS8.pOD1a8mMIe/oPDSSa5L2N93k2f6v6MTq2	cuisine2@entelnet.bo	MUEBLES	  LA CUISINE	user	t	2025-06-01 09:21:05.875188	\N	Santa Cruz	Bolivia	supplier
72	muebles_la_farola	$2b$10$moXo9yXln8O8BxJGtNWQPeGZ0kIPLo0UYTpfE1Ct0TZ64Qch6VdCa	lafarola@cotas.com.bo	MUEBLES	  LA FAROLA	user	t	2025-06-01 09:21:39.228647	\N	Santa Cruz	Bolivia	supplier
73	muebles_luque	$2b$10$wDMw3Gvn/LZGyoLoJAo3suF6qmpqCiFQH7A36uRC9RmX8fttCKHAW	ventas@amoblamientosluque.com	MUEBLES	      LUQUE	user	t	2025-06-01 09:21:39.401266	\N	Santa Cruz	Bolivia	supplier
74	muebles_mobilier	$2b$10$cgLU6snvVt.DeLsnoKxfxuzTjlhwGeCvA59GHPmvG8HLc.y6cPi4i	muebles_mobilier@empresa.com	MUEBLES	  MOBILIER	user	t	2025-06-01 09:21:39.575827	\N	Santa Cruz	Bolivia	supplier
75	muebleria_inti	$2b$10$5OZqoJ9gBn4faenERYCaVOjoVAZuxoJK/Y/06PtM82wxdXvBuDVZq	ventas@mueblesinti.com	MUEBLERIA	INTI	user	t	2025-06-01 09:21:39.757962	\N	Santa Cruz	Bolivia	supplier
76	muebles_fatima	$2b$10$jm1V8v//9huIV5EaaBZjluZSsVsA5p9wnNdlSPjun1Iwi76GZgDFa	info@fatimamuebles.com	Muebles	FATIMA	user	t	2025-06-01 09:21:39.941537	\N	Santa Cruz	Bolivia	supplier
77	muebles_hurtado	$2b$10$zKn4kXVtCZY9grL6vP1JXOfO.F4DI2g26f6MNPnHiMnGKIi8e4kLm	industria@muebleshurtado.com	MUEBLES	HURTADO	user	t	2025-06-01 09:21:40.198915	\N	Santa Cruz	Bolivia	supplier
78	muebles_nahi_s_r_l_	$2b$10$dnGhkIiBdACl0tpi7p1rHOZoxDjSicco2Uzch/k2aotM8epkRaowi	nahi_scz@yahoo.com	MUEBLES	NAHI S.R.L.	user	t	2025-06-01 09:21:40.370083	\N	Santa Cruz	Bolivia	supplier
79	muebles_open_line	$2b$10$hIEcAGcpYSXL6ZQ14VhoQea4wZYas/i6Dtq4DVtvxiyYYdIUFfDJu	openline@cotas.net	MUEBLES	OPEN LINE	user	t	2025-06-01 09:21:40.546139	\N	Santa Cruz	Bolivia	supplier
80	_muebles_qualit_s_r_l_	$2b$10$RMPkSoJkSowHlmORr.1Hmu2l9Py5xfmgCL1eNZQPA28TFaQWoPFdW	qualite_srl@hotmail.com		MUEBLES  QUALITÉ S.R.L.	user	t	2025-06-01 09:21:40.723853	\N	Santa Cruz	Bolivia	supplier
81	mueles_sion_s_r_l_	$2b$10$x8TV5ObZb7l0fMGvCxFHqeSBTUUei72gIZT/d4SAks3A8dGzeGoEi	muebleriasion@cotas.com.bo	MUELES	 SION S.R.L.	user	t	2025-06-01 09:21:40.898008	\N	Santa Cruz	Bolivia	supplier
82	muebles_somain	$2b$10$SBfix4u6KJwOb6bEUWzh6.FqLSRWMFbM.AuZXmwCI3D0E1jIhp.wa	ventas@mueblessomain.com.bo	MUEBLES	  SOMAIN	user	t	2025-06-01 09:21:41.070141	\N	Santa Cruz	Bolivia	supplier
83	muebles_tuma_hermanos	$2b$10$E/OkjibozTF/jvv5CgIOiuH5qXMR5Vb33YAxFMk8dYZeIqd1IDmiu	muebles_tuma_hermanos@empresa.com	MUEBLES	   TUMA HERMANOS	user	t	2025-06-01 09:21:41.252122	\N	Santa Cruz	Bolivia	supplier
84	pinturas_american_chemical	$2b$10$hORweB28UHPdFwoU4TNEAe/tjOP9neDipGOVv7ZcCwuuEVkFYVvnm	sjustinianoa@cotas.com.bo	PINTURAS	  AMERICAN Chemical	user	t	2025-06-01 09:21:41.428344	\N	Santa Cruz	Bolivia	supplier
85	pinturas_boincos_s_a_	$2b$10$7IGC4.T8E57ZZIHghh9L4e0XjYq/j3OcDdL8zjkgfLZD7/OV3Kjea	boincos@cotas.net	PINTURAS	  BOINCOS S.A.	user	t	2025-06-01 09:21:41.603753	\N	Santa Cruz	Bolivia	supplier
86	pinturas_casa_color_coral_	$2b$10$N4Qevt1dNgQLCNc4jyFo0.3xoNlYaWFDfbVXlwTw9MUn5iBbWU6qC	gruporibepar@ribepar.com.bo	PINTURAS	  CASA COLOR(Coral)	user	t	2025-06-01 09:21:41.775507	\N	Santa Cruz	Bolivia	supplier
87	pinturas_piarli	$2b$10$uuoxpav9vZi9AecwVRJ9neUB8xUARFXCT8BiQAKa4uc8e3k9yxSkO	piarli@cotas.com.bo	PINTURAS	 PIARLI	user	t	2025-06-01 09:21:41.952246	\N	Santa Cruz	Bolivia	supplier
88	pinturas_pincel_ltda_	$2b$10$KUy65a2IAugqXG9TJeOUH..sFQxOarriYWriWjcFi9oNg4x2xPOMe	pincel@unete.com	PINTURAS	 PINCEL Ltda.	user	t	2025-06-01 09:21:42.126381	\N	Santa Cruz	Bolivia	supplier
89	pinturas_sadip	$2b$10$1Syj4K0HdgJBDpLkrGoCLug7HzVPOieiG1H78WN9ImEV0iSOSBjIW	sadip_co@cotas.com.bo	PINTURAS	 SADIP	user	t	2025-06-01 09:21:42.296739	\N	Santa Cruz	Bolivia	supplier
90	pituras_sherwin_williams	$2b$10$sdbgzDGE8lmL1PqUH71yo.0XZGDo0s//aAaNZby9.D.yIfttB7u9O	liderbol@cotas.com.bo	PITURAS	  Sherwin Williams	user	t	2025-06-01 09:21:42.471551	\N	Santa Cruz	Bolivia	supplier
91	fed_de_constructores_plomeria_	$2b$10$bYqMWzui5gNxDZrjwVd/ku8A7F7bCnMAkic7rq/w7.phQOXq8Oh1G	fed_de_constructores_plomeria_@empresa.com	Fed.	De Constructores   (plomeria)	user	t	2025-06-01 09:21:42.657724	\N	Santa Cruz	Bolivia	supplier
92	r_m_importaciones_porcelanato_randas_	$2b$10$jwANwYzVx3qBFe.5MGbvJ.zhf15OJWe7yKCVzKMM21aVBvFCwkjF2	mvalenzuela@cotas.com.bo	R	& M Importaciones   (Porcelanato,randas)	user	t	2025-06-01 09:21:42.827393	\N	Santa Cruz	Bolivia	supplier
93	s_p_p_pisos_	$2b$10$7ReWrvX2c4huMSNXxzi4wuy72Q4zGZ7UCCR/xOV3S9w.bit.Ikx0W	spp@cotas.com.bo	S.P.P.	         (Pisos)	user	t	2025-06-01 09:21:43.000501	\N	Santa Cruz	Bolivia	supplier
94	artecom_s_r_l_publicidad_gigant_	$2b$10$qF1cFM6Ot2KeVGTo3ur1w.aHjSJ9cwTjHV6Av/XJd47VyI4PXjd9a	adm@artecom.com.bo	ARTECOM	S.R.L.       (Publicidad/Gigant)	user	t	2025-06-01 09:21:43.16764	\N	Santa Cruz	Bolivia	supplier
95	innova_publicidad_gigant_	$2b$10$e2OVLzysY4e19d3u9BmFD.XH8zkywWYP8kDSDCGuNztd5S/HoG2uu	innovacom@cotas.com	INNOVA	         (Publicidad/Gigant)	user	t	2025-06-01 09:21:43.335372	\N	Santa Cruz	Bolivia	supplier
96	logos_publicidad_gigant_	$2b$10$DQE9q1IJLNiqd83lsHRYpuI1OSXmXSkam483th5CrLtSKrl7QaABO	logosvisual@yahoo.es	LOGOS	         (Publicidad/Gigant)	user	t	2025-06-01 09:21:43.507528	\N	Santa Cruz	Bolivia	supplier
97	mahs_publicidad_gigant_	$2b$10$STll6cuI.ABS9TBzZpLlUePzYKDV.8GLZVhSgbVKnwvbeUvmxJDxW	consultas@mahs.com.bo	MAHS	          (Publicidad/Gigant)	user	t	2025-06-01 09:21:43.676138	\N	Santa Cruz	Bolivia	supplier
98	martin_graphics_publicidad_gigant_	$2b$10$v.GjGjjwKFRsv2VdjT0fauBy8qlxudRlhoSlGbupPxXk.9TXTLB7a	martingraphic@cotas.com.bo	MARTIN	GRAPHICS        (Publicidad/Gigant)	user	t	2025-06-01 09:21:43.911018	\N	Santa Cruz	Bolivia	supplier
99	neon_star_publicidad_gigant_	$2b$10$t470J9uvFREMj318Hhpueu8tosbHVBsjykosHGSizngzs6tOyx9bO	neonstar@cotas.com.bo	NEON	STAR       (Publicidad/Gigant)	user	t	2025-06-01 09:21:44.080888	\N	Santa Cruz	Bolivia	supplier
100	stilo_publicidad_gigant_	$2b$10$AAb/UCBGFEJ2KGfenopwC.xCClvo8LeEM8sg2RVAYoq9aIgFugJ12	stilo@cotas.com.bo	STILO	  (Publicidad/Gigant)	user	t	2025-06-01 09:21:44.251188	\N	Santa Cruz	Bolivia	supplier
101	t_c_publicidad_publicidad_gigant_	$2b$10$48Aw5RNQ8Tweg5g/zwXT4.gIHHD.4ckmNie6cr83UdDEzdd7CpdM.	ventas@tycpublicidad.com	T&C	PUBLICIDAD        (Publicidad/Gigant)	user	t	2025-06-01 09:21:44.423175	\N	Santa Cruz	Bolivia	supplier
102	of_tec_de_servicios_refacciones_	$2b$10$eEB7N8fwX/UQDsk0SIdMT.LOO7iJT4EaEKtRSZn7sJR6cT1GID70C	of_tec_de_servicios_refacciones_@empresa.com	OF.TEC.de	Servicios         (Refacciones)	user	t	2025-06-01 09:21:44.647306	\N	Santa Cruz	Bolivia	supplier
103	plasmar_tuberias_	$2b$10$pQ4ab8YTqh137UcXxjYE3u0X2UjUR/oe0I4S23aPVpXMzZ4hzI.bK	plasmar@plasmar.com.bo	PLASMAR	         (Tuberias)	user	t	2025-06-01 09:21:44.834434	\N	Santa Cruz	Bolivia	supplier
104	talleres_v_m_varidades_	$2b$10$HWko89iy.XMCyY.jBIkJWubDjACnhbs0d5Wf1qgRGxOBguFdiT2CW	miranda@hotmail.com	Talleres	V & M      (Varidades)	user	t	2025-06-01 09:22:03.803315	\N	Santa Cruz	Bolivia	supplier
105	weicas_quincalleria_	$2b$10$HbB2ToqNEAtlE/8pz0EVJOXlv3re.TT41QRCcUNlGxTG7w8MHc30S	weicas_quincalleria_@empresa.com	WEICAS	         (Quincalleria)	user	t	2025-06-01 09:22:03.991586	\N	Santa Cruz	Bolivia	supplier
106	c_m_cruce_a_vidrios_	$2b$10$1qhjQ98pH10udqs0Yb6q1eNQHGF5YrWXwYcfQIibX8BYbEvZts4HC	c_m_cruce_a_vidrios_@empresa.com	C	M Cruceña        (Vidrios)	user	t	2025-06-01 09:22:04.175622	\N	Santa Cruz	Bolivia	supplier
107	crist_templ_d_garcia_vidrios_	$2b$10$hE9FoHBi5KZ12oT4074CmuoL2BsbywGiYn25uxkklWLee3z7RN0x6	crist_templ_d_garcia_vidrios_@empresa.com	Crist.Templ.d.Garcia	            (Vidrios)	user	t	2025-06-01 09:22:04.359008	\N	Santa Cruz	Bolivia	supplier
108	gema_oriental_vidrios_	$2b$10$TWlv.dRXa52jldzf8OzkG.TIGmNXsh1r1bKIrnwwXpXGI2XfJYFRi	gema_oriental_vidrios_@empresa.com	GEMA	ORIENTAL               ( Vidrios)	user	t	2025-06-01 09:22:04.601569	\N	Santa Cruz	Bolivia	supplier
109	mil_metales_s_r_l_vidrios_	$2b$10$RbNk3m5/IhSB6SQJgyI4GuQnDwbrByPXBWGuSiDBV5ep9SDq4yfbK	milmetales@hotmail.com	MIL	METALES S.R.L.         (Vidrios)	user	t	2025-06-01 09:22:04.797463	\N	Santa Cruz	Bolivia	supplier
110	persialuvid_vidrios_	$2b$10$LruFf.n/NzpAwL6uOlx/D.apJNnypt.M4mtknq.GkMCA4Gnh1jN06	persialuvid_vidrios_@empresa.com	PersiAluVid.	        (Vidrios)	user	t	2025-06-01 09:22:04.985582	\N	Santa Cruz	Bolivia	supplier
111	vidrios_robert	$2b$10$.M5qZ4qqhMRuUXo4r95NcevHkY0RppWU359E33cbPY.3WRA2rjlci	vidrios_robert@empresa.com	VIDRIOS	    ROBERT	user	t	2025-06-01 09:22:05.175068	\N	Santa Cruz	Bolivia	supplier
112	san_silvestre_vidrios_	$2b$10$8SvcmC1ooFxmcluDYr1xauGdT2YoXQAzdmUJGFVeseyteokiOQ8HK	san_silvestre_vidrios_@empresa.com	San	Silvestre       (Vidrios)	user	t	2025-06-01 09:22:05.354777	\N	Santa Cruz	Bolivia	supplier
113	santa_cruz_vidrios_	$2b$10$FPqVMj6vYnBEoVDb1LH7nuFlTVd60RAxieugJtBGg5aCt.mH1H2C.	santa_cruz_vidrios_@empresa.com	SANTA	CRUZ               (Vidrios)	user	t	2025-06-01 09:22:05.539319	\N	Santa Cruz	Bolivia	supplier
114	vid_y_marquet_fito_vidrios_	$2b$10$Z7jUbzfqdO/eT0iVZDYf7eba2MWjA5ZIqFLsbnq2v8jvq.iRA1Ove	vid_y_marquet_fito_vidrios_@empresa.com	Vid.y	Marquet.FITO         (Vidrios)	user	t	2025-06-01 09:22:05.743659	\N	Santa Cruz	Bolivia	supplier
115	vidrieria_cortez_vidrios_	$2b$10$ZyEhv8EQHhbIKlEp9Tcxm.GNUyQcqQAJUNpifAGpIb5/gJiZhtRDO	vidrieria_cortez_vidrios_@empresa.com	VIDRIERIA	CORTEZ       (Vidrios)	user	t	2025-06-01 09:22:05.936057	\N	Santa Cruz	Bolivia	supplier
116	vidrios_ltda_	$2b$10$pa./jzooVxIENyH4/VlXl.2OOHMwAbz1dR5tnb2KBaVS67aFF97Ka	vidriosltda@cotas.com.bo	VIDRIOS	Ltda.	user	t	2025-06-01 09:22:06.117382	\N	Santa Cruz	Bolivia	supplier
117	vitex_vid_tem_d_seg_vidrios_	$2b$10$TEEE13honjqHfGyv/eYUuOC1mGFJR.E2S0WHDEYDkWVedYGkQkRj6	vitex@cotas.com.bo	VITEX	vid.Tem.d Seg.          (Vidrios)	user	t	2025-06-01 09:22:06.304318	\N	Santa Cruz	Bolivia	supplier
118	conpret_viguetas_prensad_	$2b$10$jnkBmsSjykvlronRRvdiy.3vupSpPQWtaIJQru0fI5ypaH2y1/i.O	conpret_viguetas_prensad_@empresa.com	CONPRET	        (Viguetas Prensad)	user	t	2025-06-01 09:22:06.48428	\N	Santa Cruz	Bolivia	supplier
119	palmasola_viguetas_y_postes_	$2b$10$awcaXJqbNRTFoH6qWxv3oeTjNEYenehqsrjGWQfNe76oNY5abx0CC	palmasola_viguetas_y_postes_@empresa.com	PALMASOLA	        (Viguetas y Postes)	user	t	2025-06-01 09:22:06.67537	\N	Santa Cruz	Bolivia	supplier
120	acropolis_constructora_	$2b$10$5DwSjwAI9eLkp8129Zqga.4hedpJprtbmuxMvG7UTTiC5CgKL.v3K	acropolis_constructora_@empresa.com	ACROPOLIS	   (Constructora)	user	t	2025-06-01 09:22:06.863064	\N	Santa Cruz	Bolivia	supplier
121	adesa_constructora_	$2b$10$dHCVCEaDmD25MydYSTOlUuxzT7hTQDpj/BoWEKJj.OIxDTl3eEuya	adesa_constructora_@empresa.com	ADESA	            (Constructora)	user	t	2025-06-01 09:22:07.044597	\N	Santa Cruz	Bolivia	supplier
122	alemana_constructora_	$2b$10$ipiTR31o/2ElJ9nN40IWPekQTNjZSTXHgu0jJqfKSqkbXVME0HJBi	alemana_constructora_@empresa.com	ALEMANA	       (Constructora)	user	t	2025-06-01 09:22:07.226276	\N	Santa Cruz	Bolivia	supplier
123	alexandra_constructora_	$2b$10$RFJH9l5N3QQW80IV.vG5XOLC7RnUn3vdZkcG65dFBzaXvl30YMFDK	alexandra_constructora_@empresa.com	ALEXANDRA	      (Constructora)	user	t	2025-06-01 09:22:07.405105	\N	Santa Cruz	Bolivia	supplier
124	ambor_constructora	$2b$10$aciM1jivb5a10ljCZMB1/eEB7yZ7NsCAAA0hklZ0eaSRC0SAUQaTi	ambor_constructora@empresa.com	Amboró	Constructora	user	t	2025-06-01 09:22:07.595286	\N	Santa Cruz	Bolivia	supplier
125	anglarill_ambor_constructora_	$2b$10$VQgqp78quduF95KBG0oYo.ZSxpA4OYO/iCjVNjW3W9YQfQD0fi1Ja	aamboro@cotas.com.bo	Anglarill	Amboró        (Constructora)	user	t	2025-06-01 09:22:07.781396	\N	Santa Cruz	Bolivia	supplier
126	apolo_ltda_constructora_	$2b$10$2uIMVbmjFD5znupTv9hkoebbvNWHe9UA7a1UKlXeCVFAeOrfJzMji	apolo_ltda_constructora_@empresa.com	APOLO	Ltda.          (Constructora)	user	t	2025-06-01 09:22:07.970618	\N	Santa Cruz	Bolivia	supplier
127	aries_ltda_constructora_	$2b$10$N4YdhrhsinDhk6Zhr13MIec08YKFKxs0NZKm.n4oNn6cSMWRqvnse	ariesltd@entelnet.bo	ARIES	Ltda.                (Constructora)	user	t	2025-06-01 09:22:25.027805	\N	Santa Cruz	Bolivia	supplier
128	bolser_constructora_	$2b$10$rU/O5CW1JdeVeHGQFMUCtuUMc71mWX4WKlOjLjCn1i98KwWOqtNSK	main@apolo-bo.net	BOLSER	      (Constructora)	user	t	2025-06-01 09:22:25.21417	\N	Santa Cruz	Bolivia	supplier
129	c_a_construct_asoc_constructora_	$2b$10$kjbWxqDJMG.6xJdnnXa13O2zi/F6Df0WctPFZa8PuW6qrFnrveh4.	c_asociados@cotas.com.bo	C.A.	Construct. Asoc.       (Constructora)	user	t	2025-06-01 09:22:25.387134	\N	Santa Cruz	Bolivia	supplier
130	coboc_constructora_	$2b$10$YowNiBMxiCGemEYj0gNSzulFFxRy45oZAF5u3Vlvtk8J4PgyuiJn.	coboc_constructora_@empresa.com	COBOC	           (Constructora)	user	t	2025-06-01 09:22:25.569115	\N	Santa Cruz	Bolivia	supplier
131	cofersa_ltda_constructora_	$2b$10$lcCZczmrLPQZdaV4XJax3uBcTkRx0k9E0iG77E119JpMjaA/xrLDi	cofersa@entelnet.bo	COFERSA	Ltda.     (Constructora)	user	t	2025-06-01 09:22:25.746075	\N	Santa Cruz	Bolivia	supplier
132	concica_s_r_l_constructora_	$2b$10$x0ad8toaaIB3Sga3/EoJK.Rfh.pEujxgEBUttrOr9Fv2PBAg0nAjq	concica_s_r_l_constructora_@empresa.com	CONCICA	S.R.L.         (Constructora)	user	t	2025-06-01 09:22:25.928175	\N	Santa Cruz	Bolivia	supplier
133	conpropet_ltda_constructora_	$2b$10$XexFcQOmzlvjQ2YNiRJLtOtCqSW0xR2UgyxnRaB6mrI9jqo0huT22	conpropet@conpropet.com	CONPROPET	Ltda.      (Constructora)	user	t	2025-06-01 09:22:26.116849	\N	Santa Cruz	Bolivia	supplier
134	conservice_constructora_	$2b$10$4TSxG5fvE7Hl4Gs/tdqTXOwXDrHONx8x.zjUg3F/pryOCcwk0wPNW	conservice@cotas.com.bo	CONSERVICE	              (Constructora)	user	t	2025-06-01 09:22:26.304034	\N	Santa Cruz	Bolivia	supplier
135	cruce_a_ltda_constructora_	$2b$10$/IOI0AU1R0w2DLd7Q9MFZ.XZclP/c6eLIwdzDYERISZX8GMHbm1ES	cruceña@entelnet.bo	CRUCEÑA	Ltda.         (Constructora)	user	t	2025-06-01 09:22:26.487365	\N	Santa Cruz	Bolivia	supplier
136	davi_constructora_	$2b$10$Vz4ZoypKcUUxYrCcPAqOXeWp5B7IB6OYD791yenqpKzUuafGphv6y	davi@cotas.com.bo	DAVI	      (Constructora)	user	t	2025-06-01 09:22:26.675146	\N	Santa Cruz	Bolivia	supplier
137	icafal_icil_ltda_constructora_	$2b$10$CgxhpuhLcpZSokTd3z5weOO48TQITDCBS7SjD2MXx5Xd95Lxyv6RK	icafal_icil_ltda_constructora_@empresa.com	ICAFAL-ICIL	Ltda.          (Constructora)	user	t	2025-06-01 09:22:27.137041	\N	Santa Cruz	Bolivia	supplier
138	inpocruz_constructora_	$2b$10$sX08yUyuQhlcUR4MCeahZeb30eGKapigHMnwXf4tmHhZJ2lw5fyra	inpro_cruz@hotmail.com	INPOCRUZ	      (Constructora)	user	t	2025-06-01 09:22:27.313739	\N	Santa Cruz	Bolivia	supplier
139	j_p_yamamoto_constructora_	$2b$10$FMLTtJrDrznhFOKr1PF/E.HIiTQxCYGRSmZl16Ib/0YK27UATFc2i	jpyamamoto@cotas.com.bo	J&P	YAMAMOTO   (Constructora)	user	t	2025-06-01 09:22:27.491869	\N	Santa Cruz	Bolivia	supplier
140	la_mansion_constructora_	$2b$10$Wi8hjfiJrlvnw9rKJjtQA.KUmsC0CV00RiQmV1n2U9hYGH/bnhauK	la_mansion_constructora_@empresa.com	LA	MANSION          (Constructora)	user	t	2025-06-01 09:22:27.680769	\N	Santa Cruz	Bolivia	supplier
141	lacont_u_p_constructora_	$2b$10$wpWKIhFHHu0wJNpWWGbMPu6CnCs9OigU2PcZ.byPCCH1AtLNr8dy2	lacont_u_p_constructora_@empresa.com	LACONT	U.P.           (Constructora)	user	t	2025-06-01 09:22:27.864652	\N	Santa Cruz	Bolivia	supplier
142	laguna_azul_condominio_	$2b$10$hYMG9HWOzPzw0qdfsJcbce6etYaixCv0Xi.5Xz5sEmkL/L6rwG31i	laguna_azul_condominio_@empresa.com	Laguna	Azul             (Condominio)	user	t	2025-06-01 09:22:28.049191	\N	Santa Cruz	Bolivia	supplier
143	lgse_constructora_	$2b$10$1q71SIxWcMm6oQXl559y6u.A47hfXjIUHdihkvOVZC8gqQCdhY/Fi	lgse@cotas.com.bo	LGSE	    (Constructora)	user	t	2025-06-01 09:22:28.224498	\N	Santa Cruz	Bolivia	supplier
144	mediterraneo_constructora_	$2b$10$kJfBan6XZhnxcdJw5QLJ8OzKXC0TnYrNwa1SmzNY5.hAxxaMwhlPy	mediterraneo@c-mediterraneo.com	MEDITERRANEO	          (Constructora)	user	t	2025-06-01 09:22:28.408423	\N	Santa Cruz	Bolivia	supplier
145	pentagono_s_r_l_constructora_	$2b$10$2PMKGamE8A4HtcwxHyZv/OxwiSMD3pawQJWWQgClxxV/0kW5CwYeG	pentagono_srl@hotmail.com	PENTAGONO	S.R.L.       (Constructora)	user	t	2025-06-01 09:22:46.549557	\N	Santa Cruz	Bolivia	supplier
146	romero_cia_constructora_	$2b$10$gZVSGnIAdXgbn1XIKlPbM.e5zS.pBoBi/3cLAyuJW66yItTBEoobG	aromero@cotas.com.bo	ROMERO&CIA.	       (Constructora)	user	t	2025-06-01 09:22:46.731562	\N	Santa Cruz	Bolivia	supplier
147	serteccon_s_r_l_constructora_	$2b$10$/JrOj5XYFy/AMXdca7QF7uxKPG1hHKOlOUHLrkjVNHePjgCuzscEu	serteccon@cotas.com.bo	SERTECCON	 S.R.L.           (Constructora)	user	t	2025-06-01 09:22:46.916162	\N	Santa Cruz	Bolivia	supplier
148	talsa_constructora_	$2b$10$YHl4U.U2PX5jydVDs1MkpO5OTXcXQh.fypcPPoYS.dIxqq.CLpQ7K	talsa_constructora_@empresa.com	TALSA	        (Constructora)	user	t	2025-06-01 09:22:47.101076	\N	Santa Cruz	Bolivia	supplier
149	toty_construcciones_constructora_	$2b$10$OguLJFPXhYPjv1CcW/LPsuSPvgr3BM6vIecSElcJcHHpf9/nyCbFK	totyconstrucciones@cotas.net	TOTY	Construcciones              (Constructora)	user	t	2025-06-01 09:22:47.290126	\N	Santa Cruz	Bolivia	supplier
158	hollweg_constructora__1	$2b$10$cSSUFLgJTnhhZzzqI2hmuu2IiTG0Jq60RyhY45D4N0wymLtqrjqyy	hollweg_constructora__1@empresa.com	HOLLWEG	             (Constructora)	user	t	2025-06-01 09:25:12.065563	\N	Santa Cruz	Bolivia	supplier
159	hossen_constructora__1	$2b$10$Gk.Xm1zGh6KUjrdPYAWrO.4h/DrbgxgvPDtCZ6JAl7URRhL/CtuPO	hossen_constructora__1@empresa.com	HOSSEN	        (Constructora)	user	t	2025-06-01 09:25:12.237694	\N	Santa Cruz	Bolivia	supplier
161	nogal_constr_s_r_l_constructora__1	$2b$10$bgxWzPhFdO8P76mOBv7KieZZW8AIw7eG6Nc3nL8.4GWv9NxXckrjW	nogal_constr_s_r_l_constructora__1@empresa.com	NOGAL	Constr.S.R.L.            (Constructora)	user	t	2025-06-01 09:25:12.607464	\N	Santa Cruz	Bolivia	supplier
176	baufuhrer_com	$2b$12$jYOUrGOxCsid7g3WU6vTfeD1KDovU3i2r3EgMVa6o8600zaAZhT0i	hanns.romer@baufuhrer.com	\N	\N	user	t	2025-06-01 23:57:59.875191	\N	\N	Bolivia	supplier
177	www_ceramicadorado_com	$2b$12$TpVrIvTYBnxJs.zmMqs2x.CPZDcS5XXieusXpxLN0VT/HwN06ZmCe	juliosusara@gmail.com	\N	\N	user	t	2025-06-01 23:58:41.349152	\N	\N	Bolivia	supplier
164	constructora_abc	$2a$10$example_hash	info@constructora-abc.com	\N	\N	user	t	2025-06-01 19:27:13.596494	\N	\N	Bolivia	supplier
165	materiales_bolivia	$2a$10$example_hash	ventas@materialesbolivia.com	\N	\N	user	t	2025-06-01 19:27:13.596494	\N	\N	Bolivia	supplier
166	ferreteria_central	$2a$10$example_hash	contacto@ferreteriacentral.com	\N	\N	user	t	2025-06-01 19:27:13.596494	\N	\N	Bolivia	supplier
163	JoseM	$2b$12$BTTjU7m1scc3fJj5WpYBLO9a0wkb.tDhnlLIuY8tckbFufRlWQJyy	marqjose@gmail.com	Jose	Marquez	user	t	2025-06-01 15:03:12.690144	2025-06-01 21:21:51.958	\N	Bolivia	architect
167	gu_a_de_proveedores	$2b$12$RUne0A..XDxvc7jX6NZcHOR7ZVK/wH0T.Dq.V7xB9aOf7gHLV8fum	gu_a_de_proveedores@example.com	\N	\N	user	t	2025-06-01 21:43:38.158716	\N	\N	Bolivia	supplier
168	empresa____________________direcci_n_y_contacto___	$2b$12$.2Gw1t4WYSJdXTgWxWpq2uGUQ4HBqdyuixpxKYtxrVowNqW.f3C4O	juliocesar@gmail.com	\N	\N	user	t	2025-06-01 21:43:38.644469	\N	\N	Bolivia	supplier
169	_591_3__332_9435____591__721_48330	$2b$12$x3nj0kMQSzS3Xsh0Gzuq9uPDGOvfdsELd715aAX1W6./H0eabbQPC	_591_3__332_9435____591__721_48330@example.com	\N	\N	user	t	2025-06-01 21:43:39.129319	\N	\N	Bolivia	supplier
170	_591_3__345_1177	$2b$12$VXHTKXeL5jaA26cYO1CD4eBA1RmZ55AbMzyls2yCvKSPCCBgnVAQe	_591_3__345_1177@example.com	\N	\N	user	t	2025-06-01 21:43:39.62297	\N	\N	Bolivia	supplier
171	_591_3__346_2315___346_6050	$2b$12$ye19GUghuw.b1maPleVKxe9XWsIJJS.1omzvAuR4Hcz2/pT/t8kB2	_591_3__346_2315___346_6050@example.com	\N	\N	user	t	2025-06-01 21:43:40.09007	\N	\N	Bolivia	supplier
172	ceratech_s_r_l____________la_paz__av__ballivi_n_n_	$2b$12$gP5fcoqoO14etFo02hHKve4RaxshPNnVLIOzc3T4VXVpEBJxYA/X.	ceratech@hotmail.com	\N	\N	user	t	2025-06-01 21:43:40.560492	\N	\N	Bolivia	supplier
173	__591_2__2284418___2117194	$2b$12$6UCHEdVaR7ghPA7NfYNdk.cOHafFOq/oM4GczOUFXG7nif6qsjtl6	__591_2__2284418___2117194@example.com	\N	\N	user	t	2025-06-01 23:48:05.513666	\N	\N	Bolivia	supplier
174	__591__77790227	$2b$12$XuDnPBwS88xPaZlPhjBtHO09aRSYXhMNbmTPXQ3itb4Oyx/P5PnR2	aluminioactiva@hotmail.com	\N	\N	user	t	2025-06-01 23:48:05.956477	\N	\N	Bolivia	supplier
175	lpz___obrajes_esq__av__hernando_siles_esq__calle_1	$2b$12$08o7esrbjVliBi3kcSAUOuZttbIYT/OiDqW5TzMPMIdd9403Z4K/i	info@barrientosteran.com	\N	\N	user	t	2025-06-01 23:57:20.960123	\N	\N	Bolivia	supplier
162	empresap	$2b$12$9tH7e79Lvg2u6.Ry01qF3.PbcYYK6nclDuQ1rCRzCRQfwEsTOPDY6	diegomaz2024@gmail.com	empresap	one	user	t	2025-06-01 11:42:13.678325	2025-06-03 05:39:09.544	\N	Bolivia	supplier
3	alejandroburgos	$2b$12$ZOV1ygSxinERtAak51AULu0ip46oAnDT7.C0m96nX3EDNWMxLXhTe	grupoeclipsew@gmail.com	alejandro	burgos	user	t	2025-05-31 21:17:27.222191	2025-06-03 06:41:05.883	\N	Bolivia	architect
\.


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.activities_id_seq', 485, true);


--
-- Name: activity_compositions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.activity_compositions_id_seq', 5437, true);


--
-- Name: budget_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.budget_items_id_seq', 66, true);


--
-- Name: budgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.budgets_id_seq', 34, true);


--
-- Name: city_price_factors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.city_price_factors_id_seq', 9, true);


--
-- Name: company_advertisements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.company_advertisements_id_seq', 4, true);


--
-- Name: construction_phases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.construction_phases_id_seq', 14, true);


--
-- Name: consultation_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.consultation_messages_id_seq', 1, false);


--
-- Name: labor_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.labor_categories_id_seq', 12, true);


--
-- Name: material_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.material_categories_id_seq', 58, true);


--
-- Name: material_supplier_prices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.material_supplier_prices_id_seq', 2, true);


--
-- Name: materials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.materials_id_seq', 1794, true);


--
-- Name: price_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.price_settings_id_seq', 1, true);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.projects_id_seq', 43, true);


--
-- Name: supplier_companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.supplier_companies_id_seq', 164, true);


--
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 1, false);


--
-- Name: tools_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.tools_id_seq', 13, true);


--
-- Name: user_material_prices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.user_material_prices_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.users_id_seq', 177, true);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: activity_compositions activity_compositions_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.activity_compositions
    ADD CONSTRAINT activity_compositions_pkey PRIMARY KEY (id);


--
-- Name: budget_items budget_items_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_items_pkey PRIMARY KEY (id);


--
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (id);


--
-- Name: city_price_factors city_price_factors_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.city_price_factors
    ADD CONSTRAINT city_price_factors_pkey PRIMARY KEY (id);


--
-- Name: company_advertisements company_advertisements_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_advertisements
    ADD CONSTRAINT company_advertisements_pkey PRIMARY KEY (id);


--
-- Name: construction_phases construction_phases_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.construction_phases
    ADD CONSTRAINT construction_phases_pkey PRIMARY KEY (id);


--
-- Name: consultation_messages consultation_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.consultation_messages
    ADD CONSTRAINT consultation_messages_pkey PRIMARY KEY (id);


--
-- Name: labor_categories labor_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.labor_categories
    ADD CONSTRAINT labor_categories_pkey PRIMARY KEY (id);


--
-- Name: material_categories material_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.material_categories
    ADD CONSTRAINT material_categories_pkey PRIMARY KEY (id);


--
-- Name: material_supplier_prices material_supplier_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.material_supplier_prices
    ADD CONSTRAINT material_supplier_prices_pkey PRIMARY KEY (id);


--
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: price_settings price_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.price_settings
    ADD CONSTRAINT price_settings_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: supplier_companies supplier_companies_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.supplier_companies
    ADD CONSTRAINT supplier_companies_pkey PRIMARY KEY (id);


--
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- Name: system_settings system_settings_setting_key_unique; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_setting_key_unique UNIQUE (setting_key);


--
-- Name: tools tools_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (id);


--
-- Name: user_material_prices user_material_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.user_material_prices
    ADD CONSTRAINT user_material_prices_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: activities activities_phase_id_construction_phases_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_phase_id_construction_phases_id_fk FOREIGN KEY (phase_id) REFERENCES public.construction_phases(id);


--
-- Name: activity_compositions activity_compositions_activity_id_activities_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.activity_compositions
    ADD CONSTRAINT activity_compositions_activity_id_activities_id_fk FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- Name: activity_compositions activity_compositions_labor_id_labor_categories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.activity_compositions
    ADD CONSTRAINT activity_compositions_labor_id_labor_categories_id_fk FOREIGN KEY (labor_id) REFERENCES public.labor_categories(id);


--
-- Name: activity_compositions activity_compositions_material_id_materials_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.activity_compositions
    ADD CONSTRAINT activity_compositions_material_id_materials_id_fk FOREIGN KEY (material_id) REFERENCES public.materials(id);


--
-- Name: activity_compositions activity_compositions_tool_id_tools_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.activity_compositions
    ADD CONSTRAINT activity_compositions_tool_id_tools_id_fk FOREIGN KEY (tool_id) REFERENCES public.tools(id);


--
-- Name: budget_items budget_items_activity_id_activities_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_items_activity_id_activities_id_fk FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- Name: budget_items budget_items_budget_id_budgets_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_items_budget_id_budgets_id_fk FOREIGN KEY (budget_id) REFERENCES public.budgets(id);


--
-- Name: budget_items budget_items_phase_id_construction_phases_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_items_phase_id_construction_phases_id_fk FOREIGN KEY (phase_id) REFERENCES public.construction_phases(id);


--
-- Name: budgets budgets_project_id_projects_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_project_id_projects_id_fk FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: company_advertisements company_advertisements_supplier_id_supplier_companies_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.company_advertisements
    ADD CONSTRAINT company_advertisements_supplier_id_supplier_companies_id_fk FOREIGN KEY (supplier_id) REFERENCES public.supplier_companies(id);


--
-- Name: consultation_messages consultation_messages_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.consultation_messages
    ADD CONSTRAINT consultation_messages_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: material_supplier_prices material_supplier_prices_material_id_materials_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.material_supplier_prices
    ADD CONSTRAINT material_supplier_prices_material_id_materials_id_fk FOREIGN KEY (material_id) REFERENCES public.materials(id);


--
-- Name: material_supplier_prices material_supplier_prices_supplier_id_supplier_companies_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.material_supplier_prices
    ADD CONSTRAINT material_supplier_prices_supplier_id_supplier_companies_id_fk FOREIGN KEY (supplier_id) REFERENCES public.supplier_companies(id);


--
-- Name: materials materials_category_id_material_categories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_category_id_material_categories_id_fk FOREIGN KEY (category_id) REFERENCES public.material_categories(id);


--
-- Name: projects projects_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: supplier_companies supplier_companies_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.supplier_companies
    ADD CONSTRAINT supplier_companies_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_material_prices user_material_prices_material_id_materials_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.user_material_prices
    ADD CONSTRAINT user_material_prices_material_id_materials_id_fk FOREIGN KEY (material_id) REFERENCES public.materials(id);


--
-- Name: user_material_prices user_material_prices_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.user_material_prices
    ADD CONSTRAINT user_material_prices_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON TABLES TO neon_superuser WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--

