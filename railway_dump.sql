--
-- PostgreSQL database dump
--

\restrict KCXZdtJgnDBsLPU5sTBTJZOAgrY8iyDflWLau5AwuCcNIWj9FFPdFo5Fc2hGoAd

-- Dumped from database version 18.4 (Debian 18.4-1.pgdg13+1)
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.items (
    id integer NOT NULL,
    item_type text NOT NULL,
    code text,
    name text NOT NULL,
    formula text,
    cas text,
    manufacturer text,
    catalog_number text,
    inventory_number text,
    serial_number text,
    registry_number text,
    quantity numeric,
    unit text,
    status text DEFAULT 'active'::text,
    notes text,
    location_id integer,
    source_file text,
    source_sheet text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    search_vector tsvector,
    internal_code text,
    name_ru text,
    name_en text,
    document_url text,
    gdrive_link text,
    CONSTRAINT items_item_type_check CHECK ((item_type = ANY (ARRAY['chemical'::text, 'equipment'::text, 'furniture'::text, 'reagent'::text, 'consumable'::text, 'other'::text])))
);


--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- Name: items_import_raw; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.items_import_raw (
    source text,
    sheet text,
    item_type text,
    internal_code text,
    name text,
    name_ru text,
    name_en text,
    formula text,
    cas text,
    manufacturer text,
    catalog_number text,
    inventory_number text,
    quantity text,
    unit text,
    status text,
    notes text,
    room text,
    cabinet text,
    shelf text,
    slot text
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    room text,
    cabinet text,
    shelf text,
    slot text
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: protocols; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protocols (
    id integer NOT NULL,
    code text,
    name text NOT NULL,
    category text DEFAULT 'other'::text NOT NULL,
    steps text,
    notes text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: protocols_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.protocols_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protocols_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.protocols_id_seq OWNED BY public.protocols.id;


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: protocols id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protocols ALTER COLUMN id SET DEFAULT nextval('public.protocols_id_seq'::regclass);


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.items (id, item_type, code, name, formula, cas, manufacturer, catalog_number, inventory_number, serial_number, registry_number, quantity, unit, status, notes, location_id, source_file, source_sheet, created_at, updated_at, search_vector, internal_code, name_ru, name_en, document_url, gdrive_link) FROM stdin;
1	reagent	\N	Натрия хлорид / Sodium chloride	NaCl	7647-14-5	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.1	Натрия хлорид	Sodium chloride	\N	\N
2	reagent	\N	Натрия хлорид (1 кг) / Sodium chloride 1 kg	NaCl	7647-14-5	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.2	Натрия хлорид (1 кг)	Sodium chloride 1 kg	\N	\N
3	reagent	\N	Натрия хлорид (1 кг) / Sodium chloride 1 kg	NaCl	7647-14-5	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.3	Натрия хлорид (1 кг)	Sodium chloride 1 kg	\N	\N
4	reagent	\N	Натрия карбонат моногидрат / Sodium carbonate monohydrate	Na2CO3·H2O	5968-11-2	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.4	Натрия карбонат моногидрат	Sodium carbonate monohydrate	\N	\N
5	reagent	\N	Натрия борогидрид / Sodium borohydride	NaBH4	16940-66-2	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.5	Натрия борогидрид	Sodium borohydride	\N	\N
6	reagent	\N	Натрия бета-глицерофосфат / Natrium-beta-glycerolphosphat	C3H7Na2O6P	154804-51-0	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.6	Натрия бета-глицерофосфат	Natrium-beta-glycerolphosphat	\N	\N
7	reagent	\N	Натрий-карбоксиметилцеллюлоза / Sodium carboxymethyl cellulose	\N	9004-32-4	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.7	Натрий-карбоксиметилцеллюлоза	Sodium carboxymethyl cellulose	\N	\N
8	reagent	\N	Натрия карбонат / Sodium carbonate	Na2CO3	497-19-8	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.8	Натрия карбонат	Sodium carbonate	\N	\N
9	reagent	\N	Кальция хлорид дигидрат / Calcium chloride dihydrate	CaCl2·2H2O	10035-04-8	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.9	Кальция хлорид дигидрат	Calcium chloride dihydrate	\N	\N
10	reagent	\N	Кальция хлорид дигидрат / Calcium chloride dihydrate	CaCl2·2H2O	10035-04-8	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.10	Кальция хлорид дигидрат	Calcium chloride dihydrate	\N	\N
11	reagent	\N	Калия хлорид для аналитики / Potassium chloride, for analysis	KCl	7447-40-7	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.11	Калия хлорид для аналитики	Potassium chloride, for analysis	\N	\N
12	reagent	\N	Барий хлористый 2-водный (ХЧ) / Barium chloride dihydrate	BaCl2·2H2O	10326-27-9	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.12	Барий хлористый 2-водный (ХЧ)	Barium chloride dihydrate (ХЧ)	\N	\N
13	reagent	\N	Барий хлористый 2-водный (ХЧ) / Barium chloride dihydrate	BaCl2·2H2O	10326-27-9	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.13	Барий хлористый 2-водный (ХЧ)	Barium chloride dihydrate (ХЧ)	\N	\N
14	reagent	\N	Барий хлористый 2-водный (чда) / Barium chloride dihydrate	BaCl2·2H2O	10326-27-9	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.14	Барий хлористый 2-водный (чда)	Barium chloride dihydrate (чда)	\N	\N
15	reagent	\N	Казеин натриевая соль / Casein sodium salt from bovine milk	\N	9005-46-3	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.15	Казеин натриевая соль (из коровьего молока)	Casein sodium salt from bovine milk	\N	\N
16	reagent	\N	Альгинат натрия / Alginic acid sodium salt	\N	9005-38-3	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.16	Альгинат натрия	Alginic acid sodium salt	\N	\N
17	reagent	\N	ЭДТА (BioChemica) / EDTA (BioChemica)	C10H16N2O8	60-00-4	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.17	ЭДТА (BioChemica)	EDTA (BioChemica)	\N	\N
18	reagent	\N	ЭДТА безводный / EDTA anhydrous	C10H16N2O8	60-00-4	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.18	ЭДТА безводный	EDTA anhydrous	\N	\N
19	reagent	\N	Этилендиаминтетрауксусная кислота / Ethylenediaminetetraacetic acid	C10H16N2O8	60-00-4	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.19	Этилендиаминтетрауксусная кислота	Ethylenediaminetetraacetic acid	\N	\N
20	reagent	\N	Триполифосфат натрия 96% / Sodium tripolyphosphate 96%	Na5P3O10	7758-29-4	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.20	Триполифосфат натрия 96%	Sodium tripolyphosphate 96%	\N	\N
21	reagent	\N	Танин (дубильная кислота) / Tannic acid	C76H52O46	1401-55-4	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.21	Танин (дубильная кислота)	Tannic acid	\N	\N
22	reagent	\N	L-Аскорбиновая кислота / L-Ascorbic acid	C6H8O6	50-81-7	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.22	L-Аскорбиновая кислота	L-Ascorbic acid	\N	\N
23	reagent	\N	Хитозан / Chitosan	\N	9012-76-4	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.23	Хитозан	Chitosan	\N	\N
24	reagent	\N	Полистиролсульфонат натрия / Poly(sodium 4-styrenesulfonate)	(C8H7NaO3S)n	25704-18-1	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.24	Полистиролсульфонат натрия	Poly(sodium 4-styrenesulfonate)	\N	\N
25	reagent	\N	Полистиролсульфонат натрия / Poly(sodium 4-styrenesulfonate)	(C8H7NaO3S)n	25704-18-1	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.25	Полистиролсульфонат натрия	Poly(sodium 4-styrenesulfonate)	\N	\N
26	reagent	\N	Винная кислота / Tartaric acid	C4H6O6	87-69-4	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.26	Винная кислота	Tartaric acid	\N	\N
27	reagent	\N	КМ-Декстран натриевая соль (2 шт) / CM-Dextran sodium salt	\N	9042-14-2	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.27	КМ-Декстран натриевая соль (2 шт)	CM-Dextran sodium salt (2 pcs)	\N	\N
28	reagent	\N	ПСС / PSS (Poly(sodium 4-styrenesulfonate))	(C8H7NaO3S)n	25704-18-1	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.28	ПСС (полистиролсульфонат натрия)	PSS (Poly(sodium 4-styrenesulfonate))	\N	\N
29	reagent	\N	ПСС + 4.4г NaCl / PSS + 4.4g NaCl	(C8H7NaO3S)n	25704-18-1	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.29	ПСС + 4.4г NaCl	PSS + 4.4g NaCl	\N	\N
30	reagent	\N	ПСС / PSS (Poly(sodium 4-styrenesulfonate))	(C8H7NaO3S)n	25704-18-1	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.30	ПСС (полистиролсульфонат натрия)	PSS (Poly(sodium 4-styrenesulfonate))	\N	\N
31	reagent	\N	Полистиролсульфонат натрия / Poly(sodium 4-styrenesulfonate)	(C8H7NaO3S)n	25704-18-1	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.31	Полистиролсульфонат натрия	Poly(sodium 4-styrenesulfonate)	\N	\N
32	reagent	\N	Полиаллиламин гидрохлорид 17500 / Poly(allylamine hydrochloride)	(C3H8ClN)n	71550-12-4	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.32	Полиаллиламин гидрохлорид 17500	Poly(allylamine hydrochloride) 17500	\N	\N
33	reagent	\N	Полиаллиламин гидрохлорид 50000 / Poly(allylamine hydrochloride)	(C3H8ClN)n	71550-12-4	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.33	Полиаллиламин гидрохлорид 50000	Poly(allylamine hydrochloride) 50000	\N	\N
125	reagent	\N	Glutaraldehude solution	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.1	\N	\N	\N	\N
34	reagent	\N	Полиаллиламин гидрохлорид 17500 / Poly(allylamine hydrochloride)	(C3H8ClN)n	71550-12-4	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.34	Полиаллиламин гидрохлорид 17500	Poly(allylamine hydrochloride) 17500	\N	\N
35	reagent	\N	Полиаллиламин гидрохлорид 58000 / Poly(allylamine hydrochloride)	(C3H8ClN)n	71550-12-4	\N	\N	\N	\N	\N	\N	\N	active	\N	1	\N	\N	2026-07-05 22:31:49.718658+00	2026-07-05 22:31:49.718658+00	\N	1.35	Полиаллиламин гидрохлорид 58000	Poly(allylamine hydrochloride) 58000	\N	\N
126	reagent	\N	Poly(allylamine hydrochloride)	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.2	\N	\N	\N	\N
127	reagent	\N	(3-Aminopropyl)triethoxysilane	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.3	\N	\N	\N	\N
128	reagent	\N	Titanium (IV) butoxide	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.4	\N	\N	\N	\N
129	reagent	\N	Натрий гидроокись	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.5	\N	\N	\N	\N
130	reagent	\N	Sodium dodecyl sulfate	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.6	\N	\N	\N	\N
131	reagent	\N	Isooctyl acrylate	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.7	\N	\N	\N	\N
132	reagent	\N	Тритон Х-100	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.8	\N	\N	\N	\N
133	reagent	\N	Тритон Х-114	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.9	\N	\N	\N	\N
134	reagent	\N	Trizma hydrochloride LS	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.10	\N	\N	\N	\N
135	reagent	\N	Chitin from shrimp shells	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.11	\N	\N	\N	\N
136	reagent	\N	Магния хлорид 6-водный	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.12	\N	\N	\N	\N
137	reagent	\N	Tannic acid	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.13	\N	\N	\N	\N
138	reagent	\N	Hydroxylamine solution	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.14	\N	\N	\N	\N
139	reagent	\N	Nonidet P40	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.15	\N	\N	\N	\N
140	reagent	\N	Citric acid anhydrous (USP, BP, Ph. Eur., JP)	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.16	\N	\N	\N	\N
141	reagent	\N	Potassium Chloride pure	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.17	\N	\N	\N	\N
142	reagent	\N	Ammonium Acetate pure	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.18	\N	\N	\N	\N
143	reagent	\N	Potassium Hydroxide - Pellets	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.19	\N	\N	\N	\N
144	reagent	\N	Ammonium Sulfate	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	8	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	1.20	\N	\N	\N	\N
145	reagent	\N	TRIS buffer 1.0M pH 7.5	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.1	\N	\N	\N	\N
146	reagent	\N	Agarose Type IV EEO 0.23-0.26	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.2	\N	\N	\N	\N
147	reagent	\N	PIPES for buffer solution	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.3	\N	\N	\N	\N
148	reagent	\N	Агароза 100г	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.4	\N	\N	\N	\N
149	reagent	\N	Agarose RA 100g	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.5	\N	\N	\N	\N
150	reagent	\N	Sodium chloride 1kg	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.6	\N	\N	\N	\N
151	reagent	\N	Sodium chloride 500g	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.7	\N	\N	\N	\N
152	reagent	\N	Инозин	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.8	\N	\N	\N	\N
153	reagent	\N	Ксантин	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.9	\N	\N	\N	\N
154	reagent	\N	Resazurin sodium salt	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.10	\N	\N	\N	\N
155	reagent	\N	Трипановый синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.11	\N	\N	\N	\N
156	reagent	\N	Agarose standard LS	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.12	\N	\N	\N	\N
157	reagent	\N	Agarose low EEO	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.13	\N	\N	\N	\N
158	reagent	\N	Agar select	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.14	\N	\N	\N	\N
159	reagent	\N	Среда Луриа-Бертани порошок по Миллеру	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.15	\N	\N	\N	\N
160	reagent	\N	Chloramphenicol	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.16	\N	\N	\N	\N
161	reagent	\N	Streptomycin Sulfate	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.17	\N	\N	\N	\N
162	reagent	\N	TRIS Base	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.18	\N	\N	\N	\N
163	reagent	\N	Среда SOB	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.19	\N	\N	\N	\N
164	reagent	\N	Penicillin G Potassium Salt	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.20	\N	\N	\N	\N
165	reagent	\N	Gentamycin Sulfate	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.21	\N	\N	\N	\N
166	reagent	\N	Ethidium Bromide	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.22	\N	\N	\N	\N
167	reagent	\N	MES Free Acid Monohydrate	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.23	\N	\N	\N	\N
168	reagent	\N	MES hydrate	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.24	\N	\N	\N	\N
169	reagent	\N	N-Lauroylsarcosine Sodium Salt pure	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.25	\N	\N	\N	\N
170	reagent	\N	Tetracycline hydrochloride	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.26	\N	\N	\N	\N
171	reagent	\N	Ampicillin Sodium Salt	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.27	\N	\N	\N	\N
172	reagent	\N	N-[Tris(Hydroxymethyl)Methyl]2-Aminoethanesulfonic Acid	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.28	\N	\N	\N	\N
173	reagent	\N	HEPES	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.29	\N	\N	\N	\N
174	reagent	\N	HEPES for cell culture	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.30	\N	\N	\N	\N
175	reagent	\N	MOPS for buffer solution	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.31	\N	\N	\N	\N
176	reagent	\N	TAPS Free Acid	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.32	\N	\N	\N	\N
177	reagent	\N	TES	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.33	\N	\N	\N	\N
178	reagent	\N	Boric Acid for buffer solutions	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.34	\N	\N	\N	\N
179	reagent	\N	Terrific Broth II	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.35	\N	\N	\N	\N
180	reagent	\N	LB BROTH	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.36	\N	\N	\N	\N
181	reagent	\N	Магний сернокислый 7-водный для культивирования клеток	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.37	\N	\N	\N	\N
182	reagent	\N	Аммоний сернокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.38	\N	\N	\N	\N
183	reagent	\N	Марганца(II) хлорид 4-водный для аналитики	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.39	\N	\N	\N	\N
184	reagent	\N	Chloramphenicol	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.40	\N	\N	\N	\N
185	reagent	\N	ТРИС TRIS (Trometamol) (HOPAX High Purity) 1 кг	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	9	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	2.41	\N	\N	\N	\N
186	reagent	\N	Calcium Chloride dried powdered	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.1	\N	\N	\N	\N
187	reagent	\N	Calcium Chloride dihydrate	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.2	\N	\N	\N	\N
188	reagent	\N	Magnesium chloride 6-hydrate	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.3	\N	\N	\N	\N
189	reagent	\N	Sodium carbonate 2.5 kg	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.4	\N	\N	\N	\N
190	reagent	\N	Poly(sodium 4-styrenesulfonate)	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.5	\N	\N	\N	\N
191	reagent	\N	Sodium carbonate (5 kg)	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.6	\N	\N	\N	\N
192	reagent	\N	Iron(II) chloride tetrahydrate	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.7	\N	\N	\N	\N
193	reagent	\N	Mueller-Hinton, Agar	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.8	\N	\N	\N	\N
194	reagent	\N	Giolitti-Cantoni	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.9	\N	\N	\N	\N
195	reagent	\N	Listeria PALCAM Agar base	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.10	\N	\N	\N	\N
196	reagent	\N	Iron(III) chloride hexahydrate	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.11	\N	\N	\N	\N
197	reagent	\N	Dextran 70	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.12	\N	\N	\N	\N
198	reagent	\N	Sodium Pyruvate for analysis	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.13	\N	\N	\N	\N
199	reagent	\N	Lithium chloride pure	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.14	\N	\N	\N	\N
200	reagent	\N	D(+)-Glucose anhydrous for cell culture	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.15	\N	\N	\N	\N
201	reagent	\N	di-Sodium Hydrogen Phosphate anhydrous	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.16	\N	\N	\N	\N
202	reagent	\N	Imidazole for buffer solution	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.17	\N	\N	\N	\N
203	reagent	\N	Gadolinium(III) chloride	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.18	\N	\N	\N	\N
204	reagent	\N	Глицерин	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.19	\N	\N	\N	\N
205	reagent	\N	N,N-Метилен-бисакриламид	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.20	\N	\N	\N	\N
206	reagent	\N	Sodium Hydroxide pellets	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.21	\N	\N	\N	\N
207	reagent	\N	Sodium dodecyl sulfate (SDS)	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.22	\N	\N	\N	\N
208	reagent	\N	6-Aminocaproic acid	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	10	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	3.23	\N	\N	\N	\N
209	reagent	\N	PIPES Sesquisodium Salt Buffer extrapure, 99%	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	11	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	X	\N	\N	\N	\N
210	reagent	\N	1-(3-Dimethylaminopropyl)-3-ethylcarbodiimide Hydrochloride	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	11	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	X.1	\N	\N	\N	\N
211	reagent	\N	3,3-Dithiobis(sulfosuccinimidylpropionate) DTSSP, 50 mg	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	11	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	X.2	\N	\N	\N	\N
212	reagent	\N	Terephthalic Acid 500 g	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	12	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	4.12	\N	\N	\N	\N
213	reagent	\N	1,3,5-Benzenetricarboxylic Acid 500 g	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	\N	12	Reviziia-Laby-IBSiB-3-2	\N	2026-07-05 23:17:44.883598+00	2026-07-05 23:17:44.883598+00	\N	4.13	\N	\N	\N	\N
\.


--
-- Data for Name: items_import_raw; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.items_import_raw (source, sheet, item_type, internal_code, name, name_ru, name_en, formula, cas, manufacturer, catalog_number, inventory_number, quantity, unit, status, notes, room, cabinet, shelf, slot) FROM stdin;
lab1_2	Оборудование	equipment	\N	434032016000033.0	\N	\N	\N	\N	\N	\N	434032016000033.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434052016000004.0	\N	\N	\N	\N	\N	\N	434052016000004.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	234022021000536.0	\N	\N	\N	\N	\N	\N	234022021000536.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434032016000020.0	\N	\N	\N	\N	\N	\N	434032016000020.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000038.0	\N	\N	\N	\N	\N	\N	434042015000038.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000023.0	\N	\N	\N	\N	\N	\N	434042015000023.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000051.0	\N	\N	\N	\N	\N	\N	434042015000051.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000031.0	\N	\N	\N	\N	\N	\N	434042015000031.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000022.0	\N	\N	\N	\N	\N	\N	434042015000022.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000032.0	\N	\N	\N	\N	\N	\N	434042015000032.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	234012020000128.0	\N	\N	\N	\N	\N	\N	234012020000128.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000204.0	\N	\N	\N	\N	\N	\N	434002016000204.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000203.0	\N	\N	\N	\N	\N	\N	434002016000203.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000206.0	\N	\N	\N	\N	\N	\N	434002016000206.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000205.0	\N	\N	\N	\N	\N	\N	434002016000205.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000208.0	\N	\N	\N	\N	\N	\N	434002016000208.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000207.0	\N	\N	\N	\N	\N	\N	434002016000207.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000209.0	\N	\N	\N	\N	\N	\N	434002016000209.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000210.0	\N	\N	\N	\N	\N	\N	434002016000210.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	224022015000001.0	\N	\N	\N	\N	\N	\N	224022015000001.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000212.0	\N	\N	\N	\N	\N	\N	434002016000212.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000213.0	\N	\N	\N	\N	\N	\N	434002016000213.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000218.0	\N	\N	\N	\N	\N	\N	434002016000218.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000215.0	\N	\N	\N	\N	\N	\N	434002016000215.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000217.0	\N	\N	\N	\N	\N	\N	434002016000217.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000216.0	\N	\N	\N	\N	\N	\N	434002016000216.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000220.0	\N	\N	\N	\N	\N	\N	434002016000220.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000221.0	\N	\N	\N	\N	\N	\N	434002016000221.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000222.0	\N	\N	\N	\N	\N	\N	434002016000222.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000219.0	\N	\N	\N	\N	\N	\N	434002016000219.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000020.0	\N	\N	\N	\N	\N	\N	434042015000020.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000021.0	\N	\N	\N	\N	\N	\N	434042015000021.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000036.0	\N	\N	\N	\N	\N	\N	434042015000036.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000035.0	\N	\N	\N	\N	\N	\N	434042015000035.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000046.0	\N	\N	\N	\N	\N	\N	434042015000046.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000044.0	\N	\N	\N	\N	\N	\N	434042015000044.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000045.0	\N	\N	\N	\N	\N	\N	434042015000045.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000040.0	\N	\N	\N	\N	\N	\N	434042015000040.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000041.0	\N	\N	\N	\N	\N	\N	434042015000041.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000042.0	\N	\N	\N	\N	\N	\N	434042015000042.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000043.0	\N	\N	\N	\N	\N	\N	434042015000043.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000024.0	\N	\N	\N	\N	\N	\N	434042015000024.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000050.0	\N	\N	\N	\N	\N	\N	434042015000050.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434022016000165.0	\N	\N	\N	\N	\N	\N	434022016000165.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	234002016000647.0	\N	\N	\N	\N	\N	\N	234002016000647.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434002016000410.0	\N	\N	\N	\N	\N	\N	434002016000410.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000049.0	\N	\N	\N	\N	\N	\N	434042015000049.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	424042015000009.0	\N	\N	\N	\N	\N	\N	424042015000009.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434052016000005.0	\N	\N	\N	\N	\N	\N	434052016000005.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042018000052.0	\N	\N	\N	\N	\N	\N	434042018000052.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042018000053.0	\N	\N	\N	\N	\N	\N	434042018000053.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434052016000006.0	\N	\N	\N	\N	\N	\N	434052016000006.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000017.0	\N	\N	\N	\N	\N	\N	434042015000017.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042018000054.0	\N	\N	\N	\N	\N	\N	434042018000054.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434032018000121.0	\N	\N	\N	\N	\N	\N	434032018000121.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	424042015000003.0	\N	\N	\N	\N	\N	\N	424042015000003.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434052016000008.0	\N	\N	\N	\N	\N	\N	434052016000008.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434022017000409.0	\N	\N	\N	\N	\N	\N	434022017000409.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434022017000411.0	\N	\N	\N	\N	\N	\N	434022017000411.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434022017000410.0	\N	\N	\N	\N	\N	\N	434022017000410.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434022017000412.0	\N	\N	\N	\N	\N	\N	434022017000412.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434052017000016.0	\N	\N	\N	\N	\N	\N	434052017000016.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434032015000017.0	\N	\N	\N	\N	\N	\N	434032015000017.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434052016000009.0	\N	\N	\N	\N	\N	\N	434052016000009.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000039.0	\N	\N	\N	\N	\N	\N	434042015000039.0	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	SDS	SDS	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000037.0	\N	\N	\N	\N	\N	\N	434042015000037.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	234002016000646.0	\N	\N	\N	\N	\N	\N	234002016000646.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434052016000011.0	\N	\N	\N	\N	\N	\N	434052016000011.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000030.0	\N	\N	\N	\N	\N	\N	434042015000030.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	424032017000008.0	\N	\N	\N	\N	\N	\N	424032017000008.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	424042015000002.0	\N	\N	\N	\N	\N	\N	424042015000002.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000018.0	\N	\N	\N	\N	\N	\N	434042015000018.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042018000035.0	\N	\N	\N	\N	\N	\N	434042018000035.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000026.0	\N	\N	\N	\N	\N	\N	434042015000026.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000027.0	\N	\N	\N	\N	\N	\N	434042015000027.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000033.0	\N	\N	\N	\N	\N	\N	434042015000033.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434032016000021.0	\N	\N	\N	\N	\N	\N	434032016000021.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042016000033.0	\N	\N	\N	\N	\N	\N	434042016000033.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434022015000370.0	\N	\N	\N	\N	\N	\N	434022015000370.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042018000051.0	\N	\N	\N	\N	\N	\N	434042018000051.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434032018000117.0	\N	\N	\N	\N	\N	\N	434032018000117.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	234022020000417.0	\N	\N	\N	\N	\N	\N	234022020000417.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000034.0	\N	\N	\N	\N	\N	\N	434042015000034.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	234022020000654.0	\N	\N	\N	\N	\N	\N	234022020000654.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042016000016.0	\N	\N	\N	\N	\N	\N	434042016000016.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000025.0	\N	\N	\N	\N	\N	\N	434042015000025.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434032019000084.0	\N	\N	\N	\N	\N	\N	434032019000084.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434052016000012.0	\N	\N	\N	\N	\N	\N	434052016000012.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434052016000013.0	\N	\N	\N	\N	\N	\N	434052016000013.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434052016000014.0	\N	\N	\N	\N	\N	\N	434052016000014.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042016000034.0	\N	\N	\N	\N	\N	\N	434042016000034.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000028.0	\N	\N	\N	\N	\N	\N	434042015000028.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000029.0	\N	\N	\N	\N	\N	\N	434042015000029.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000047.0	\N	\N	\N	\N	\N	\N	434042015000047.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000048.0	\N	\N	\N	\N	\N	\N	434042015000048.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	434042015000019.0	\N	\N	\N	\N	\N	\N	434042015000019.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Оборудование	equipment	\N	234032020000336.0	\N	\N	\N	\N	\N	\N	234032020000336.0	1.0	\N	\N	\N	\N	\N	\N	\N
lab1_2	Реактивы -20 (310)	other	\N	Calcein AM	Calcein AM	\N	\N	\N	\N	\N	\N	написать титровку (молярность-кол-во эппендорфов)	\N	\N	\N	\N	\N	\N	\N
lab1_2	Реактивы -20 (310)	other	\N	Phalloidin-Atto 488	Phalloidin-Atto 488	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
lab1_2	Реактивы -20 (310)	other	\N	Poly-L-arginine hydrochloride wt >70 000	Poly-L-arginine hydrochloride wt >70 000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434022017000841.0	\N	\N	\N	\N	\N	\N	434022017000841.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434022017000842.0	\N	\N	\N	\N	\N	\N	434022017000842.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434022015000176.0	\N	\N	\N	\N	\N	\N	434022015000176.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	234002016000647.0	\N	\N	\N	\N	\N	\N	234002016000647.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434002016000410.0	\N	\N	\N	\N	\N	\N	434002016000410.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	424032016000001.0	\N	\N	\N	\N	\N	\N	424032016000001.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434022016000107.0	\N	\N	\N	\N	\N	\N	434022016000107.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434022016000110.0	\N	\N	\N	\N	\N	\N	434022016000110.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434022016000109.0	\N	\N	\N	\N	\N	\N	434022016000109.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434022016000111.0	\N	\N	\N	\N	\N	\N	434022016000111.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434022016000108.0	\N	\N	\N	\N	\N	\N	434022016000108.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434002016000062.0	\N	\N	\N	\N	\N	\N	434002016000062.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434002016000060.0	\N	\N	\N	\N	\N	\N	434002016000060.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434002016000061.0	\N	\N	\N	\N	\N	\N	434002016000061.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434002016000063.0	\N	\N	\N	\N	\N	\N	434002016000063.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	236062022000749.0	\N	\N	\N	\N	\N	\N	236062022000749.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	534002016000006.0	\N	\N	\N	\N	\N	\N	534002016000006.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	534002016000002.0	\N	\N	\N	\N	\N	\N	534002016000002.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	534002016000008.0	\N	\N	\N	\N	\N	\N	534002016000008.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434052016000010.0	\N	\N	\N	\N	\N	\N	434052016000010.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434022017000838.0	\N	\N	\N	\N	\N	\N	434022017000838.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434022017000839.0	\N	\N	\N	\N	\N	\N	434022017000839.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434022017000840.0	\N	\N	\N	\N	\N	\N	434022017000840.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	534002016000007.0	\N	\N	\N	\N	\N	\N	534002016000007.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434022016000112.0	\N	\N	\N	\N	\N	\N	434022016000112.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	236042020000036.0	\N	\N	\N	\N	\N	\N	236042020000036.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000320.0	\N	\N	\N	\N	\N	\N	436002016000320.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000350.0	\N	\N	\N	\N	\N	\N	436002016000350.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000347.0	\N	\N	\N	\N	\N	\N	436002016000347.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000348.0	\N	\N	\N	\N	\N	\N	436002016000348.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000346.0	\N	\N	\N	\N	\N	\N	436002016000346.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000247.0	\N	\N	\N	\N	\N	\N	436002016000247.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000249.0	\N	\N	\N	\N	\N	\N	436002016000249.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000248.0	\N	\N	\N	\N	\N	\N	436002016000248.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	534002016000005.0	\N	\N	\N	\N	\N	\N	534002016000005.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434022016000113.0	\N	\N	\N	\N	\N	\N	434022016000113.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	534002016000003.0	\N	\N	\N	\N	\N	\N	534002016000003.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	534002016000004.0	\N	\N	\N	\N	\N	\N	534002016000004.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	234002016000646.0	\N	\N	\N	\N	\N	\N	234002016000646.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434052016000011.0	\N	\N	\N	\N	\N	\N	434052016000011.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434042015000030.0	\N	\N	\N	\N	\N	\N	434042015000030.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	424032017000008.0	\N	\N	\N	\N	\N	\N	424032017000008.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	424042015000002.0	\N	\N	\N	\N	\N	\N	424042015000002.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	424022016000004.0	\N	\N	\N	\N	\N	\N	424022016000004.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434042015000018.0	\N	\N	\N	\N	\N	\N	434042015000018.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000252.0	\N	\N	\N	\N	\N	\N	436002016000252.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434002016000409.0	\N	\N	\N	\N	\N	\N	434002016000409.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000339.0	\N	\N	\N	\N	\N	\N	436002016000339.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000340.0	\N	\N	\N	\N	\N	\N	436002016000340.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000341.0	\N	\N	\N	\N	\N	\N	436002016000341.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000327.0	\N	\N	\N	\N	\N	\N	436002016000327.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000326.0	\N	\N	\N	\N	\N	\N	436002016000326.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000357.0	\N	\N	\N	\N	\N	\N	436002016000357.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000356.0	\N	\N	\N	\N	\N	\N	436002016000356.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000358.0	\N	\N	\N	\N	\N	\N	436002016000358.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000325.0	\N	\N	\N	\N	\N	\N	436002016000325.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000246.0	\N	\N	\N	\N	\N	\N	436002016000246.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000354.0	\N	\N	\N	\N	\N	\N	436002016000354.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000355.0	\N	\N	\N	\N	\N	\N	436002016000355.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000353.0	\N	\N	\N	\N	\N	\N	436002016000353.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042016000255.0	\N	\N	\N	\N	\N	\N	436042016000255.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000307.0	\N	\N	\N	\N	\N	\N	436002016000307.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000309.0	\N	\N	\N	\N	\N	\N	436002016000309.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000308.0	\N	\N	\N	\N	\N	\N	436002016000308.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000311.0	\N	\N	\N	\N	\N	\N	436002016000311.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000312.0	\N	\N	\N	\N	\N	\N	436002016000312.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000313.0	\N	\N	\N	\N	\N	\N	436002016000313.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000314.0	\N	\N	\N	\N	\N	\N	436002016000314.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000360.0	\N	\N	\N	\N	\N	\N	436002016000360.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000359.0	\N	\N	\N	\N	\N	\N	436002016000359.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000310.0	\N	\N	\N	\N	\N	\N	436002016000310.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000337.0	\N	\N	\N	\N	\N	\N	436002016000337.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000338.0	\N	\N	\N	\N	\N	\N	436002016000338.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000383.0	\N	\N	\N	\N	\N	\N	436042015000383.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000384.0	\N	\N	\N	\N	\N	\N	436042015000384.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000382.0	\N	\N	\N	\N	\N	\N	436042015000382.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000349.0	\N	\N	\N	\N	\N	\N	436002016000349.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000343.0	\N	\N	\N	\N	\N	\N	436002016000343.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000344.0	\N	\N	\N	\N	\N	\N	436002016000344.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000345.0	\N	\N	\N	\N	\N	\N	436002016000345.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000336.0	\N	\N	\N	\N	\N	\N	436002016000336.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000335.0	\N	\N	\N	\N	\N	\N	436002016000335.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000385.0	\N	\N	\N	\N	\N	\N	436042015000385.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000386.0	\N	\N	\N	\N	\N	\N	436042015000386.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000387.0	\N	\N	\N	\N	\N	\N	436042015000387.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000317.0	\N	\N	\N	\N	\N	\N	436002016000317.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000250.0	\N	\N	\N	\N	\N	\N	436002016000250.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000342.0	\N	\N	\N	\N	\N	\N	436002016000342.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000378.0	\N	\N	\N	\N	\N	\N	436042015000378.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000328.0	\N	\N	\N	\N	\N	\N	436002016000328.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000352.0	\N	\N	\N	\N	\N	\N	436002016000352.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000351.0	\N	\N	\N	\N	\N	\N	436002016000351.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000370.0	\N	\N	\N	\N	\N	\N	436042015000370.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000371.0	\N	\N	\N	\N	\N	\N	436042015000371.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000372.0	\N	\N	\N	\N	\N	\N	436042015000372.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000373.0	\N	\N	\N	\N	\N	\N	436042015000373.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000251.0	\N	\N	\N	\N	\N	\N	436002016000251.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000377.0	\N	\N	\N	\N	\N	\N	436042015000377.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000324.0	\N	\N	\N	\N	\N	\N	436002016000324.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000323.0	\N	\N	\N	\N	\N	\N	436002016000323.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000322.0	\N	\N	\N	\N	\N	\N	436002016000322.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000321.0	\N	\N	\N	\N	\N	\N	436002016000321.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000271.0	\N	\N	\N	\N	\N	\N	436002016000271.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000270.0	\N	\N	\N	\N	\N	\N	436002016000270.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000268.0	\N	\N	\N	\N	\N	\N	436002016000268.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000269.0	\N	\N	\N	\N	\N	\N	436002016000269.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000255.0	\N	\N	\N	\N	\N	\N	436002016000255.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000263.0	\N	\N	\N	\N	\N	\N	436002016000263.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000258.0	\N	\N	\N	\N	\N	\N	436002016000258.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000254.0	\N	\N	\N	\N	\N	\N	436002016000254.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000257.0	\N	\N	\N	\N	\N	\N	436002016000257.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000253.0	\N	\N	\N	\N	\N	\N	436002016000253.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000262.0	\N	\N	\N	\N	\N	\N	436002016000262.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000260.0	\N	\N	\N	\N	\N	\N	436002016000260.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000256.0	\N	\N	\N	\N	\N	\N	436002016000256.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000259.0	\N	\N	\N	\N	\N	\N	436002016000259.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000261.0	\N	\N	\N	\N	\N	\N	436002016000261.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000265.0	\N	\N	\N	\N	\N	\N	436002016000265.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000266.0	\N	\N	\N	\N	\N	\N	436002016000266.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000264.0	\N	\N	\N	\N	\N	\N	436002016000264.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000267.0	\N	\N	\N	\N	\N	\N	436002016000267.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000374.0	\N	\N	\N	\N	\N	\N	436042015000374.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000375.0	\N	\N	\N	\N	\N	\N	436042015000375.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000376.0	\N	\N	\N	\N	\N	\N	436042015000376.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434032019000084.0	\N	\N	\N	\N	\N	\N	434032019000084.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436032016000005.0	\N	\N	\N	\N	\N	\N	436032016000005.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436032016000004.0	\N	\N	\N	\N	\N	\N	436032016000004.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434002016000099.0	\N	\N	\N	\N	\N	\N	434002016000099.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	434002016000101.0	\N	\N	\N	\N	\N	\N	434002016000101.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000319.0	\N	\N	\N	\N	\N	\N	436002016000319.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000331.0	\N	\N	\N	\N	\N	\N	436002016000331.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000334.0	\N	\N	\N	\N	\N	\N	436002016000334.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000333.0	\N	\N	\N	\N	\N	\N	436002016000333.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000332.0	\N	\N	\N	\N	\N	\N	436002016000332.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000329.0	\N	\N	\N	\N	\N	\N	436002016000329.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000330.0	\N	\N	\N	\N	\N	\N	436002016000330.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000379.0	\N	\N	\N	\N	\N	\N	436042015000379.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000318.0	\N	\N	\N	\N	\N	\N	436002016000318.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436042015000380.0	\N	\N	\N	\N	\N	\N	436042015000380.0	1	\N	\N	\N	\N	\N	\N	\N
lab1_2	Мебель	equipment	\N	436002016000274.0	\N	\N	\N	\N	\N	\N	436002016000274.0	1	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Пипетки серологические 2 мл	Пипетки серологические 2 мл	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Пипетки серологические 2 мл странные не используем	Пипетки серологические 2 мл странные не используем	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Пипетки серологические 5 мл	Пипетки серологические 5 мл	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Пипетки серологические 5 мл вскрытая	Пипетки серологические 5 мл вскрытая	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Пипетки серологические 5 мл+5 мл не стерильные странные. Большая коробка	Пипетки серологические 5 мл+5 мл не стерильные странные. Большая коробка	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Пипетки серологические 10 мл	Пипетки серологические 10 мл	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Пипетки серологические 25 мл	Пипетки серологические 25 мл	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	24-луночные планшеты нон тритетд	24-луночные планшеты нон тритетд	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	48 луночные адгезионные	48 луночные адгезионные	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	6-луночные планшеты для суспензионных к.к	6-луночные планшеты для суспензионных к.к	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	12-луночные планшеты для суспензионных к.к	12-луночные планшеты для суспензионных к.к	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	24-луночные планшеты для суспензионных к.к	24-луночные планшеты для суспензионных к.к	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	24-луночные стерильные нон тритед (?) коробка стремная	24-луночные стерильные нон тритед (?) коробка стремная	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	48-луночные планшеты для суспензионных к.к	48-луночные планшеты для суспензионных к.к	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	96-луночные планшеты для суспензионных к.к	96-луночные планшеты для суспензионных к.к	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	6-луночные планшеты для адгезионных к.к	6-луночные планшеты для адгезионных к.к	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	12-луночные планшеты для адгезионных к.к	12-луночные планшеты для адгезионных к.к	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	24-луночные планшеты для адгезионных к.к	24-луночные планшеты для адгезионных к.к	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	48-луночные планшеты для адгезионных к.к	48-луночные планшеты для адгезионных к.к	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	96-луночные планшеты для адгезионных к.к	96-луночные планшеты для адгезионных к.к	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Флаконы культуральные для суспензионных к.к. 75см2	Флаконы культуральные для суспензионных к.к. 75см2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Флаконы культуральные для суспензионных к.к 12,5 см2	Флаконы культуральные для суспензионных к.к 12,5 см2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	флаконы культуральные прямое горлышко филтр крышка 175 см2 тритед	флаконы культуральные прямое горлышко филтр крышка 175 см2 тритед	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Флаконы культуральные для адгезионных к.к  12.5 см2	Флаконы культуральные для адгезионных к.к  12.5 см2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Флаконы культуральные для адгезионных к.к  75 см3	Флаконы культуральные для адгезионных к.к  75 см3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Чашки петри для суспензионных к.к. 100х20мм	Чашки петри для суспензионных к.к. 100х20мм	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Чашки петри нон тритед непонятные нестерильные	Чашки петри нон тритед непонятные нестерильные	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Коробка с пластиковыми чашками Петри большие нон тритед 100х12 и средние (не стерильные)	Коробка с пластиковыми чашками Петри большие нон тритед 100х12 и средние (не стерильные)	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Флаконы культуральные для суспензионных к.к. 75 см2	Флаконы культуральные для суспензионных к.к. 75 см2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Пробирки 50 мл	Пробирки 50 мл	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Серологические 5 мл 200 шт	Серологические 5 мл 200 шт	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Пробирки 2 мл 6 по 500 шт	Пробирки 2 мл 6 по 500 шт	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Серологические 2 мл 500 шт	Серологические 2 мл 500 шт	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Серологические 10 мл 200 шт	Серологические 10 мл 200 шт	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Наконечники 1250 с фильтром 20 по 96 шт	Наконечники 1250 с фильтром 20 по 96 шт	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Наконечники 200 мкл без фильтра 10 по 1000	Наконечники 200 мкл без фильтра 10 по 1000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Наконечники 100-300 с фильтром 20 по 96 шт	Наконечники 100-300 с фильтром 20 по 96 шт	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Наконечники 20 мкл с фильтром 20 по 96 шт	Наконечники 20 мкл с фильтром 20 по 96 шт	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Наконечники 1000 мкл с фильтром 10 по 1000 шт	Наконечники 1000 мкл с фильтром 10 по 1000 шт	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Наконечники 10-200 с фильтром 10 по 1000 шт	Наконечники 10-200 с фильтром 10 по 1000 шт	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Наконечники 1000 мкл без фильтр	Наконечники 1000 мкл без фильтр	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Наконечники 0.1-10 мкл 20 по 96 шт	Наконечники 0.1-10 мкл 20 по 96 шт	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Планшет 6 лунок treated 50 шт	Планшет 6 лунок treated 50 шт	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Планшет 96 лунок treated	Планшет 96 лунок treated	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Планшет 96 лунок не стерильный	Планшет 96 лунок не стерильный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Планшет 96 лунок обработанный	Планшет 96 лунок обработанный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Наконечники 100 мкл с фильтром	Наконечники 100 мкл с фильтром	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Пробирки 15 мл	Пробирки 15 мл	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Планшеты 48 лунок treated	Планшеты 48 лунок treated	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Пробирки 5 мл	Пробирки 5 мл	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Флаконы 250 мл обработанные	Флаконы 250 мл обработанные	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Флаконы (маленькие 10 мл)	Флаконы (маленькие 10 мл)	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Флаконы 175 см	Флаконы 175 см	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Планшеты 24 для суспензионных	Планшеты 24 для суспензионных	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Планшеты 24 для адгезионных	Планшеты 24 для адгезионных	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Планшеты 48 необработанные	Планшеты 48 необработанные	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Перчатки нитрил М/L	Перчатки нитрил М/L	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Ванночки	Ванночки	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Планшеты оптические 96 лунок	Планшеты оптические 96 лунок	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Пипетки 3 мл стерильные (7 уп) и 5 мл нестерильный (3уп)	Пипетки 3 мл стерильные (7 уп) и 5 мл нестерильный (3уп)	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Петри 100 не обработанные	Петри 100 не обработанные	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
sklad	Склад 108а	other	\N	Пробирки 200 мкл нестерильные	Пробирки 200 мкл нестерильные	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G10	Sephadex G10	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-01-01 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G15	Sephadex G15	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G25 Coarse	Sephadex G25 Coarse	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G50 Coarse	Sephadex G50 Coarse	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G50 Fine	Sephadex G50 Fine	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G50 Superfine	Sephadex G50 Superfine	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G75	Sephadex G75	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G75 Fine	Sephadex G75 Fine	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G100	Sephadex G100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G100 Superfine	Sephadex G100 Superfine	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G150	Sephadex G150	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G150 Superfine	Sephadex G150 Superfine	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G200	Sephadex G200	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G200 Superfine	Sephadex G200 Superfine	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	CM-Sephadex C25	CM-Sephadex C25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-01-01 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	CM-Sephadex C25 Coarse	CM-Sephadex C25 Coarse	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	CM-Sephadex C50	CM-Sephadex C50	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	QAE-Sephadex A25	QAE-Sephadex A25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	QAE-Sephadex A50	QAE-Sephadex A50	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	SP-Sephadex C25	SP-Sephadex C25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	SP-Sephadex C50	SP-Sephadex C50	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	DEAE-Sephadex A25	DEAE-Sephadex A25	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	DEAE-Sephadex A25 Fine	DEAE-Sephadex A25 Fine	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	DEAE-Sephadex A50 Fine	DEAE-Sephadex A50 Fine	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	SE-Sephadex C50 Coarse	SE-Sephadex C50 Coarse	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	SE-Sephadex C50 Medium	SE-Sephadex C50 Medium	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex LH-20	Sephadex LH-20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephadex G50	Sephadex G50	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Bio-gel P-2	Bio-gel P-2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-01-01 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Bio-gel P-4	Bio-gel P-4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Bio-gel P-6	Bio-gel P-6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Bio-gel P-10	Bio-gel P-10	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Toyopearl	Toyopearl	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Ultragel aka22	Ultragel aka22	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sepharose 4b	Sepharose 4b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sephacril s1000	Sephacril s1000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Acros G10	Acros G10	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Dowex MR3	Dowex MR3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-02-01 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Dowex AG 1x2	Dowex AG 1x2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Dowex AG 1x4	Dowex AG 1x4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Dowex AG 1x8	Dowex AG 1x8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Dowex AG 1x10	Dowex AG 1x10	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Dowex AG 2x10	Dowex AG 2x10	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Dowex AG 50 WX 2	Dowex AG 50 WX 2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Dowex AG 50 WX 4	Dowex AG 50 WX 4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Dowex AG 50 WX 8	Dowex AG 50 WX 8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Dowex AG 50 WX 12	Dowex AG 50 WX 12	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Dowex AG 50 21K	Dowex AG 50 21K	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	AmberLite MB2	AmberLite MB2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-02-01 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	AmberLite MB3	AmberLite MB3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	AmberLite IR120	AmberLite IR120	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	AmberLite IRA67	AmberLite IRA67	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	AmberLite IRA410	AmberLite IRA410	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	AmberLite CG-120	AmberLite CG-120	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Servacell	Servacell	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Servacell MBD	Servacell MBD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Servacell DEAE	Servacell DEAE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Celulose phasphate	Celulose phasphate	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Reahim CM	Reahim CM	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Ostion LG B	Ostion LG B	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Ostion LG AM	Ostion LG AM	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Spheron 100	Spheron 100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Spheron 1000	Spheron 1000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Serdolit MB Serva	Serdolit MB Serva	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Chelite	Chelite	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	KM 52	KM 52	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Cation resin	Cation resin	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Ion resin	Ion resin	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Cation resin	Cation resin	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Anion resin	Anion resin	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	D-Лактоза	D-Лактоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-03-01 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	D-Мальтоза	D-Мальтоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	+ запаска в коробке 1.5	\N
revizia	Реактивы по шкафам	other	\N	D-Маннит	D-Маннит	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	D-Глюкоза	D-Глюкоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	D-Фруктоза	D-Фруктоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	D-Манноза	D-Манноза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	L-Рамноза	L-Рамноза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	L-Арабиноза	L-Арабиноза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Декстрин 10	Декстрин 10	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Декстрин 15	Декстрин 15	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Декстрин Цилио	Декстрин Цилио	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Декстран Т20	Декстран Т20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Декстран Т70	Декстран Т70	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Инозит	Инозит	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Сахароза	Сахароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Лактоза в пакетике	Лактоза в пакетике	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Инулин	Инулин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Глюконо-дельта-лактон	Глюконо-дельта-лактон	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	MALT EXTRACT	MALT EXTRACT	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Целлюлоза	Целлюлоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Хитозан	Хитозан	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Альфа-глюкохлоралоза	Альфа-глюкохлоралоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Амилопектин	Амилопектин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Амилоза	Амилоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Крахмал	Крахмал	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Хитин	Хитин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Мезо-инозит	Мезо-инозит	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Пумулан	Пумулан	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	PHYTIC ACID	PHYTIC ACID	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Ксилит	Ксилит	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бета-циклодекстрин	Бета-циклодекстрин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Альфа-циклодекстрин	Альфа-циклодекстрин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Мальтогексаоза	Мальтогексаоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Мальтогептаоза	Мальтогептаоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Мальтопентаоза	Мальтопентаоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Мальтотетраоза	Мальтотетраоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Мальтотриоза	Мальтотриоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Гентибиоза	Гентибиоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	CuSO4	CuSO4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-04-01 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	NaOH	NaOH	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	CaCl2	CaCl2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	(NH4)2 SO4	(NH4)2 SO4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	KOH	KOH	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	CaJ	CaJ	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Гуанидин Углекислый	Гуанидин Углекислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	NaJO4	NaJO4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	FeSO4	FeSO4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Йодная к-та	Йодная к-та	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Медь II Сернокислая	Медь II Сернокислая	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Магний Сернокислый	Магний Сернокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Железо Сернокислая	Железо Сернокислая	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	DARCO G60	DARCO G60	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Norit A	Norit A	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Нингидрин	Нингидрин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Orcin Моногидрат	Orcin Моногидрат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Олово	Олово	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Сернокислый Церий(IV)	Сернокислый Церий(IV)	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий Сернокислый	Натрий Сернокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Na2SO4	Na2SO4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	NaHCO3	NaHCO3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Кислый виннокислый калий чистый	Кислый виннокислый калий чистый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Виннокислый натрий чистый	Виннокислый натрий чистый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Сода Кальцинированная	Сода Кальцинированная	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Молибдат аммонния	Молибдат аммонния	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Калий натрий виннокислый	Калий натрий виннокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	di-Sodium hydrogen arsenate	di-Sodium hydrogen arsenate	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий виннокислый кислый	Натрий виннокислый кислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Формальдегид	Формальдегид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Диасорб Амин	Диасорб Амин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-05-01 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Фенолфталеин	Фенолфталеин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	+ коробка с модифицированными аминокислотами	\N
revizia	Реактивы по шкафам	other	\N	Понсо	Понсо	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Хромотроповой к-ты динатриевая соль	Хромотроповой к-ты динатриевая соль	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бензокаин	Бензокаин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Анилин	Анилин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Димитиламинобензольная к-та	Димитиламинобензольная к-та	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Серваблу	Серваблу	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Анизилнитротетразолий синий	Анизилнитротетразолий синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Тетразолиевый синий	Тетразолиевый синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	3-фенилтетразоль	3-фенилтетразоль	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Амидо черный	Амидо черный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Оксиль лантана	Оксиль лантана	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Тимол	Тимол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	О-нитрофенол	О-нитрофенол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Кинуренин	Кинуренин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бромкрезоловый синий	Бромкрезоловый синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Чернила	Чернила	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Сибахром бирюзовый	Сибахром бирюзовый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Орто-дианизидин	Орто-дианизидин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Люцигенин	Люцигенин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Сибахром голубой	Сибахром голубой	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Брилиатонтово синий	Брилиатонтово синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Биоред0	Биоред0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Фуксин кислый	Фуксин кислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Рибофлавин	Рибофлавин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Кармин	Кармин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Трикетогидринден	Трикетогидринден	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Триметилбензо-2 тиазолон	Триметилбензо-2 тиазолон	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Метиловый зеленый	Метиловый зеленый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Фуксин основной	Фуксин основной	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	2.2-азинодибензол…	2.2-азинодибензол…	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Телур саура	Телур саура	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Эозин	Эозин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Антрон	Антрон	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Цибакрон бирюзовый	Цибакрон бирюзовый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бромфеноловый синий	Бромфеноловый синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бензол	Бензол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Пропанол	Пропанол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Хлороформ	Хлороформ	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Этиловый эфир	Этиловый эфир	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Третбутиловый спирт	Третбутиловый спирт	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Октан+гептан+декан+нонан	Октан+гептан+декан+нонан	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Гексан	Гексан	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Уксусная к-та	Уксусная к-та	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Нафторезорцинол	Нафторезорцинол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Банка с гайкой и болтом	Банка с гайкой и болтом	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Дегалактозамин	Дегалактозамин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	TCEP Solution	TCEP Solution	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Тритон х100	Тритон х100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Орцин 1	Орцин 1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Антраниламид	Антраниламид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Трисхлор	Трисхлор	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-01-02 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Лимонная к-та	Лимонная к-та	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Калий фосфат	Калий фосфат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Трис(оксиметил)аминометан	Трис(оксиметил)аминометан	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Трис(оксиметил)аминометан	Трис(оксиметил)аминометан	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Tricine	Tricine	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Hepes	Hepes	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Лимонний фосфорнокислый	Лимонний фосфорнокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий фосфорнокислый	Натрий фосфорнокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	К-та лимонная моногидрад	К-та лимонная моногидрад	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий пирофосфорнокислый	Натрий пирофосфорнокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Хлористый натрий	Хлористый натрий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Калий фосфорнокислый	Калий фосфорнокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Глицин	Глицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Аммоний фосфорнокислый	Аммоний фосфорнокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	К-та щавелевая	К-та щавелевая	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Хлорид натрия	Хлорид натрия	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Хлористый калий	Хлористый калий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Mes	Mes	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Hepes	Hepes	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	NaCl	NaCl	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Гуанидин	Гуанидин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Hepes	Hepes	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	коробочка	\N
revizia	Реактивы по шкафам	other	\N	Bes	Bes	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Tapso	Tapso	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Mopso	Mopso	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	ADA	ADA	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Гидроэтилпиперазин	Гидроэтилпиперазин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	ACES	ACES	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	PIPES	PIPES	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	CHES	CHES	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	BIS-TRIS	BIS-TRIS	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	CAPS	CAPS	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	SDS-Na	SDS-Na	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-02-02 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Аминокапроновая к-та	Аминокапроновая к-та	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Аминокапроновая к-та	Аминокапроновая к-та	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Лаурил сульфат (SDS)	Лаурил сульфат (SDS)	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	MgSO4	MgSO4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	KOH	KOH	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий уксуснокислый	Натрий уксуснокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий уксуснокислый	Натрий уксуснокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Магний Сернокислый	Магний Сернокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Медь Сернокислая	Медь Сернокислая	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Behensaure	Behensaure	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Пентагидрат	Пентагидрат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	CaCl2	CaCl2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий кремнекислый	Натрий кремнекислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Полиэтиленгликоль 4000	Полиэтиленгликоль 4000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бензольная к-та	Бензольная к-та	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Нейтральный красный	Нейтральный красный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Рубидий фталиевыйкислый кислый	Рубидий фталиевыйкислый кислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий вольфрамокислый	Натрий вольфрамокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Калий сернистокислый	Калий сернистокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Дегидрохолиевая к-та	Дегидрохолиевая к-та	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Соль натрия глицерол фосфат	Соль натрия глицерол фосфат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Метилен бис акриламид	Метилен бис акриламид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий углекислый	Натрий углекислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Магний углекислый	Магний углекислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Аммоний сернокислый	Аммоний сернокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Кальций углекислый	Кальций углекислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий фталивокислый	Натрий фталивокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий борогидрат	Натрий борогидрат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий тетраборнокислый	Натрий тетраборнокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Аммоний щавелевокислый	Аммоний щавелевокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий сернокислый	Натрий сернокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-03-02 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Натрий серноватистокислый	Натрий серноватистокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Мочевина	Мочевина	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	NH4Cl	NH4Cl	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Аммоний молибденовокислый	Аммоний молибденовокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Мочевина	Мочевина	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	SDS	SDS	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	EDTA	EDTA	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Уголь	Уголь	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	ACS	ACS	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Казеин	Казеин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Казеин	Казеин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Folin-Ciocalteu	Folin-Ciocalteu	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Алюминий хлористый	Алюминий хлористый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Альгинад натрия	Альгинад натрия	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий ацетат	Натрий ацетат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Дезоксихолат натрия	Дезоксихолат натрия	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Orcein p.a.	Orcein p.a.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	2-Аминоэтилсерная к-та	2-Аминоэтилсерная к-та	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Казеин	Казеин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Пептон	Пептон	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-04-02 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Декстросагар	Декстросагар	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Экстракт дрожжей	Экстракт дрожжей	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Глицил глицин	Глицил глицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агарагар	Агарагар	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Экстракт дрожжей	Экстракт дрожжей	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	N7 (смесь АК)	N7 (смесь АК)	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Глицил глицин	Глицил глицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Калий железистосинсродистый	Калий железистосинсродистый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Альбумин	Альбумин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	DL Аргинин	DL Аргинин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	DL Лизина гидрохлорид	DL Лизина гидрохлорид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Набор пептонов	Набор пептонов	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Набор АК	Набор АК	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Набор АК	Набор АК	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Коробка со стеклом	Коробка со стеклом	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-05-02 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Коробка с виалами	Коробка с виалами	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Поливинилпирролидон	Поливинилпирролидон	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	коробочка	\N
revizia	Реактивы по шкафам	other	\N	Декстран Т2000	Декстран Т2000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Декстран 4	Декстран 4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	ПЭГ	ПЭГ	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Декстрансульфат	Декстрансульфат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Декстран Т500	Декстран Т500	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Декстран 200	Декстран 200	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Декстран Т20	Декстран Т20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Декстран Т70	Декстран Т70	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Декстран	Декстран	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Пакет с пектинами	Пакет с пектинами	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Коробочка с разным	Коробочка с разным	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Пектин свекловичный	Пектин свекловичный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Декстран	Декстран	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Зостерин2	Зостерин2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Пумулан	Пумулан	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Желтая банка	Желтая банка	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Банка со стеклом (сок манго)	Банка со стеклом (сок манго)	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Коробка со стеклом (аминопептид)	Коробка со стеклом (аминопептид)	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Коробка со стеклом большая	Коробка со стеклом большая	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	SDS	SDS	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-01-03 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Tween 20	Tween 20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Калий дигидрофторфосфат	Калий дигидрофторфосфат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий фосфорнокислый двузамещенный	Натрий фосфорнокислый двузамещенный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Калия хлорид	Калия хлорид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Лимоний хлористый	Лимоний хлористый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий сернокислый	Натрий сернокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Фикол 400	Фикол 400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Борная кислота	Борная кислота	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Борная кислота	Борная кислота	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Альбумин яичный	Альбумин яичный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий пиросернокислый	Натрий пиросернокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Параформальдегид	Параформальдегид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Калий фосфорно кислый однозамещенный	Калий фосфорно кислый однозамещенный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий сернокислый	Натрий сернокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Лимоний хлористый	Лимоний хлористый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Магний сернокислый	Магний сернокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Глицин	Глицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Глицин	Глицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	NaAc	NaAc	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Спиктиномезин	Спиктиномезин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Твин 20	Твин 20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Фикол 400	Фикол 400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Полиэтиленгликоль	Полиэтиленгликоль	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Полиэтиленгликоль 1000	Полиэтиленгликоль 1000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Полиэтиленгликоль 6000	Полиэтиленгликоль 6000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	CaCl2	CaCl2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Стойка с пробирками на 3.1	\N
revizia	Реактивы по шкафам	other	\N	KH2PO4	KH2PO4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	KCl	KCl	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Hepes	Hepes	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	желатин	желатин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	гуанизин HCl	гуанизин HCl	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	NaH2PO4	NaH2PO4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	мочевина	мочевина	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Na2CO3	Na2CO3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	NaAc	NaAc	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Na2HPO4	Na2HPO4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	имидазол	имидазол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	трицин	трицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Na2S2O3	Na2S2O3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	PBS	PBS	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Сахароза	Сахароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-02-03 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Полиэтиленгликоль 6000	Полиэтиленгликоль 6000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Трисгидроксимтиламинопентан	Трисгидроксимтиламинопентан	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Диклосерин	Диклосерин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Метилен бисакриламид	Метилен бисакриламид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Сефадекс G50 Superfine	Сефадекс G50 Superfine	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Трис	Трис	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Трицин	Трицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Agar Tryptose	Agar Tryptose	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бакто Агар	Бакто Агар	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агар М	Агар М	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза для ЭФ	Агароза для ЭФ	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агар-Агар для микробиологии 2%	Агар-Агар для микробиологии 2%	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агар	Агар	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Акриламид	Акриламид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза для ЭФ	Агароза для ЭФ	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агар-Агар	Агар-Агар	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бакто Агар	Бакто Агар	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	CsCl	CsCl	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Стрептомицин	Стрептомицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агар-Агар	Агар-Агар	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-03-03 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бромфенолоый синий	Бромфенолоый синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Кумасси синий	Кумасси синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Акриламид	Акриламид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	SDS	SDS	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Метилен бисакриламид	Метилен бисакриламид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Лизоцим	Лизоцим	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Тимин	Тимин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Аденин	Аденин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Аммоний надсернокислый	Аммоний надсернокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Этидий	Этидий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бромистый этидий	Бромистый этидий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Хлорамфеникол	Хлорамфеникол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Хлорамфеникол	Хлорамфеникол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Фикол 400	Фикол 400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	KOH	KOH	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	NaOH	NaOH	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	KOH	KOH	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	KOH	KOH	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	NaOH	NaOH	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	NaOH	NaOH	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	пероксидаза хрена	пероксидаза хрена	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Стойка с пробирками на 3.3	\N
revizia	Реактивы по шкафам	other	\N	бромфеноловый синий	бромфеноловый синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	сульфат магния	сульфат магния	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	ксилен цианол	ксилен цианол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	CaCl2 10%	CaCl2 10%	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	новокаин 0,5%	новокаин 0,5%	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	хлороформ	хлороформ	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	бисакриламид	бисакриламид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	эритромицин	эритромицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Коробка Антибиотики	\N
revizia	Реактивы по шкафам	other	\N	ампициллин	ампициллин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	тетрациклина гидрохлорид	тетрациклина гидрохлорид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	тетрациклина гидрохлорид	тетрациклина гидрохлорид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	тетраолеан	тетраолеан	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	карбиницилина динатриевая соль	карбиницилина динатриевая соль	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	эритромицин	эритромицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	рифомицин	рифомицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	новобиоцин	новобиоцин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	рифампицин	рифампицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	эритромицин	эритромицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	левомицина сукцинат	левомицина сукцинат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	эритромицин	эритромицин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Коробка Покровная	Коробка Покровная	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	подозрительная колба с KOH	подозрительная колба с KOH	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Ализурингельб	Ализурингельб	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Коробка Краски	\N
revizia	Реактивы по шкафам	other	\N	Феноловый красный	Феноловый красный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Индикатор Рис	Индикатор Рис	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Тимолфталеин	Тимолфталеин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Тимоловый синий	Тимоловый синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Тимолфталеин	Тимолфталеин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Фенолфталиен	Фенолфталиен	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Нафтиловый красный	Нафтиловый красный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бромфеноловый красный	Бромфеноловый красный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Метиловый красный	Метиловый красный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Универсальный индиактор	Универсальный индиактор	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бромкрезоловый зеленый синий	Бромкрезоловый зеленый синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бромкрезоловый пурпурный	Бромкрезоловый пурпурный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Феноловый красный	Феноловый красный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бромтиловый синий	Бромтиловый синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	24динитрофенол	24динитрофенол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бисмутон2	Бисмутон2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Красный пирогололовый	Красный пирогололовый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Акридиновый оранжевый	Акридиновый оранжевый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Алоксангилрат	Алоксангилрат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бромсульфоназа3	Бромсульфоназа3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Пирогалолфталеин	Пирогалолфталеин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	25дифиниилиоксазол	25дифиниилиоксазол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бензаил6 аминокапроновая кислота	Бензаил6 аминокапроновая кислота	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Синий трипановый для микро	Синий трипановый для микро	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Аллоксангидрат	Аллоксангидрат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Нингидрин	Нингидрин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Тетрафинилборат натрия	Тетрафинилборат натрия	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	N24динитрофенил гидразин	N24динитрофенил гидразин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Кармин	Кармин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Красный пирогололовый	Красный пирогололовый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бензол сульфокислота кальциевая соль	Бензол сульфокислота кальциевая соль	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Ализариновый желтый ЖЖ	Ализариновый желтый ЖЖ	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Емазин метосульфат	Емазин метосульфат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Арсиназо	Арсиназо	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Фуксин кислый	Фуксин кислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Судановый	Судановый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Синий эванс	Синий эванс	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Ророр	Ророр	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Пиноцианол	Пиноцианол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Рибофлавин	Рибофлавин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Феназилметасульфат	Феназилметасульфат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Нитротетразолиевый синий	Нитротетразолиевый синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Тримеркаптобензатиазол	Тримеркаптобензатиазол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	N24динитрофенил гидразин	N24динитрофенил гидразин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Хромотроповая кислота	Хромотроповая кислота	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бетаинмоногидрат	Бетаинмоногидрат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Глицин тимоловый синий	Глицин тимоловый синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Пентометакси красный	Пентометакси красный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-04-03 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Демальтоза	Демальтоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Агароза	Агароза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Нуклеозид фосфаты №6	Нуклеозид фосфаты №6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Глицерин	Глицерин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Лаурил сульфат	Лаурил сульфат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Диэтал аминоэтил целлюлоза	Диэтал аминоэтил целлюлоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Калий фосфорнокислый	Калий фосфорнокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Ацетат магния	Ацетат магния	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Хлорид натрия	Хлорид натрия	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Брилиантовый синий кумаси	Брилиантовый синий кумаси	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Рибофлавин	Рибофлавин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Борная к-та	Борная к-та	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Ацетат калия	Ацетат калия	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий фосфорнокислый	Натрий фосфорнокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	MgSO4	MgSO4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бромистый этидий	Бромистый этидий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Цитрат калия	Цитрат калия	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	стойка с пробирками	\N
revizia	Реактивы по шкафам	other	\N	MgO2	MgO2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Имидазол	Имидазол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Азид натрия	Азид натрия	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	EDTA	EDTA	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Chelex 100	Chelex 100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Понсo	Понсo	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	коробка обуви	\N
revizia	Реактивы по шкафам	other	\N	Амидо черный	Амидо черный	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Ксиленцианол	Ксиленцианол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Эозин	Эозин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Азур	Азур	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Фуксин кислый	Фуксин кислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Метилово зеленый	Метилово зеленый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Кумаси брилиантово синий	Кумаси брилиантово синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бромфеноловый синий	Бромфеноловый синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Кармин	Кармин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Метиленово синий	Метиленово синий	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Брилиантовый зеленый	Брилиантовый зеленый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Serva Blue R	Serva Blue R	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Этилендиамин тетрауксусная к-та	Этилендиамин тетрауксусная к-та	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Тризма	Тризма	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Трисгидроксиметил аминометан	Трисгидроксиметил аминометан	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Sigma 7-9	Sigma 7-9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	ПЭГ	ПЭГ	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Трисоксиметил аминомметан	Трисоксиметил аминомметан	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Трисоксиметил аминомметан	Трисоксиметил аминомметан	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Натрий лимонно кислый	Натрий лимонно кислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	2	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Коробка 26	\N
revizia	Реактивы по шкафам	other	\N	Овомукоид	Овомукоид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Averol	Averol	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Арсенат	Арсенат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	4	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Коробка 26	\N
revizia	Реактивы по шкафам	other	\N	Лимонная кислота	Лимонная кислота	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Имидазол	Имидазол	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	D(+)ксилоза	D(+)ксилоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Пара-нитро-фенил фосфат	Пара-нитро-фенил фосфат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	3	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Коробка 26	\N
revizia	Реактивы по шкафам	other	\N	SDS	SDS	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	ПЭГ MB 12000	ПЭГ MB 12000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Tritone x 305	Tritone x 305	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	6 - Нуклеозид фосфаты	6 - Нуклеозид фосфаты	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Коробка 26	\N
revizia	Реактивы по шкафам	other	\N	Na серноватокислый тиосульфат Na	Na серноватокислый тиосульфат Na	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Na пиросернокислый	Na пиросернокислый	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	5	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Коробка 26	\N
revizia	Реактивы по шкафам	other	\N	Mitomycin C	Mitomycin C	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	8-HYDROXYQUINOLINE	8-HYDROXYQUINOLINE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Тринстогидринден гидрат	Тринстогидринден гидрат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Двуокись рутения	Двуокись рутения	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Tris	Tris	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	KCl	KCl	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	ZnSO4	ZnSO4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	MgO4S	MgO4S	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Дезоксихолевая психолевая кислота	Дезоксихолевая психолевая кислота	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Пансо С	Пансо С	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Бутанол 1	Бутанол 1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2024-05-03 00:00:00	\N
revizia	Реактивы по шкафам	other	\N	Формамид	Формамид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	ИПС	ИПС	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	D(+)Мальтоза	D(+)Мальтоза	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Уксусная к-та 100%	Уксусная к-та 100%	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Изопропиловый спирт	Изопропиловый спирт	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	3	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	12. Овомупоид- Есмарка А, З фенакома В Bu? и	12. Овомупоид- Есмарка А, З фенакома В Bu? и	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	13. Averol (Duponol)	13. Averol (Duponol)	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	14. Арсенат. 4.02.	14. Арсенат. 4.02.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	а/т коробка N2	а/т коробка N2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	15. SDS Sigma	15. SDS Sigma	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	16 пар MB 12000	16 пар MB 12000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	17. Tritone x 305	17. Tritone x 305	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	} а/п коробка N3	} а/п коробка N3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	18 Лимоннале пист	18 Лимоннале пист	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	19.	19.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Hom	Hom	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	Испидозом. 17: 20. Д-(+)- псилоза (Ракием)	Испидозом. 17: 20. Д-(+)- псилоза (Ракием)	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Реактивы по шкафам	other	\N	21 Trapa раст барше	21 Trapa раст барше	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Полка верх	Полка верх	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Альбумин яичный, лиоф крист	Альбумин яичный, лиоф крист	\N	\N	\N	Реахим	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	4-Phenylendiamine 2HCl	4-Phenylendiamine 2HCl	\N	\N	\N	Serva	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Phenylmethyl sulfonylfluoride	Phenylmethyl sulfonylfluoride	\N	\N	\N	Serva	\N	\N	2.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	1,4-Phenylendiamine 2HCl	1,4-Phenylendiamine 2HCl	\N	\N	\N	Serva	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	3,3’,5,5’-Tetramethylbenzidine	3,3’,5,5’-Tetramethylbenzidine	\N	\N	\N	Serva	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Lysozyme (chicken egg white)	Lysozyme (chicken egg white)	\N	\N	\N	Serva	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Sodium p-Toluenesulfonchloramide Trihydrare	Sodium p-Toluenesulfonchloramide Trihydrare	\N	\N	\N	Китай	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	L-Tryptophan-beta-naphthylamide	L-Tryptophan-beta-naphthylamide	\N	\N	\N	Coinbrook Bucks England	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	L-Alanine-beta-naphthylamide	L-Alanine-beta-naphthylamide	\N	\N	\N	Англия	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Уксус. ангидрид	Уксус. ангидрид	\N	\N	\N	самопал	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Уксус. ангидрид	Уксус. ангидрид	\N	\N	\N	Реахим	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	антитела IL-2 irma 100 beads	антитела IL-2 irma 100 beads	\N	\N	\N	CellTech	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Брэдфорд	Брэдфорд	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	СТ.G	СТ.G	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	N,N’-Methylene bisacrylamide 2x	N,N’-Methylene bisacrylamide 2x	\N	\N	\N	Serva	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	антитела IL-2 irma	антитела IL-2 irma	\N	\N	\N	CellTech	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Ацетилхолид йодистый 30.0	Ацетилхолид йодистый 30.0	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Silicone Solution Serva	Silicone Solution Serva	\N	\N	\N	Serva	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Глюкоамилаза основн.	Глюкоамилаза основн.	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Ванилоза	Ванилоза	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Albumin (from bovine serum)	Albumin (from bovine serum)	\N	\N	\N	Sigma	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Cellulase Sigma N. C-7502	Cellulase Sigma N. C-7502	\N	\N	\N	Sigma	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Глюкоамилаза основн. HPLC	Глюкоамилаза основн. HPLC	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Лизоцим	Лизоцим	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Глюк. 340 Минор. Х100 гр. оч.	Глюк. 340 Минор. Х100 гр. оч.	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	TFA	TFA	\N	\N	\N	Pierce	\N	\N	10.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Гепарин	Гепарин	\N	\N	\N	Рихтер	\N	\N	4.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Пируваткиназа крист.	Пируваткиназа крист.	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Гуанозин	Гуанозин	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Цитидин-5’-трифосфат Na	Цитидин-5’-трифосфат Na	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Ферритин лиоф (из селезенки лошади)	Ферритин лиоф (из селезенки лошади)	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Пероксидаза (из хрена)	Пероксидаза (из хрена)	\N	\N	\N	Roanal	\N	\N	2.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Пероксидаза (из хрена)	Пероксидаза (из хрена)	\N	\N	\N	Реахим	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Phenyl-N-(1-oxyl-2,2,5,5-tetramethylpyrrolin-3-gammal) thiocarbamate	Phenyl-N-(1-oxyl-2,2,5,5-tetramethylpyrrolin-3-gammal) thiocarbamate	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Ampholine	Ampholine	\N	\N	\N	LKB	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Цитидин-5’-трифосфат Na	Цитидин-5’-трифосфат Na	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Аденозин	Аденозин	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Аденозин-5’-монофосфат Na	Аденозин-5’-монофосфат Na	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Уридин-5’-трифосфат Na	Уридин-5’-трифосфат Na	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Уридин-5’-трифосфат Na	Уридин-5’-трифосфат Na	\N	\N	\N	Roanal	\N	\N	2.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Гуанозин-5’-дифосфат Na	Гуанозин-5’-дифосфат Na	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Гуанозин-5’-монофосфат Na	Гуанозин-5’-монофосфат Na	\N	\N	\N	Будапешт	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Гуанозин-5’-трифосфат Na	Гуанозин-5’-трифосфат Na	\N	\N	\N	Roanal	\N	\N	2.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Гуанозин-2’,3’-циклофосфат соль Na	Гуанозин-2’,3’-циклофосфат соль Na	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Sulfatase	Sulfatase	\N	\N	\N	Sigma	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	N-(1-Oxyl-2,2,6,6-tetramethylpiperid-4-yl)-p-chloromerculibenzamide	N-(1-Oxyl-2,2,6,6-tetramethylpiperid-4-yl)-p-chloromerculibenzamide	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Глутатион восст.	Глутатион восст.	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Рибофлавин	Рибофлавин	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Аденозин-3’,5’-цинкофосфорная соль Na	Аденозин-3’,5’-цинкофосфорная соль Na	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Овомукоид (из яичного белка)	Овомукоид (из яичного белка)	\N	\N	\N	Реахим	\N	\N	2.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Актиномицин-D	Актиномицин-D	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Эпихлор. гидрин	Эпихлор. гидрин	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Formamid	Formamid	\N	\N	\N	Serva	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Epichlorohydrin	Epichlorohydrin	\N	\N	\N	Fluka Chemika	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	2-Mercaptoethanol	2-Mercaptoethanol	\N	\N	\N	nacalai tesque	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	2-Mercaptoethanol	2-Mercaptoethanol	\N	\N	\N	Serva	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Polyethylenimine 50%	Polyethylenimine 50%	\N	\N	\N	Serva	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Trifluoroacetic acid	Trifluoroacetic acid	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Con A-Sepharose	Con A-Sepharose	\N	\N	\N	Pharmacia Fine Chemicals	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Lodomethane	Lodomethane	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Трифторуксусная кислота 99%	Трифторуксусная кислота 99%	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Cibacron Blue F3GA	Cibacron Blue F3GA	\N	\N	\N	Serva	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Temed	Temed	\N	\N	\N	Bio-rad	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Trichloroacetic acid	Trichloroacetic acid	\N	\N	\N	Serva	\N	\N	2.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Казеин-сефароза (?)	Казеин-сефароза (?)	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Толуол-сульфокислота	Толуол-сульфокислота	\N	\N	\N	-	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Ethylenediamine anhydrous	Ethylenediamine anhydrous	\N	\N	\N	Serva	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Natrium cyanoborhydrid	Natrium cyanoborhydrid	\N	\N	\N	Serva	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	НАДФ-Na	НАДФ-Na	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	НАД	НАД	\N	\N	\N	Roanal	\N	\N	1.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Фруктоза-1,6-дифосфорная моно-кальциевая соль	Фруктоза-1,6-дифосфорная моно-кальциевая соль	\N	\N	\N	Roanal	\N	\N	11.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Полка 2	Полка 2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	ДНК высокомолекулярная высуш. (из селезенки кр. рог. скота)	ДНК высокомолекулярная высуш. (из селезенки кр. рог. скота)	\N	\N	\N	Реахим	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	D-alpha-аланин чистый	D-alpha-аланин чистый	\N	\N	\N	Roanal	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Agarose-Z	Agarose-Z	\N	\N	\N	LKG	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Серебро азотнокислое	Серебро азотнокислое	\N	\N	\N	Свердловский завод хим. реактивов	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Uracil	Uracil	\N	\N	\N	Serva	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	МКЦ	МКЦ	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	n-Нитрофениловый эфир фосфорной кислоты Ba, H2O	n-Нитрофениловый эфир фосфорной кислоты Ba, H2O	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Triton X-100	Triton X-100	\N	\N	\N	Austranal Präparate	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Agarose-zero	Agarose-zero	\N	\N	\N	Bio-Rad	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	2,2'-Dithiodipyridine	2,2'-Dithiodipyridine	\N	\N	\N	Sigma	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	N,N'-Methylene-bis-acrylamide	N,N'-Methylene-bis-acrylamide	\N	\N	\N	Bio-Rad	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	BIS	BIS	\N	\N	\N	Bio-Rad	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Protaminsulfat	Protaminsulfat	\N	\N	\N	Merck	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Гуанозин-5'-трифосфат Na	Гуанозин-5'-трифосфат Na	\N	\N	\N	Roanal	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Глюкозил-фторид	Глюкозил-фторид	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Adenosine-5'-triphosphate Na	Adenosine-5'-triphosphate Na	\N	\N	\N	Serva	\N	\N	3.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Минорн. ГА. А.	Минорн. ГА. А.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Kit Equalbit 1 x dsDNA Hs	Kit Equalbit 1 x dsDNA Hs	\N	\N	\N	Vazyme	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Трипсин ингибитор, лиоф.	Трипсин ингибитор, лиоф.	\N	\N	\N	Roanal	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	TPCK-tripsin	TPCK-tripsin	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Трипсин крист.	Трипсин крист.	\N	\N	\N	СПОФА	\N	\N	2.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Трипсин крист.	Трипсин крист.	\N	\N	\N	СПОФА	\N	\N	2.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	DTNB (Ellman's kit)	DTNB (Ellman's kit)	\N	\N	\N	Sigma	\N	\N	2.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Калий-натрий виннокислый	Калий-натрий виннокислый	\N	\N	\N	Реахим	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Калий йодистый буфер	Калий йодистый буфер	\N	\N	\N	Реахим	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Калий йодистый	Калий йодистый	\N	\N	\N	Реахим	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Медь сернокислая	Медь сернокислая	\N	\N	\N	Реахим	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	тил-betta-D-глюкопиранозид	тил-betta-D-глюкопиранозид	\N	\N	\N	Chemapol	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	betta-N-Gal	betta-N-Gal	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	betta-D-Fuc-HP	betta-D-Fuc-HP	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Гал-глицерин	Гал-глицерин	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Человеческий лейкоцитарный интерферон	Человеческий лейкоцитарный интерферон	\N	\N	\N	Уфа	\N	\N	11.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Полка 4	Полка 4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Гепарин-сефароза (из колонки)	Гепарин-сефароза (из колонки)	\N	\N	\N	\N	\N	\N	2.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Лактатдегидрогеназа крист.	Лактатдегидрогеназа крист.	\N	\N	\N	Roanal	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	S-sepharose	S-sepharose	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	N-(Dimethylaminopropyl)-N'-ethylcarbodiinide hydrochloride	N-(Dimethylaminopropyl)-N'-ethylcarbodiinide hydrochloride	\N	\N	\N	Fluka Chemika	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Сферанит-OH	Сферанит-OH	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Q-gamma-гель	Q-gamma-гель	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Фенил-сферогель	Фенил-сферогель	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	ПНФ-гал	ПНФ-гал	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Na цитр. pH 5,5 0,1M	Na цитр. pH 5,5 0,1M	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	n НФГал betta (in H2O)	n НФГал betta (in H2O)	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Tris(2-carboxyethyl)phosphine hydrochloride solution	Tris(2-carboxyethyl)phosphine hydrochloride solution	\N	\N	\N	Sigma	\N	\N	10.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	TCEP HCl	TCEP HCl	\N	\N	\N	Thermo Scientific	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	AH-Sepharose 4B	AH-Sepharose 4B	\N	\N	\N	Pharmacia Fine Chemicals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	CH-агароза	CH-агароза	\N	\N	\N	Кемотех	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	AH-агароза	AH-агароза	\N	\N	\N	Кемотех	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	BrCN-активированная агароза	BrCN-активированная агароза	\N	\N	\N	Кемотех	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Orcinol ferric chloride (Bial's Reagent)	Orcinol ferric chloride (Bial's Reagent)	\N	\N	\N	Sigma	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	N,N,N,'N'-Тетраметилэтилендиамин	N,N,N,'N'-Тетраметилэтилендиамин	\N	\N	\N	Reanal	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	N,N'-Dicyclohexanylcarbodiimid 99%	N,N'-Dicyclohexanylcarbodiimid 99%	\N	\N	\N	Aldrich-Chemie	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Act. Ultragel AcA 22	Act. Ultragel AcA 22	\N	\N	\N	IBF LKB	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Phenyl Sepharose	Phenyl Sepharose	\N	\N	\N	Pharmacia	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Glyoxal 30% aque.	Glyoxal 30% aque.	\N	\N	\N	Serva	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Cycloheximide	Cycloheximide	\N	\N	\N	Sigma	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Этилацетат	Этилацетат	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Q-sepharose	Q-sepharose	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Лактоза, 53,5 мг/мл D2O	Лактоза, 53,5 мг/мл D2O	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Sp-TSK 650 (M)	Sp-TSK 650 (M)	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	citroconic anhydride fluks	citroconic anhydride fluks	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Q-Sepharose Fast Flow	Q-Sepharose Fast Flow	\N	\N	\N	Pharmacia	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Phenyl Sepharose	Phenyl Sepharose	\N	\N	\N	Pharmacia	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Буфер 10 мМ, D2O	Буфер 10 мМ, D2O	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Трикетогидринден гидрат чда. (Ninhydrin)	Трикетогидринден гидрат чда. (Ninhydrin)	\N	\N	\N	Reanal	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Amonium persulphate	Amonium persulphate	\N	\N	\N	Reanal	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	betta-цд-Seph.	betta-цд-Seph.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	К-фосф 1 M ph 5,3	К-фосф 1 M ph 5,3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	D2O	D2O	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Конканавалин А	Конканавалин А	\N	\N	\N	ПанЭко	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Applichem glutaraldeh. 50%	Applichem glutaraldeh. 50%	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	5% глут.	5% глут.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Amicon GelBlue A	Amicon GelBlue A	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Amicon Red A Gel	Amicon Red A Gel	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	выдвижной лево	выдвижной лево	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	4,5,4',5'-dibenzo-3,3'-diethyl-9-methylthiacarbocyaninebromide	4,5,4',5'-dibenzo-3,3'-diethyl-9-methylthiacarbocyaninebromide	\N	\N	\N	Serva	\N	\N	6.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Dymethylsulfoxide	Dymethylsulfoxide	\N	\N	\N	Serva	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Silver Stain oxidizer concentrate	Silver Stain oxidizer concentrate	\N	\N	\N	Bio-Rad	\N	\N	2.0	\N	\N	\N	\N	\N	\N	\N
revizia	Холодильник 2	other	\N	Silver Stain Developer	Silver Stain Developer	\N	\N	\N	Bio-Rad	\N	\N	4.0	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.locations (id, room, cabinet, shelf, slot) FROM stdin;
1	306	Белый стеллаж, 1 полка	-	-
4	306	Шкаф под вытяжкой	-	-
5	306	Не указано	-	-
8	308	Белый стеллаж, 1 полка	-	-
9	308	Белый стеллаж, 2 полка	-	-
10	308	Белый стеллаж, 3 полка	-	-
11	308	Холодильник	-	-
12	308	Белый стеллаж, 4 полка	-	-
\.


--
-- Data for Name: protocols; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.protocols (id, code, name, category, steps, notes, created_at, updated_at) FROM stdin;
1	P1	Микрочастицы CaCO3	Микро- и наночастицы	На магнитной мешалке при комнатной температуре:\n1) Добавить 2.5 мл дистиллированной воды\n2) Добавить 615 мкл водного раствора CaCl2 (1М)\n3) По каплям добавить 615 мкл водного раствора Na2CO3 (1М), увеличивая скорость мешалки\n4) Мешать 30 сек\n5) Промыть водой три раза, откручивая на центрифуге Microspin	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
2	P2	Добавление полимерного бислоя на микроCaCO3	Микро- и наночастицы	1) К осадку добавить 500 мкл водного раствора PAH (2 мг/мл)\n2) Ресуспензировать в УЗВ\n3) Оставить на ротаторе на 6 мин\n4) Промыть водой один раз\n5) К осадку добавить 500 мкл PSS (2 мг/мл)\n6) Ресуспензировать в УЗВ\n7) Оставить на ротаторе на 6 мин\n8) Промыть водой один раз\nВ конце синтеза промыть два раза	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
3	P3	Микрочастицы CaCO3@Cy5	Микро- и наночастицы	На магнитной мешалке при комнатной температуре:\n1) Добавить 2.2 мл дистиллированной воды\n2) Добавить 300 мкл Cy5@BSA\n3) Добавить 615 мкл водного раствора CaCl2 (1М)\n4) По каплям добавить 615 мкл водного раствора Na2CO3 (1М), увеличивая скорость мешалки\n5) Мешать 30 сек\n6) Промыть водой три раза, откручивая на центрифуге Microspin	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
4	P4	Наночастицы CaCO3	Микро- и наночастицы	На магнитной мешалке при комнатной температуре:\n1) Добавить 3 мл водного раствора CaCl2 (0.1М)\n2) Добавить 3 мл водного раствора PAA (3 мг/мл)\n3) Мешать 1 час\n4) Добавить 3 мл водного раствора Na2CO3 (0.1М)\n5) Мешать 1 час\n6) Промыть водой три раза, откручивая на центрифуге при 13400 об/мин 4 мин	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
5	P5	Наночастицы CaCO3@Cy5	Микро- и наночастицы	На магнитной мешалке при комнатной температуре:\n1) Добавить 3 мл водного раствора CaCl2 (0.1М)\n2) Добавить 300 мкл Cy5@BSA\n3) Мешать 1 час\n4) Добавить 3 мл водного раствора PAA (3 мг/мл)\n5) Мешать 1 час\n6) Добавить 3 мл водного раствора Na2CO3 (0.1М)\n7) Мешать 1 час\n8) Промыть водой три раза, откручивая на центрифуге при 13400 об/мин 4 мин	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
6	P6	Микрочастицы PLA	Микро- и наночастицы	Подготовить растворы:\n1) Водный раствор PVA (20 мг/мл). Растворяется при 80°C в термошейкере несколько часов при 600 об/мин\n2) Раствор PLA (50 мг/мл) в хлороформе. Растворяется на магнитной мешалке при 40°C час-полтора\nПолучение частиц:\n1) В пробирку на 50 мл добавить 12 мл раствора PVA\n2) На дно пробирки добавить 3 мл раствора PLA\n3) Интенсивно встряхивать примерно 1 минуту\n4) Перелить в стакан, поставить на магнитную мешалку\n5) Мешать 10 мин при комнатной температуре\n6) Мешать 15 мин при 37°C\n7) Открутить на центрифуге при 5000 об/мин 5 мин\n8) Слить надосадочную жидкость\n9) Добавить воду до 15 мл, ресуспензировать\n10) Поставить на стол на 3.5 мин\n11) Забрать надосадочную часть\n12) Открутить надосадочную часть на центрифуге при 5000 об/мин 5 мин	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
7	P7	Наночастицы PLA	Микро- и наночастицы	1) Растворить 100 мг PLA в 0.5 мл DMF в термошейкере при 75°C при 750 об/мин несколько часов\n2) В стакан на магнитной мешалке добавить 40 мл дистиллированной воды и 40 мкл TWEEN80\n3) В пробирку на 50 мл добавить 16 мл ацетона и 4 мл этанола 96%\n4) В пробирку с PLA добавить 1 мл смеси ацетона со спиртом, ресуспензировать\n5) Перелить раствор с PLA в пробирку с органической фазой\n6) Ресуспензировать\n7) Аккуратно медленно влить органическую фазу в стакан с водой\n8) Выпаривать на магнитной мешалке при комнатной температуре 2 дня	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
8	P8	Микрочастицы BaCO3	Микро- и наночастицы	На магнитной мешалке при комнатной температуре:\n1) Добавить 10 мл водного раствора BaCl2 (0.1M)\n2) Добавить 30 мг PAA\n3) Мешать 1 час\n4) Добавить 10 мл водного раствора Na2CO3 (0.1M)\n5) Мешать 1 час\n6) Промыть водой три раза, откручивая на центрифуге при 7000 об/мин 10 мин	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
9	P9	Наночастицы BaCO3	Микро- и наночастицы	На магнитной мешалке при комнатной температуре:\n1) Растворить 488 мг BaCl2 в 20 мл раствора дистиллированной воды и этиленгликоля (5.7 мл воды, 14.3 мл этиленгликоля) 5 мин\n2) Добавить к раствору BaCl2 60 мг PAA\n3) Мешать 1 час\n4) Растворить 212 мг Na2CO3 в 20 мл раствора воды и этиленгликоля\n5) Добавить к раствору Na2CO3 60 мг PAA\n6) Мешать 1 час\n7) Добавить к раствору Na2CO3 750 мкл 1М HCl (pH 3-5)\n8) Добавить к раствору Na2CO3 раствор BaCl2\n9) Мешать 1 час\n10) Промыть водой три раза, откручивая на центрифуге при 13400 об/мин 4 мин	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
10	P10	Наночастицы SiO2	Микро- и наночастицы	На магнитной мешалке при комнатной температуре:\n1) Добавить 8750 мкл этанола 96%\n2) Добавить 2405 мкл дистиллированной воды\n3) Добавить по капле 65 мкл TEOS, постепенно увеличивая скорость мешалки\n4) Мешать 2.5 мин\n5) Добавить по капле 390 мкл NH3, постепенно увеличивая скорость мешалки\n6) Накрыть. Мешать 1.5 часа\n7) Промыть водой три раза, откручивая на центрифуге при 13400 об/мин 4 мин	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
11	P11	Наночастицы SiO2@Cy5	Микро- и наночастицы	На магнитной мешалке при комнатной температуре:\n1) Добавить 8750 мкл этанола 96%\n2) Добавить 2205 мкл дистиллированной воды\n3) Добавить 200 мкл Cy5@BSA\n4) Добавить по капле 65 мкл TEOS, постепенно увеличивая скорость мешалки\n5) Мешать 2.5 мин\n6) Добавить по капле 390 мкл NH3, постепенно увеличивая скорость мешалки\n7) Накрыть. Мешать 1.5 часа\n8) Промыть водой три раза, откручивая на центрифуге при 13400 об/мин 4 мин	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
12	P12	Наночастицы желатина	Микро- и наночастицы	1) Растворить 60 мг желатина в 2 мл дистиллированной воды на магнитной мешалке при 50°C\n2) В пробирку на 15 мл налить 10 мл ацетона, поставить на водяную баню при 37°C\n3) К желатину добавить 35 мкл NaOH (1M)\n4) Желатин перелить в пробирку на 15 мл, поставить на водяную баню при 37°C на 15 мин\n5) По стеночке аккуратно влить ацетон к желатину, перемешать покачиванием\n6) Поставить на водяную баню при 37°C на 30 мин\n7) Добавить 675 мкл 0.8% раствора глутаральдегида, перемешать покачиванием\n8) Поставить на водяную баню при 37°C на 60 мин\n9) Промыть водой три раза, откручивая на центрифуге при 13400 об/мин 4 мин	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
13	P13	Наночастицы хитозана	Микро- и наночастицы	На магнитной мешалке при комнатной температуре:\n1) Добавить 3 мл 0.1% (w/v) раствора хитозана в 1% уксусной кислоте\n2) По каплям добавить 1 мл 0.25% (w/v) раствора TPP\n3) Мешать 1 мин\n4) Промыть водой три раза, откручивая на центрифуге при 13400 об/мин 4 мин	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
14	P14	Синтез FeBDC	МОФы	1) 405 мг FeCl3 и 248 мг BDC растворить в 5 мл DMF\n2) В стеклянной виале поставить в термоблок при 120°C на ночь\n3) Постепенно охладить, поэтапно опуская температуру термоблока на 5-10°C\n4) Промыть два раза DMF и два раза водой, откручивая на центрифуге при 10000 об/мин 5 мин\n5) Высушить в вакуумном сушильном шкафу при 70°C	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
15	P15	Синтез CoBDC	МОФы	1) 720 мг Co(NO3)2 растворить в 5 мл дистиллированной воды\n2) 411 мг BDC растворить в 5 мл DMF\n3) В стеклянной виале поставить в термоблок при 120°C на ночь\n4) Постепенно охладить, поэтапно опуская температуру термоблока на 5-10°C\n5) Промыть два раза DMF и два раза водой, откручивая на центрифуге при 10000 об/мин 5 мин\n6) Высушить в вакуумном сушильном шкафу при 70°C	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
16	P16	Синтез NiBDC	МОФы	1) 720 мг Ni(NO3)2 растворить в 10 мл дистиллированной воды\n2) 132 мг BDC растворить в 10 мл DMF\n3) В стеклянной виале поставить в термоблок при 120°C на ночь\n4) Постепенно охладить, поэтапно опуская температуру термоблока на 5-10°C\n5) Промыть два раза DMF и два раза водой, откручивая на центрифуге при 10000 об/мин 5 мин\n6) Высушить в вакуумном сушильном шкафу при 70°C	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
17	P17	Синтез Micro-UiO-66	МОФы	1) 70 мг ZrCl4, 50 мг BDC и 1050 мг бензойной кислоты растворить в 2 мл DMF\n2) Добавить 20 мкл HCl\n3) В стеклянной виале поставить в термоблок при 120°C на 48 часов\n4) Постепенно охладить, поэтапно опуская температуру термоблока на 5-10°C\n5) Промыть два раза DMF и два раза метанолом, откручивая на центрифуге при 10000 об/мин 10 мин\n6) Высушить в вакуумном сушильном шкафу при 70°C	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
18	P18	Синтез Nano-UiO-66	МОФы	1) 70 мг ZrCl4, 50 мг BDC и 350 мг бензойной кислоты растворить в 2 мл DMF\n2) Добавить 50 мкл HCl\n3) В стеклянной виале поставить в термоблок при 120°C на 48 часов\n4) Постепенно охладить, поэтапно опуская температуру термоблока на 5-10°C\n5) Промыть два раза DMF и два раза метанолом, откручивая на центрифуге при 10000 об/мин 10 мин\n6) Высушить в вакуумном сушильном шкафу при 70°C	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
19	P19	Синтез Micro-UiO-66-NH2	МОФы	1) 70 мг ZrCl4, 50 мг 2-аминобензолдикарбоновой-1,4 кислоты и 1050 мг бензойной кислоты растворить в 2 мл DMF\n2) Добавить 20 мкл HCl\n3) В стеклянной виале поставить в термоблок при 120°C на 48 часов\n4) Постепенно охладить, поэтапно опуская температуру термоблока на 5-10°C\n5) Промыть два раза DMF и два раза метанолом, откручивая на центрифуге при 10000 об/мин 10 мин\n6) Высушить в вакуумном сушильном шкафу при 70°C	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
20	P20	Синтез Nano-UiO-66-NH2	МОФы	1) 70 мг ZrCl4, 50 мг 2-аминобензолдикарбоновой-1,4 кислоты и 350 мг бензойной кислоты растворить в 2 мл DMF\n2) Добавить 50 мкл HCl\n3) В стеклянной виале поставить в термоблок при 120°C на 48 часов\n4) Постепенно охладить, поэтапно опуская температуру термоблока на 5-10°C\n5) Промыть два раза DMF и два раза метанолом, откручивая на центрифуге при 10000 об/мин 10 мин\n6) Высушить в вакуумном сушильном шкафу при 70°C	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
21	P21	Cy5@BSA	Флуоресцентные метки	1) 77 мг BSA растворить в 20 мл PBS 1x\n2) 5 мг Cy5 растворить в 2.2 мл DMSO\n3) Влить Cy5 к BSA\n4) Поставить в термошейкер при 4°C при 700 об/мин на сутки\n5) Поставить на диализ на 3-4 дня при 4°C	\N	2026-07-05 23:39:43.406938	2026-07-05 23:39:43.406938
\.


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.items_id_seq', 213, true);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.locations_id_seq', 12, true);


--
-- Name: protocols_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.protocols_id_seq', 21, true);


--
-- Name: items items_code_source_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_code_source_key UNIQUE (internal_code, source_file);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: locations locations_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_unique UNIQUE (room, cabinet, shelf, slot);


--
-- Name: protocols protocols_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protocols
    ADD CONSTRAINT protocols_pkey PRIMARY KEY (id);


--
-- Name: idx_items_catalog_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_items_catalog_number ON public.items USING btree (catalog_number);


--
-- Name: idx_items_inventory_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_items_inventory_number ON public.items USING btree (inventory_number);


--
-- Name: idx_items_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_items_location_id ON public.items USING btree (location_id);


--
-- Name: idx_items_search_vector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_items_search_vector ON public.items USING gin (search_vector);


--
-- Name: idx_items_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_items_type ON public.items USING btree (item_type);


--
-- Name: items items_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict KCXZdtJgnDBsLPU5sTBTJZOAgrY8iyDflWLau5AwuCcNIWj9FFPdFo5Fc2hGoAd

