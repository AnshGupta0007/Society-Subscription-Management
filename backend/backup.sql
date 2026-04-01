--
-- PostgreSQL database dump
--

\restrict AL33Pvlzn4GNKOVwYcyDrZLTgDnEg09fSjOk4ttzb6QMRpdL1Gqz9C4vqfMpv7g

-- Dumped from database version 18.3 (Ubuntu 18.3-1.pgdg24.04+1)
-- Dumped by pg_dump version 18.3 (Ubuntu 18.3-1.pgdg24.04+1)

-- Started on 2026-04-01 10:24:32 IST

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
-- TOC entry 2 (class 3079 OID 24660)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 3546 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 869 (class 1247 OID 24643)
-- Name: flat_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.flat_type_enum AS ENUM (
    '1BHK',
    '2BHK',
    '3BHK'
);


ALTER TYPE public.flat_type_enum OWNER TO postgres;

--
-- TOC entry 881 (class 1247 OID 24720)
-- Name: notification_target_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.notification_target_enum AS ENUM (
    'all',
    'flat',
    'type'
);


ALTER TYPE public.notification_target_enum OWNER TO postgres;

--
-- TOC entry 878 (class 1247 OID 24712)
-- Name: payment_mode_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_mode_enum AS ENUM (
    'cash',
    'upi',
    'online'
);


ALTER TYPE public.payment_mode_enum OWNER TO postgres;

--
-- TOC entry 875 (class 1247 OID 24705)
-- Name: subscription_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.subscription_status_enum AS ENUM (
    'pending',
    'paid',
    'waived'
);


ALTER TYPE public.subscription_status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 24687)
-- Name: flats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flats (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    flat_number character varying NOT NULL,
    flat_type public.flat_type_enum NOT NULL,
    owner_name character varying,
    owner_email character varying,
    owner_phone character varying,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_read_notifications_at timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone,
    password character varying(255) DEFAULT 'mypassword'::character varying NOT NULL
);


ALTER TABLE public.flats OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24742)
-- Name: monthly_subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monthly_subscriptions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    flat_id uuid,
    plan_id uuid,
    month date NOT NULL,
    amount_due numeric(10,2),
    status public.subscription_status_enum DEFAULT 'pending'::public.subscription_status_enum,
    due_date date
);


ALTER TABLE public.monthly_subscriptions OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 49366)
-- Name: notification_device_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_device_tokens (
    id integer NOT NULL,
    flat_id uuid NOT NULL,
    fcm_token text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.notification_device_tokens OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 49365)
-- Name: notification_device_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_device_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notification_device_tokens_id_seq OWNER TO postgres;

--
-- TOC entry 3547 (class 0 OID 0)
-- Dependencies: 225
-- Name: notification_device_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_device_tokens_id_seq OWNED BY public.notification_device_tokens.id;


--
-- TOC entry 224 (class 1259 OID 24786)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying,
    message text,
    target_type public.notification_target_enum,
    target_id uuid,
    sent_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    sent_by uuid
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24761)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    subscription_id uuid,
    flat_id uuid,
    amount_paid numeric(10,2),
    payment_mode public.payment_mode_enum,
    transaction_ref character varying,
    paid_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    recorded_by uuid,
    receipt_url character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24727)
-- Name: subscription_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscription_plans (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    flat_type public.flat_type_enum NOT NULL,
    monthly_amount numeric(10,2) NOT NULL,
    effective_from date NOT NULL,
    effective_to date,
    created_by uuid
);


ALTER TABLE public.subscription_plans OWNER TO postgres;

--
-- TOC entry 3361 (class 2604 OID 49369)
-- Name: notification_device_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_device_tokens ALTER COLUMN id SET DEFAULT nextval('public.notification_device_tokens_id_seq'::regclass);


--
-- TOC entry 3534 (class 0 OID 24687)
-- Dependencies: 220
-- Data for Name: flats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flats (id, flat_number, flat_type, owner_name, owner_email, owner_phone, is_active, created_at, last_read_notifications_at, password) FROM stdin;
151c8ee1-5cd0-4c09-8789-22feb85a3ad7	X1	1BHK	sraj	sraj@gmail.com	9499494949	t	2026-03-24 12:26:53.891925	1970-01-01 00:00:00	$2b$10$QsOrKYep14gBPK2qawmzje/mB4iyd3MdOAw10S2CVFsHfH6XNh7oe
594260a6-e5f8-4d6f-ac02-9c4253f1a16c	45678	1BHK	dfghjk	cvj@gmail.com	09876543	t	2025-03-01 00:00:00	1970-01-01 00:00:00	$2b$10$UdTGFPJlSpHywF4azgxmLe9o.8bJ3dBU/o1BPBmK9LGEbRVndLwn2
ba955be4-4880-4ff1-8eb4-15969742f583	A109	3BHK	Anushka Pathak	anushkapathak304@gmail.com	8924011568	t	2025-06-01 00:00:00	1970-01-01 00:00:00	$2b$10$ESibRpDa1a7aCs2uRCC9TuEbmoFMsH.YzN3zVTjjGeGFbhRI1FfsK
b05c9149-a3ba-4d54-a36a-2f2b41fc039d	a122	1BHK	san	anshguptasjs@gmail.com	98765r	t	2025-08-01 00:00:00	2026-03-23 12:42:48.251428	$2b$10$Lovsf09a5JviSNkAyw4U2uuRwKxwzrRI/Ij2H93ez4X8PRfyM6wOC
8d391667-a901-48e7-b767-4135923ca0cd	C30	3BHK	Meera	meera@mail.com	900000007	t	2025-02-01 00:00:00	1970-01-01 00:00:00	$2b$10$1YdTEHyp9hnfZjH4zdDTE.8397dHgrEkZIrasVJ425r5Qwi7NoElW
f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	D401	2BHK	Rohit	rohit@mail.com	900000009	t	2025-04-01 00:00:00	1970-01-01 00:00:00	$2b$10$uDrKFS71byWY2I3shOmN6.4HfN0wmyzjgO7izr.pBW8rIRBU3/Vg2
2d4a274c-cc6b-4b55-b096-493db96d4077	d-555	1BHK	asdfghj	asdfghj@gmail.com	32147896541	t	2025-05-01 00:00:00	1970-01-01 00:00:00	$2b$10$PoEyv4BMFo3KL8FH4DIxB.gCGAlTdCE0OkN95Mo4.3q3IaRM5sfsC
dd9373e2-44bb-421a-b663-c3efda0303b3	ew	1BHK	VBJ	GHJK@JJ.COM	098	t	2025-09-01 00:00:00	1970-01-01 00:00:00	$2b$10$EdgVis4dbIvuqnQkxH9cte/SWVZklPSEbPL96j1Qd/uJYyLEw5jxK
9467acc1-a6f6-420e-a5b6-ea0b77f37d0a	NE1	1BHK	NEW1	NEW1@GMAIL.COM	99	t	2025-11-01 00:00:00	1970-01-01 00:00:00	$2b$10$mPv0XT5HkwoSqVO5f.ButOS.kiKtLNbvrtdhALymXJoEhiuguG3lu
63c3a400-3195-4682-81a8-86426466ae8f	T1	2BHK	Test	test@gmail.com	98765432	t	2026-03-26 11:12:16.064514	1970-01-01 00:00:00	$2b$10$hsIX3GXyzDGI573dqOZ2iOsGsRtV.4ouh2sEkM7U5qkDol/UVHkL2
5483cc22-51a7-4852-bc84-03c088a5ffa0	A123	1BHK	Ansh Gupta	ansh.gupta@tothenew.com	987654321	t	2026-03-24 13:54:00.359569	2026-03-31 01:00:42.77288	$2b$10$JP9UQqxZ/Aewh3BjHSBRTeK543yrSvSVwvbcON4NAVWU62.abSQ.y
c1515c1e-f818-4b6d-abb8-04d9d42f7290	102	2BHK	Priya Singh	priya@gmail.com	9876543212	t	2024-10-01 00:00:00	1970-01-01 00:00:00	$2b$10$zEfNKf3QebE6POjrfiUzXObztdeautxvr5H2gqsDsv4LX5mIixvUe
e7fa296e-2338-4c54-b841-e586f6ef2d0e	103	3BHK	Amit Patel	amit@gmail.com	9876543213	t	2024-12-01 00:00:00	1970-01-01 00:00:00	$2b$10$bSwjWfKo3chwXunPVPncZOugPVtQ3vuoW4qniuS4ceckvmBJjyVb.
\.


--
-- TOC entry 3536 (class 0 OID 24742)
-- Dependencies: 222
-- Data for Name: monthly_subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monthly_subscriptions (id, flat_id, plan_id, month, amount_due, status, due_date) FROM stdin;
3dc53ac5-949f-48c7-8264-9eeb7cf1b354	2d4a274c-cc6b-4b55-b096-493db96d4077	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-03-01	5000.00	pending	2026-03-23
b9b54a2a-6756-426a-b61b-1882bcd8f8b7	b05c9149-a3ba-4d54-a36a-2f2b41fc039d	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-03-01	50000.00	paid	2026-03-23
8500d8bf-a87c-44b0-a4d9-994130284731	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-10-01	8000.00	paid	2025-10-05
d2f2fc34-73e8-4491-b4a5-3c6c62a59816	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-11-01	8000.00	paid	2025-11-05
488a552f-fe47-4f15-b1ee-72555af31200	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2025-10-01	12000.00	paid	2025-10-05
aea4da96-efba-47e0-ba12-df9f29209e3f	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2025-11-01	12000.00	pending	2025-11-05
244aa514-ce51-4a3d-b2f1-1291085d5210	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2025-12-01	12000.00	pending	2025-12-05
2b160391-8e8f-4212-ba54-c75c2049d7b6	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2026-01-01	12000.00	paid	2026-01-05
d8a38521-427a-4271-85f7-b09ee4adc2f9	8d391667-a901-48e7-b767-4135923ca0cd	f831d83d-0275-48e3-855b-1e741b45283d	2025-10-01	12000.00	pending	2025-10-05
3b1d371c-6d4a-45b1-9ffd-e4484a058dfe	8d391667-a901-48e7-b767-4135923ca0cd	f831d83d-0275-48e3-855b-1e741b45283d	2025-11-01	12000.00	paid	2025-11-05
163d0ff4-783d-4e54-916b-4a3640667b50	8d391667-a901-48e7-b767-4135923ca0cd	f831d83d-0275-48e3-855b-1e741b45283d	2025-12-01	12000.00	pending	2025-12-05
bf5b3270-e901-4e08-80c7-c617168f8bf6	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-10-01	8000.00	paid	2025-10-05
d8115e88-0ae0-45ed-8633-e1827199ade4	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-11-01	8000.00	paid	2025-11-05
171a5767-db89-4969-9eb8-9559ec9173f3	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-12-01	8000.00	pending	2025-12-05
6a6b645d-571e-40e4-87cd-174f9be53bb5	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	f35a7271-5700-4aeb-9d1c-f679938fb531	2026-01-01	8000.00	pending	2026-01-05
e6db5ffe-e07f-454e-aae9-35ec01e94313	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-11-01	50000.00	pending	2026-03-23
31a2ce52-4c4b-411c-b690-ee326e7f2bd8	b05c9149-a3ba-4d54-a36a-2f2b41fc039d	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-11-01	50000.00	pending	2026-03-23
748396fa-5f4b-41aa-91af-466d0e675167	9467acc1-a6f6-420e-a5b6-ea0b77f37d0a	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-11-01	50000.00	pending	2026-03-23
e5f6c7a0-3215-4ec1-8711-28f62d4c6f67	ba955be4-4880-4ff1-8eb4-15969742f583	f831d83d-0275-48e3-855b-1e741b45283d	2025-11-01	12000.00	pending	2026-03-23
4e868ba8-2290-42a1-a4d4-2d2ed572a4f8	2d4a274c-cc6b-4b55-b096-493db96d4077	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-11-01	50000.00	pending	2026-03-23
7000dacc-9005-4cf7-8873-ee36d88e5941	dd9373e2-44bb-421a-b663-c3efda0303b3	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-11-01	50000.00	pending	2026-03-23
a23ac478-550f-4031-a872-585ab63f03ca	2d4a274c-cc6b-4b55-b096-493db96d4077	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-06-01	50000.00	pending	2026-03-23
54225b27-6a68-4d71-809f-83b64961735c	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-08-01	8000.00	pending	2026-03-23
6b285260-a1ce-4b17-b439-2df5cf619085	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2025-08-01	12000.00	pending	2026-03-23
80132b99-8147-4161-864c-4f0c01d90c1f	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-08-01	50000.00	pending	2026-03-23
d65ede71-a337-42e9-b85c-fb806e9182d6	ba955be4-4880-4ff1-8eb4-15969742f583	f831d83d-0275-48e3-855b-1e741b45283d	2025-08-01	12000.00	pending	2026-03-23
5c35ad1d-88dd-491f-8f01-5f09431af8ec	b05c9149-a3ba-4d54-a36a-2f2b41fc039d	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-08-01	50000.00	pending	2026-03-23
50469207-e4c1-40bf-98d1-bb4ba0cae941	8d391667-a901-48e7-b767-4135923ca0cd	f831d83d-0275-48e3-855b-1e741b45283d	2025-08-01	12000.00	pending	2026-03-23
406fca42-987c-40fb-8e19-bbdcad621d05	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-08-01	8000.00	pending	2026-03-23
b06f9113-5c39-47a9-b1de-1b9903efc564	2d4a274c-cc6b-4b55-b096-493db96d4077	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-08-01	50000.00	pending	2026-03-23
8083e6c3-c2d5-4d31-b41c-93ed7c707223	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2026-01-01	8000.00	paid	2026-01-05
5adac415-f1c8-451d-90c9-e449f047caee	8d391667-a901-48e7-b767-4135923ca0cd	f831d83d-0275-48e3-855b-1e741b45283d	2026-01-01	12000.00	paid	2026-03-23
4d85a687-b4a4-4e94-bef8-7fa5687f9f9e	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-09-01	8000.00	pending	2026-03-23
233e8525-b0ee-42e4-8fb5-6c94ec6d4ac2	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2025-09-01	12000.00	pending	2026-03-23
d09087ea-e675-4b0f-9bac-8faebcd45570	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-09-01	1000.00	pending	2026-03-23
2facc0e5-2f18-4709-8f28-4262e7d47ad2	ba955be4-4880-4ff1-8eb4-15969742f583	f831d83d-0275-48e3-855b-1e741b45283d	2025-09-01	12000.00	pending	2026-03-23
ed5374c8-cc60-4a78-89b2-cfea3be383c7	b05c9149-a3ba-4d54-a36a-2f2b41fc039d	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-09-01	1000.00	pending	2026-03-23
ad0c45d7-6c55-4068-8b32-3a282fbb26ea	8d391667-a901-48e7-b767-4135923ca0cd	f831d83d-0275-48e3-855b-1e741b45283d	2025-09-01	12000.00	pending	2026-03-23
2e243adb-f619-46c2-aaa8-dbd0023b6a16	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-09-01	8000.00	pending	2026-03-23
486c34d7-8700-4a78-ae81-9c65d4d499df	2d4a274c-cc6b-4b55-b096-493db96d4077	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-09-01	1000.00	pending	2026-03-23
afa69416-539d-49b8-b6fa-e8702b6fa155	dd9373e2-44bb-421a-b663-c3efda0303b3	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-09-01	1000.00	pending	2026-03-23
472901cb-291f-4c04-a154-9e783bbc5cca	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2024-10-01	8000.00	pending	2026-03-23
0e37b91c-c993-46c4-be71-5e54d799259f	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2024-11-01	8000.00	pending	2026-03-23
0b70b190-73ea-4add-b2a3-a370039713f7	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2024-12-01	8000.00	pending	2026-03-23
c302328e-820d-4432-b9db-f39a2ddc4c82	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2024-12-01	12000.00	pending	2026-03-23
7690b267-f8d1-49da-a49b-5c6c7547898d	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2026-02-01	8000.00	paid	2026-02-05
f56047c0-f911-4d2f-9f1a-49cc8e3e5935	151c8ee1-5cd0-4c09-8789-22feb85a3ad7	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-03-01	2000.00	pending	2026-03-24
5afb0ea6-d1e2-4fdb-a088-7b229ac99683	8d391667-a901-48e7-b767-4135923ca0cd	f831d83d-0275-48e3-855b-1e741b45283d	2026-02-01	12000.00	paid	2026-02-05
5adcef71-b090-4be3-a8bb-02f22a041c18	5483cc22-51a7-4852-bc84-03c088a5ffa0	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-03-01	2000.00	paid	2026-03-24
dcd04989-f988-4e74-b414-384f518aef3f	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-12-01	8000.00	paid	2025-12-05
95368676-02ed-4f94-ac20-49ee0101bf6b	63c3a400-3195-4682-81a8-86426466ae8f	f35a7271-5700-4aeb-9d1c-f679938fb531	2026-03-01	8000.00	pending	2026-03-26
10394642-a92c-42b4-816f-c4becaa9c031	c1515c1e-f818-4b6d-abb8-04d9d42f7290	d8b677d1-5441-4970-bbd4-50899d587ff8	2026-03-01	8000.00	paid	2026-03-11
5f15e2bf-5c73-43a2-9f00-05a34aacffe1	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	f35a7271-5700-4aeb-9d1c-f679938fb531	2026-02-01	8000.00	pending	2026-03-23
51e07932-fe3f-4295-9735-57a319910425	9467acc1-a6f6-420e-a5b6-ea0b77f37d0a	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-02-01	50000.00	pending	2026-03-23
08a5f784-3648-4383-a079-12ad2a81f03a	ba955be4-4880-4ff1-8eb4-15969742f583	f831d83d-0275-48e3-855b-1e741b45283d	2026-02-01	12000.00	pending	2026-03-23
f061235c-025e-4b4a-9301-74e548153596	dd9373e2-44bb-421a-b663-c3efda0303b3	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-03-01	50000.00	paid	2026-03-23
4212e419-bf21-410d-a21b-ba1bbf393caf	8d391667-a901-48e7-b767-4135923ca0cd	f831d83d-0275-48e3-855b-1e741b45283d	2026-03-01	12000.00	paid	2026-03-20
4b21126d-9fa0-486d-abd6-dc5e34ea9512	dd9373e2-44bb-421a-b663-c3efda0303b3	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-02-01	50000.00	pending	2026-03-23
e5d26362-764e-4540-b2ca-52736140effc	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-01-01	50000.00	pending	2026-03-23
bdfb2a39-f7bb-4a89-ab49-10db0f3c6926	9467acc1-a6f6-420e-a5b6-ea0b77f37d0a	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-01-01	50000.00	pending	2026-03-23
26cd2432-6e49-438f-9c30-201495279299	e7fa296e-2338-4c54-b841-e586f6ef2d0e	1f6f806a-7b8b-43c8-a361-f9d9cde44d5e	2026-03-01	12000.00	paid	2026-03-11
54b73be3-a9fc-4fc5-a65a-cca387cb8d0d	ba955be4-4880-4ff1-8eb4-15969742f583	f831d83d-0275-48e3-855b-1e741b45283d	2026-01-01	12000.00	pending	2026-03-23
ab8a9de9-ff80-40cf-90c8-d179c837d65c	2d4a274c-cc6b-4b55-b096-493db96d4077	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-01-01	50000.00	pending	2026-03-23
4527513b-f656-445a-86e0-5d249a06b9f1	dd9373e2-44bb-421a-b663-c3efda0303b3	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-01-01	50000.00	pending	2026-03-23
0ce9cdcb-9ab0-4191-9ea9-e16c0f82f859	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-12-01	50000.00	pending	2026-03-23
3700bce1-51ea-4905-adc8-f044523449fc	b05c9149-a3ba-4d54-a36a-2f2b41fc039d	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-12-01	50000.00	pending	2026-03-23
78885cfd-52b8-459e-bd8a-dc64f0aca901	9467acc1-a6f6-420e-a5b6-ea0b77f37d0a	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-12-01	50000.00	pending	2026-03-23
2ac5970e-f0ad-4152-af2e-234f2a84d7b5	ba955be4-4880-4ff1-8eb4-15969742f583	f831d83d-0275-48e3-855b-1e741b45283d	2025-12-01	12000.00	pending	2026-03-23
44c5e953-fe47-41aa-bb76-bd1e7c50afc2	2d4a274c-cc6b-4b55-b096-493db96d4077	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-12-01	50000.00	pending	2026-03-23
d3251572-5fe5-490e-866f-df2f8f0c6d7a	dd9373e2-44bb-421a-b663-c3efda0303b3	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-12-01	50000.00	pending	2026-03-23
8b973d8b-6999-47a0-a7e8-502fea3bd0d2	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-10-01	50000.00	pending	2026-03-23
2c3143dc-6b0b-442e-aeef-50b659b6e43f	ba955be4-4880-4ff1-8eb4-15969742f583	f831d83d-0275-48e3-855b-1e741b45283d	2025-10-01	12000.00	pending	2026-03-23
b3509345-e959-4233-accf-a60e1fba64a0	2d4a274c-cc6b-4b55-b096-493db96d4077	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-10-01	50000.00	pending	2026-03-23
00759731-6245-4c7b-9bd4-af08720db678	dd9373e2-44bb-421a-b663-c3efda0303b3	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-10-01	50000.00	pending	2026-03-23
23380d72-297a-437e-bac4-8a87960f0848	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-01-01	8000.00	pending	2026-03-23
7b27a561-6d6e-4d66-8986-ba418bd5689f	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2025-01-01	12000.00	pending	2026-03-23
553802d3-fb8c-4efb-9cc4-4f748b79ea4b	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-07-01	8000.00	pending	2026-03-23
5a0da85a-f00c-4c7d-9c47-26389f353908	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2025-07-01	12000.00	pending	2026-03-23
8b7ef91e-cd26-4952-ad0f-0783a2e5589a	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-07-01	50000.00	pending	2026-03-23
9198af94-2d07-49ff-8190-e02601662941	ba955be4-4880-4ff1-8eb4-15969742f583	f831d83d-0275-48e3-855b-1e741b45283d	2025-07-01	12000.00	pending	2026-03-23
781ef6f8-20f4-4d77-964c-ff74796e72c8	8d391667-a901-48e7-b767-4135923ca0cd	f831d83d-0275-48e3-855b-1e741b45283d	2025-07-01	12000.00	pending	2026-03-23
b2b89d18-1aca-4e21-8c18-8ef8cca2c1fc	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-07-01	8000.00	pending	2026-03-23
eec9cc91-fe29-4234-873e-6a7052814660	2d4a274c-cc6b-4b55-b096-493db96d4077	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-07-01	50000.00	pending	2026-03-23
9eb58b5b-3c19-4e26-be8c-e01bab80dec6	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-05-01	8000.00	pending	2026-03-23
2f25050a-c6ea-4127-9711-b2fa7c5f7040	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2025-05-01	12000.00	pending	2026-03-23
47a4d45a-6b64-47c5-b16f-fd8ec76f3a19	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-05-01	50000.00	pending	2026-03-23
91c4bb96-4399-4575-974f-116dae1f43e7	8d391667-a901-48e7-b767-4135923ca0cd	f831d83d-0275-48e3-855b-1e741b45283d	2025-05-01	12000.00	pending	2026-03-23
0b2487a1-1d83-4104-8d62-789f2186a47c	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-05-01	8000.00	pending	2026-03-23
e50d1cc6-31e0-4e6f-8609-169a63a2272e	2d4a274c-cc6b-4b55-b096-493db96d4077	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-05-01	50000.00	pending	2026-03-23
8850e739-94dd-4c54-aff6-a0df6c46837e	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-03-01	8000.00	pending	2026-03-23
ffff9173-4958-467e-adf6-45d7861869e9	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2025-03-01	12000.00	pending	2026-03-23
18a0e907-fdfe-4baa-b8eb-6f1d9ca0e529	8d391667-a901-48e7-b767-4135923ca0cd	f831d83d-0275-48e3-855b-1e741b45283d	2025-03-01	12000.00	pending	2026-03-23
ca2a1e14-028d-4eaa-8a30-e31b674deab5	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2025-02-01	12000.00	pending	2026-03-23
bbf0f23e-7b76-44f6-9962-2e589f05f97c	8d391667-a901-48e7-b767-4135923ca0cd	f831d83d-0275-48e3-855b-1e741b45283d	2025-02-01	12000.00	pending	2026-03-23
5f8f3af7-63d4-4d20-b0eb-ee22c3a54f4d	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-06-01	8000.00	pending	2026-03-23
f57cc9e1-c4e7-4488-b369-cdef9529f521	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2025-06-01	12000.00	pending	2026-03-23
b1a595e3-c343-4009-8db8-cd609714f416	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-06-01	50000.00	pending	2026-03-23
443079bb-a515-4aae-a985-08b5abcaa257	ba955be4-4880-4ff1-8eb4-15969742f583	f831d83d-0275-48e3-855b-1e741b45283d	2025-06-01	12000.00	pending	2026-03-23
345706b8-9aa7-4b66-8ea1-686ea46c10fd	8d391667-a901-48e7-b767-4135923ca0cd	f831d83d-0275-48e3-855b-1e741b45283d	2025-06-01	12000.00	pending	2026-03-23
c5c26b6c-3bda-4ac7-9b35-9992dc3f0618	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-06-01	8000.00	pending	2026-03-23
b9714d37-d838-4aa0-b2cf-8009316d180f	b05c9149-a3ba-4d54-a36a-2f2b41fc039d	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-02-01	50000.00	paid	2026-03-23
a63675bb-b901-416c-b676-474751a5825b	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-02-01	50000.00	paid	2026-03-23
7e75025d-5a60-4d96-b111-8fc3825b2600	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-03-01	50000.00	paid	2026-03-23
95fd3697-0729-4c73-a43d-083457260f44	b05c9149-a3ba-4d54-a36a-2f2b41fc039d	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-01-01	50000.00	paid	2026-03-23
647d2200-fc65-410b-8696-dbf5d7a3126e	2d4a274c-cc6b-4b55-b096-493db96d4077	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-02-01	50000.00	paid	2026-03-23
26d8c6a2-76c8-414a-930c-4e1ffd1cfe36	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-03-01	5000.00	pending	2026-03-20
714256fd-aff3-44aa-8682-acdb5d251aa6	9467acc1-a6f6-420e-a5b6-ea0b77f37d0a	4b813791-2eb7-4dde-b558-c3d05fb24238	2026-03-01	5000.00	paid	2026-03-20
aa00e34c-fa5c-4f63-babe-bca4f7b44899	ba955be4-4880-4ff1-8eb4-15969742f583	f831d83d-0275-48e3-855b-1e741b45283d	2026-03-01	12000.00	paid	2026-03-20
1c74158b-4e3a-46de-b435-f6985f866772	e7fa296e-2338-4c54-b841-e586f6ef2d0e	f831d83d-0275-48e3-855b-1e741b45283d	2026-02-01	12000.00	paid	2026-03-23
ee3ec977-5e86-4d6a-b973-ae26a93dfa34	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	f35a7271-5700-4aeb-9d1c-f679938fb531	2026-03-01	8000.00	paid	2026-03-20
ca4483b5-3bf4-4665-89a4-47b29a1e2697	b05c9149-a3ba-4d54-a36a-2f2b41fc039d	4b813791-2eb7-4dde-b558-c3d05fb24238	2025-10-01	50000.00	paid	2026-03-23
7e9a1d6d-7b7c-48cf-ab39-097bc141ac38	c1515c1e-f818-4b6d-abb8-04d9d42f7290	f35a7271-5700-4aeb-9d1c-f679938fb531	2025-02-01	8000.00	paid	2026-03-23
\.


--
-- TOC entry 3540 (class 0 OID 49366)
-- Dependencies: 226
-- Data for Name: notification_device_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_device_tokens (id, flat_id, fcm_token, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3538 (class 0 OID 24786)
-- Dependencies: 224
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, title, message, target_type, target_id, sent_at, sent_by) FROM stdin;
9e06c9f3-32aa-4ff7-9d04-770fe10086b5	Payment Reminder	Please pay March maintenance	all	\N	2026-03-12 16:41:15.69175	7b633092-c999-409e-8351-6dfddbcff4a9
657dfcf8-46f6-4c5a-b407-b77d5f40fa75	Pending Payment	Flat A102 payment pending	flat	4c675c2d-9487-458c-b4e1-06533807be70	2026-03-12 16:41:15.69175	7b633092-c999-409e-8351-6dfddbcff4a9
8ae1dc6c-1ca5-43b2-b5b3-1eba20ce69f0	Maintenance Update	Water supply maintenance tomorrow	all	\N	2026-03-12 16:41:15.69175	376bc884-af81-4fd9-80dc-1a22fee1d938
0aa15daa-b563-430b-893a-fc7fbec1f981	Security Notice	Gate closing time changed	all	\N	2026-03-12 16:41:15.69175	f26c136f-333a-470a-bb4e-b301b37249c2
d9526827-3079-4444-8386-ad88bacf8c71	Payment Due	B202 payment due	flat	b1f6d96e-9736-4da3-8d81-3e0f9d685d68	2026-03-12 16:41:15.69175	f26c136f-333a-470a-bb4e-b301b37249c2
50ba249c-520c-4eea-85e5-3d0f2cc4c57a	Festival Notice	Holi celebration meeting	all	\N	2026-03-12 16:41:15.69175	68151ebd-e1e7-41bc-849b-d37a89984d1a
696b0c46-7e73-4a35-b7ec-c9410303a4cc	Parking Update	New parking rules	all	\N	2026-03-12 16:41:15.69175	2b9a6b61-82d3-477f-acd8-d36330e0b8d9
7dfc9228-e9e1-4dca-8ed5-cf18852a8a9d	Reminder	C302 payment pending	flat	8d391667-a901-48e7-b767-4135923ca0cd	2026-03-12 16:41:15.69175	376bc884-af81-4fd9-80dc-1a22fee1d938
7c31e75f-2c47-43e7-a157-c71f9f5efdf4	Electricity Work	Power shutdown notice	all	\N	2026-03-12 16:41:15.69175	68151ebd-e1e7-41bc-849b-d37a89984d1a
3a0b8867-2bf9-4d51-9c5c-a8676f7f9ab4	Monthly Reminder	April subscription reminder	all	\N	2026-03-12 16:41:15.69175	7b633092-c999-409e-8351-6dfddbcff4a9
29332566-dbf9-469d-a829-cb84485da7e8	New Notification	Login fix krdo	all	\N	2026-03-20 12:21:34.072085	\N
0f584c2d-2c57-437b-974d-d1ec29675adf	kxkx	kx ka	all	\N	2026-03-20 12:22:07.067646	\N
8c951cf7-d382-48f5-848e-2b15cc1da73b	nw	hi	all	\N	2026-03-20 12:27:11.68634	\N
b6743090-56d4-4eaf-8d76-bd3fec53f034	nbv	n nmj	all	\N	2026-03-20 12:32:32.157153	\N
f0f4b95e-7046-46f2-b0bf-9604c06e4464	nnnn	nnnnnnnnnn	all	\N	2026-03-20 12:34:37.722042	\N
3c4a2998-3236-487a-bc7d-71c1aabfa780	mnb	bnk	all	\N	2026-03-20 14:45:19.401401	\N
e935ecda-c8d2-4a40-ae75-f4502e99e299	oyee raj	sunnn	flat	50d332dd-b7a2-4daf-9288-5c966090526f	2026-03-20 15:00:51.575101	\N
8cc0b9f6-1529-4e3c-ac09-5ca37549f914	raj	beta	all	\N	2026-03-20 15:04:45.417982	\N
9d4ed2e7-fa57-4200-a40f-00e168e9dac9	hi	raj	flat	50d332dd-b7a2-4daf-9288-5c966090526f	2026-03-20 15:05:00.881761	\N
74899a46-8909-46ed-b82b-20375ea11e55	kjn	nm	flat	50d332dd-b7a2-4daf-9288-5c966090526f	2026-03-20 15:08:10.13099	\N
50efd9f8-c0ff-40c1-a6f8-a2f3dd9c9ff8	,mn	nm	all	\N	2026-03-20 15:11:00.12503	\N
c8a2d754-9d6f-424b-ae44-72eec4dd4821	okjbnnb bjn jnjnnknjn	bn	flat	e7fa296e-2338-4c54-b841-e586f6ef2d0e	2026-03-20 15:11:15.009965	\N
ea80a900-935a-4b6b-913b-6d95f2b9e0e5	asdfghj	xcvbnm	flat	c36ccb82-9408-449f-b930-e0d5cc0162f5	2026-03-20 17:09:15.304034	\N
7ec277d4-944b-453b-9b81-5edcbeaea085	,nb	j	all	\N	2026-03-23 11:40:52.801614	\N
f4df3443-835b-4b8d-869a-4b641fc03e84	kj	jh	all	\N	2026-03-23 11:43:48.202409	\N
2f4af948-eefa-440e-9a55-3003989fad75	n	n	all	\N	2026-03-23 11:48:11.001284	\N
e2f032e3-dd50-49fe-8d01-28eb9c7116c2	j	nn	all	\N	2026-03-23 11:57:01.704567	\N
f279c347-b2b1-4037-8994-f76b677e0cf3	mn	vbn	all	\N	2026-03-23 12:12:27.941369	\N
760b4f47-3408-4a23-b8a8-959945f3f5b0	m	mnb	all	\N	2026-03-23 12:25:23.597128	\N
87fce5ed-146d-4f6a-8469-ef63c59eb54d	ansh	ash	all	\N	2026-03-23 12:29:51.727226	\N
60454262-838c-485e-82b8-9603b6b0be1e	khkhkj	jlkjlkjtffgg	all	\N	2026-03-23 16:25:59.992551	\N
cbbe736b-ea86-4e9e-b994-7d89f42727b9	gnm	n	flat	16977c8d-362b-4a41-98cf-991aadf6b98b	2026-03-24 11:39:19.048989	\N
c5d1f939-e1ff-4fef-bc9d-63dd06dbc55a	kjjhn	fffhgihhjb	flat	53bb88aa-d74f-45cc-be0e-da698c57dc48	2026-03-24 11:44:25.011097	\N
11a31688-064d-4e80-ace7-df6447a60dc7	Hi Ansh	Ansh TTN	flat	5483cc22-51a7-4852-bc84-03c088a5ffa0	2026-03-24 13:54:51.857619	\N
e9c4e386-7673-4f2f-abda-ca10c77d4b9f	fghj	fghj	flat	2d4a274c-cc6b-4b55-b096-493db96d4077	2026-03-26 01:12:14.605558	\N
\.


--
-- TOC entry 3537 (class 0 OID 24761)
-- Dependencies: 223
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, subscription_id, flat_id, amount_paid, payment_mode, transaction_ref, paid_at, recorded_by, receipt_url, created_at) FROM stdin;
27bfce3f-ae7a-4ee4-bf33-93a19bbff4ba	5afb0ea6-d1e2-4fdb-a088-7b229ac99683	8d391667-a901-48e7-b767-4135923ca0cd	12000.00	upi	ertyu	2026-03-24 00:00:00	\N	\N	2026-03-24 13:44:26.8623
78a403f5-d516-4f19-8b02-23c0e8265746	5adcef71-b090-4be3-a8bb-02f22a041c18	5483cc22-51a7-4852-bc84-03c088a5ffa0	2000.00	upi	Payment 	2026-03-24 00:00:00	\N	\N	2026-03-24 13:54:22.338816
a954037d-946a-400c-93c6-8b0c97e34763	7e75025d-5a60-4d96-b111-8fc3825b2600	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	50000.00	cash	\N	2026-03-24 00:00:00	\N	\N	2026-03-24 14:14:11.11011
467b059f-a5cb-4bde-b63c-0f5bad42e842	7e9a1d6d-7b7c-48cf-ab39-097bc141ac38	c1515c1e-f818-4b6d-abb8-04d9d42f7290	8000.00	cash	\N	2026-03-24 00:00:00	\N	\N	2026-03-24 15:06:45.425396
02a80ca8-d435-499a-a984-a84ea05a46bd	dcd04989-f988-4e74-b414-384f518aef3f	c1515c1e-f818-4b6d-abb8-04d9d42f7290	8000.00	upi	\N	2026-03-24 00:00:00	\N	\N	2026-03-24 15:11:17.015382
196f55ed-4cdf-400a-924b-834acf59fa12	b9b54a2a-6756-426a-b61b-1882bcd8f8b7	b05c9149-a3ba-4d54-a36a-2f2b41fc039d	50000.00	upi	TXN-1774246219555	2026-03-03 17:07:00	\N	receipt_TXN-1774246219555.pdf	2026-03-03 17:07:00
b3147604-4db7-4fcc-9eb2-373b58f33ee0	8500d8bf-a87c-44b0-a4d9-994130284731	c1515c1e-f818-4b6d-abb8-04d9d42f7290	8000.00	cash	TXN-1677BAE0	2025-10-03 10:58:00	\N	\N	2025-10-03 10:58:00
c6c792b4-6817-46c7-ad00-c6f8882bd24c	d2f2fc34-73e8-4491-b4a5-3c6c62a59816	c1515c1e-f818-4b6d-abb8-04d9d42f7290	8000.00	online	TXN-8967EF6B	2025-11-09 16:53:00	\N	\N	2025-11-09 16:53:00
f26d5a24-8113-40c1-9040-007557c36d6a	488a552f-fe47-4f15-b1ee-72555af31200	e7fa296e-2338-4c54-b841-e586f6ef2d0e	12000.00	cash	TXN-20B80C96	2025-10-09 01:00:00	\N	\N	2025-10-09 01:00:00
bfe7c3a0-a51a-451e-8236-824f03bb8daa	2b160391-8e8f-4212-ba54-c75c2049d7b6	e7fa296e-2338-4c54-b841-e586f6ef2d0e	12000.00	cash	TXN-1B6EB259	2026-01-17 22:37:00	\N	\N	2026-01-17 22:37:00
7dc6ccda-b05e-4625-9eb7-ecf1da19aede	3b1d371c-6d4a-45b1-9ffd-e4484a058dfe	8d391667-a901-48e7-b767-4135923ca0cd	12000.00	online	TXN-D762CB45	2025-11-24 22:54:00	\N	\N	2025-11-24 22:54:00
a1a59fd5-f69e-4226-9291-fc7b0a810055	bf5b3270-e901-4e08-80c7-c617168f8bf6	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	8000.00	cash	TXN-5C2BE23D	2025-10-21 18:31:00	\N	\N	2025-10-21 18:31:00
2e53f594-3ad4-49e9-987c-f2f573ad880a	d8115e88-0ae0-45ed-8633-e1827199ade4	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	8000.00	online	TXN-84707DB5	2025-11-13 11:19:00	\N	\N	2025-11-13 11:19:00
febbda8f-b1f7-4b3a-a5b5-c80fa1221bb9	10394642-a92c-42b4-816f-c4becaa9c031	c1515c1e-f818-4b6d-abb8-04d9d42f7290	8000.00	cash	\N	2026-03-11 19:54:00	\N	\N	2026-03-11 19:54:00
83c1ba84-1095-4ab7-a799-d5cb53b07aab	f061235c-025e-4b4a-9301-74e548153596	dd9373e2-44bb-421a-b663-c3efda0303b3	50000.00	cash	\N	2026-03-22 21:27:00	\N	\N	2026-03-22 21:27:00
6b770773-27cd-4741-bbc0-8aa4ec5fceb6	4212e419-bf21-410d-a21b-ba1bbf393caf	8d391667-a901-48e7-b767-4135923ca0cd	12000.00	cash	\N	2026-03-03 15:38:00	\N	\N	2026-03-03 15:38:00
65760ffc-c8c5-4c78-bd30-cb822c0170e3	26cd2432-6e49-438f-9c30-201495279299	e7fa296e-2338-4c54-b841-e586f6ef2d0e	12000.00	cash	\N	2026-03-15 06:08:00	\N	\N	2026-03-15 06:08:00
01626049-99e3-49a5-80c8-cc1ec07589fb	714256fd-aff3-44aa-8682-acdb5d251aa6	9467acc1-a6f6-420e-a5b6-ea0b77f37d0a	5000.00	online	TXN-1774007961738	2026-03-13 14:09:00	\N	receipt_TXN-1774007961738.pdf	2026-03-13 14:09:00
dadf2f10-7c96-4c1e-81f1-351e4ae2bd6d	aa00e34c-fa5c-4f63-babe-bca4f7b44899	ba955be4-4880-4ff1-8eb4-15969742f583	12000.00	cash	\N	2026-03-19 19:17:00	\N	\N	2026-03-19 19:17:00
b87e13c8-74fe-46d7-b40e-0f28cad61a25	8083e6c3-c2d5-4d31-b41c-93ed7c707223	c1515c1e-f818-4b6d-abb8-04d9d42f7290	8000.00	cash	\N	2026-03-23 00:00:00	\N	\N	2026-03-23 00:00:00
30d94b42-cc78-48e1-bd22-01974fe2f50f	5adac415-f1c8-451d-90c9-e449f047caee	8d391667-a901-48e7-b767-4135923ca0cd	12000.00	cash	\N	2026-03-23 00:00:00	\N	\N	2026-03-23 00:00:00
f6f0ce6d-3db1-4a0d-9ecd-21670fe51adb	b9714d37-d838-4aa0-b2cf-8009316d180f	b05c9149-a3ba-4d54-a36a-2f2b41fc039d	50000.00	cash	\N	2026-03-23 00:00:00	\N	\N	2026-03-23 00:00:00
6dd82294-35b0-46e4-b18c-0f52127ad28f	a63675bb-b901-416c-b676-474751a5825b	594260a6-e5f8-4d6f-ac02-9c4253f1a16c	50000.00	cash	\N	2026-03-23 00:00:00	\N	\N	2026-03-23 00:00:00
618f7a02-c399-40b2-bfd2-a4c9da32e7b6	95fd3697-0729-4c73-a43d-083457260f44	b05c9149-a3ba-4d54-a36a-2f2b41fc039d	50000.00	online	TXN-1774258349247	2026-03-23 15:02:29.256464	\N	receipt_TXN-1774258349247.pdf	2026-03-23 15:02:29.256464
6d3d4c51-5735-4e9c-bcd4-0306df8b494d	647d2200-fc65-410b-8696-dbf5d7a3126e	2d4a274c-cc6b-4b55-b096-493db96d4077	50000.00	cash	\N	2026-03-23 00:00:00	\N	\N	2026-03-23 00:00:00
f4715364-6153-4a29-9aa1-10003c94920c	7690b267-f8d1-49da-a49b-5c6c7547898d	c1515c1e-f818-4b6d-abb8-04d9d42f7290	8000.00	cash	\N	2026-03-23 00:00:00	\N	\N	2026-03-23 00:00:00
561aa597-c018-4d7e-9d31-7ebf8bfe4761	1c74158b-4e3a-46de-b435-f6985f866772	e7fa296e-2338-4c54-b841-e586f6ef2d0e	12000.00	cash	\N	2026-03-23 00:00:00	\N	\N	2026-03-23 00:00:00
c91daf2b-128a-49bc-a371-f48004e2a128	ee3ec977-5e86-4d6a-b973-ae26a93dfa34	f9afd9bd-c30b-4e2d-889f-aa464f74cb2a	8000.00	cash	\N	2026-03-23 00:00:00	\N	\N	2026-03-23 15:30:25.378982
62d48b70-07a9-4e4e-a713-46b30e451eab	ca4483b5-3bf4-4665-89a4-47b29a1e2697	b05c9149-a3ba-4d54-a36a-2f2b41fc039d	50000.00	cash	lmgear,glagmajy[jmgmG	2026-03-24 00:00:00	\N	\N	2026-03-24 10:37:01.450512
\.


--
-- TOC entry 3535 (class 0 OID 24727)
-- Dependencies: 221
-- Data for Name: subscription_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subscription_plans (id, flat_type, monthly_amount, effective_from, effective_to, created_by) FROM stdin;
c3527b29-0c39-4af7-92d0-0f6abd1adfd5	1BHK	1000.00	2025-01-01	\N	7b633092-c999-409e-8351-6dfddbcff4a9
97907aba-3991-4318-9eba-160153c1e396	2BHK	1500.00	2025-01-01	\N	376bc884-af81-4fd9-80dc-1a22fee1d938
187117dd-6210-4c0d-b75f-0c5aafd19f3e	3BHK	1800.00	2025-01-01	\N	f26c136f-333a-470a-bb4e-b301b37249c2
a2c1323d-e733-4c00-a052-8e4ac7fcf3ec	1BHK	1100.00	2025-02-01	\N	68151ebd-e1e7-41bc-849b-d37a89984d1a
23fdc43f-527e-4941-9428-b80c1c1b2354	2BHK	1600.00	2025-02-01	\N	2b9a6b61-82d3-477f-acd8-d36330e0b8d9
1f6f806a-7b8b-43c8-a361-f9d9cde44d5e	3BHK	1900.00	2025-02-01	\N	a63e0e7d-e726-43be-ae81-32e5f8c701a0
9ce98899-5528-474e-a400-6b6f42241dd1	2BHK	1700.00	2025-03-01	\N	09386ef1-9695-45ed-bf77-307b464b0128
23a25287-5227-41ec-8912-e8d7f2c5f58b	3BHK	2000.00	2025-03-01	\N	82f6d1ae-fb92-4787-a924-931f35f7fa5d
d8b677d1-5441-4970-bbd4-50899d587ff8	2BHK	1750.00	2025-04-01	\N	880ed9c4-aa55-46ad-92c5-5bcceb36281a
c7d17603-7b0a-44ab-bd30-73815977730c	1BHK	1200.00	2025-03-01	\N	761692d6-f3c1-4bb3-9378-f9e66896b488
f35a7271-5700-4aeb-9d1c-f679938fb531	2BHK	8000.00	2026-03-18	\N	\N
f831d83d-0275-48e3-855b-1e741b45283d	3BHK	12000.00	2026-03-18	\N	\N
4b813791-2eb7-4dde-b558-c3d05fb24238	1BHK	2000.00	2026-03-18	\N	\N
\.


--
-- TOC entry 3548 (class 0 OID 0)
-- Dependencies: 225
-- Name: notification_device_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_device_tokens_id_seq', 1, false);


--
-- TOC entry 3365 (class 2606 OID 24701)
-- Name: flats flats_flat_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flats
    ADD CONSTRAINT flats_flat_number_key UNIQUE (flat_number);


--
-- TOC entry 3367 (class 2606 OID 40994)
-- Name: flats flats_owner_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flats
    ADD CONSTRAINT flats_owner_email_key UNIQUE (owner_email);


--
-- TOC entry 3369 (class 2606 OID 24699)
-- Name: flats flats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flats
    ADD CONSTRAINT flats_pkey PRIMARY KEY (id);


--
-- TOC entry 3373 (class 2606 OID 24750)
-- Name: monthly_subscriptions monthly_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monthly_subscriptions
    ADD CONSTRAINT monthly_subscriptions_pkey PRIMARY KEY (id);


--
-- TOC entry 3379 (class 2606 OID 49382)
-- Name: notification_device_tokens notification_device_tokens_fcm_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_device_tokens
    ADD CONSTRAINT notification_device_tokens_fcm_token_key UNIQUE (fcm_token);


--
-- TOC entry 3381 (class 2606 OID 49380)
-- Name: notification_device_tokens notification_device_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_device_tokens
    ADD CONSTRAINT notification_device_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3377 (class 2606 OID 24795)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 3375 (class 2606 OID 24770)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- TOC entry 3371 (class 2606 OID 24736)
-- Name: subscription_plans subscription_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscription_plans
    ADD CONSTRAINT subscription_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 3382 (class 2606 OID 24751)
-- Name: monthly_subscriptions monthly_subscriptions_flat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monthly_subscriptions
    ADD CONSTRAINT monthly_subscriptions_flat_id_fkey FOREIGN KEY (flat_id) REFERENCES public.flats(id);


--
-- TOC entry 3383 (class 2606 OID 24756)
-- Name: monthly_subscriptions monthly_subscriptions_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monthly_subscriptions
    ADD CONSTRAINT monthly_subscriptions_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.subscription_plans(id);


--
-- TOC entry 3386 (class 2606 OID 49383)
-- Name: notification_device_tokens notification_device_tokens_flat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_device_tokens
    ADD CONSTRAINT notification_device_tokens_flat_id_fkey FOREIGN KEY (flat_id) REFERENCES public.flats(id) ON DELETE CASCADE;


--
-- TOC entry 3384 (class 2606 OID 24776)
-- Name: payments payments_flat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_flat_id_fkey FOREIGN KEY (flat_id) REFERENCES public.flats(id);


--
-- TOC entry 3385 (class 2606 OID 24771)
-- Name: payments payments_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.monthly_subscriptions(id);


-- Completed on 2026-04-01 10:24:33 IST

--
-- PostgreSQL database dump complete
--

\unrestrict AL33Pvlzn4GNKOVwYcyDrZLTgDnEg09fSjOk4ttzb6QMRpdL1Gqz9C4vqfMpv7g

