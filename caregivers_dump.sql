--
-- PostgreSQL database dump
--

\restrict 4ELLYa6vVE4umVMN7pZuhhLrQHPVT7awgcPLVnDrx9yjBO7sbY4TGuwjLo3ZEyK

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

-- Started on 2025-11-24 11:40:39 +05

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

--
-- TOC entry 2 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16433)
-- Name: address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.address (
    member_user_id integer NOT NULL,
    house_number character varying(10),
    street character varying(255),
    town character varying(255)
);


ALTER TABLE public.address OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16475)
-- Name: appointment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment (
    appointment_id integer NOT NULL,
    caregiver_user_id integer,
    member_user_id integer,
    appointment_date date,
    appointment_time time without time zone,
    work_hours integer,
    status character varying(50)
);


ALTER TABLE public.appointment OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16474)
-- Name: appointment_appointment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_appointment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointment_appointment_id_seq OWNER TO postgres;

--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 224
-- Name: appointment_appointment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_appointment_id_seq OWNED BY public.appointment.appointment_id;


--
-- TOC entry 218 (class 1259 OID 16409)
-- Name: caregiver; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caregiver (
    caregiver_user_id integer NOT NULL,
    photo text,
    gender character varying(50),
    caregiving_type character varying(50),
    hourly_rate numeric(10,2)
);


ALTER TABLE public.caregiver OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16446)
-- Name: job; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job (
    job_id integer NOT NULL,
    member_user_id integer,
    required_caregiving_type character varying(50),
    other_requirements text,
    date_posted date
);


ALTER TABLE public.job OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16459)
-- Name: job_application; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_application (
    caregiver_user_id integer NOT NULL,
    job_id integer NOT NULL,
    date_applied date
);


ALTER TABLE public.job_application OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16445)
-- Name: job_job_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.job_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.job_job_id_seq OWNER TO postgres;

--
-- TOC entry 3764 (class 0 OID 0)
-- Dependencies: 221
-- Name: job_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.job_job_id_seq OWNED BY public.job.job_id;


--
-- TOC entry 219 (class 1259 OID 16421)
-- Name: member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.member (
    member_user_id integer NOT NULL,
    house_rules text,
    dependent_description text
);


ALTER TABLE public.member OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16399)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying(255) NOT NULL,
    given_name character varying(100) NOT NULL,
    surname character varying(100) NOT NULL,
    city character varying(100),
    phone_number character varying(20),
    profile_description text,
    password character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16398)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 3765 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 3579 (class 2604 OID 16478)
-- Name: appointment appointment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment ALTER COLUMN appointment_id SET DEFAULT nextval('public.appointment_appointment_id_seq'::regclass);


--
-- TOC entry 3578 (class 2604 OID 16449)
-- Name: job job_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job ALTER COLUMN job_id SET DEFAULT nextval('public.job_job_id_seq'::regclass);


--
-- TOC entry 3577 (class 2604 OID 16402)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 3751 (class 0 OID 16433)
-- Dependencies: 220
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.address (member_user_id, house_number, street, town) FROM stdin;
11	12A	Pushkin St	Almaty
12	5	Kabanbay Batyr	Astana
13	22	Abay Ave	Shymkent
14	7B	Kabanbay Batyr	Almaty
15	101	Saken St	Astana
16	4	Auezov St	Astana
17	8	Kabanbay Batyr	Almaty
18	55	Tulebayeva St	Astana
19	3	Zhibek Zholy	Almaty
20	9	Samat Ave	Astana
\.


--
-- TOC entry 3756 (class 0 OID 16475)
-- Dependencies: 225
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointment (appointment_id, caregiver_user_id, member_user_id, appointment_date, appointment_time, work_hours, status) FROM stdin;
1	1	11	2025-11-20	09:00:00	3	accepted
2	2	12	2025-11-19	10:00:00	4	accepted
3	3	13	2025-11-18	14:00:00	2	declined
4	4	14	2025-11-21	16:00:00	3	pending
5	5	15	2025-11-22	08:30:00	5	accepted
6	6	16	2025-11-23	11:00:00	2	accepted
7	7	17	2025-11-17	13:00:00	3	accepted
8	8	18	2025-11-16	09:30:00	4	declined
9	9	19	2025-11-15	15:00:00	2	accepted
10	10	20	2025-11-14	18:00:00	2	pending
\.


--
-- TOC entry 3749 (class 0 OID 16409)
-- Dependencies: 218
-- Data for Name: caregiver; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caregiver (caregiver_user_id, photo, gender, caregiving_type, hourly_rate) FROM stdin;
1	arman.jpg	Male	babysitter	8.50
2	dina.jpg	Female	elderly	12.00
3	bek.jpg	Male	playmate	9.75
4	aliya.jpg	Female	babysitter	11.50
5	nazira.jpg	Female	elderly	15.00
6	samat.jpg	Male	playmate	7.00
7	gulnar.jpg	Female	babysitter	10.00
8	talgat.jpg	Male	elderly	9.00
9	mina.jpg	Female	playmate	13.50
10	erlan.jpg	Male	babysitter	14.00
\.


--
-- TOC entry 3753 (class 0 OID 16446)
-- Dependencies: 222
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job (job_id, member_user_id, required_caregiving_type, other_requirements, date_posted) FROM stdin;
1	11	babysitter	Looking for patient babysitter; evening shifts; CPR preferred	2025-11-01
2	12	elderly	Must assist with medication; No pets. Requires patience	2025-10-25
3	13	playmate	Creative play and arts, experience with 4yo	2025-11-05
4	14	babysitter	Weekends only, driver license preferred	2025-10-30
5	15	elderly	Mobility assistance; candidate should be kind and respectful	2025-11-10
6	16	babysitter	Occasional babysitting; trustworthy; light house chores ok	2025-11-12
7	17	playmate	Music and arts background desired	2025-11-08
8	18	elderly	Experience with dementia care; must be soft-spoken and calm	2025-11-02
9	11	babysitter	Night shift needed sometimes; newborn care experience	2025-11-14
10	19	babysitter	Part-time, flexible hours; No smoking in the house	2025-11-15
\.


--
-- TOC entry 3754 (class 0 OID 16459)
-- Dependencies: 223
-- Data for Name: job_application; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_application (caregiver_user_id, job_id, date_applied) FROM stdin;
1	1	2025-11-02
2	2	2025-10-26
3	3	2025-11-06
4	4	2025-10-31
5	5	2025-11-11
6	6	2025-11-13
7	7	2025-11-09
8	8	2025-11-03
9	9	2025-11-15
10	10	2025-11-16
\.


--
-- TOC entry 3750 (class 0 OID 16421)
-- Dependencies: 219
-- Data for Name: member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.member (member_user_id, house_rules, dependent_description) FROM stdin;
11	Keep toys tidy. No bed-sharing for infants.	3-year-old daughter, naps at 2pm
12	No pets.	78-year-old mother, needs assistance with daily activities
13	No screen time after 8pm.	4-year-old, loves drawing
14	No smoking in the house.	6-year-old, needs pick-up from school
15	Please be punctual. Light cooking allowed.	Father with mobility issues
16	Keep shoes in the entryway.	2 children, ages 2 and 5
17	Encourage creative play.	4-year-old with interest in music
18	Medication schedule must be followed.	Elderly with mild dementia
19	No smoking. No strangers in the house.	Baby, newborn
20	No pets.	Looking for flexible hourly childcare
\.


--
-- TOC entry 3748 (class 0 OID 16399)
-- Dependencies: 217
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, email, given_name, surname, city, phone_number, profile_description, password) FROM stdin;
1	arman@example.com	Arman	Armanov	Astana	77001234567	Experienced babysitter, CPR certified	pass1
2	dina@example.com	Dina	Suleyman	Almaty	77007654321	Caregiver for elderly with 5 years experience	pass2
3	bek@example.com	Bek	Nurpeiis	Astana	77005556666	Playmate for children, art activities	pass3
4	aliya@example.com	Aliya	Tulegen	Shymkent	77003332222	Babysitter, evening shifts available	pass4
5	nazira@example.com	Nazira	Kassym	Almaty	77004445555	Elder care specialist, former nurse	pass5
6	samat@example.com	Samat	Ibragim	Astana	77009998888	Friendly playmate, sports and games	pass6
7	gulnar@example.com	Gulnar	Azat	Almaty	77002223333	Babysitter, experience with toddlers	pass7
8	talgat@example.com	Talgat	Oraz	Astana	77001112222	Elder care and companionship	pass8
9	mina@example.com	Mina	Sadyk	Almaty	77006667777	Playmate with music background	pass9
10	erlan@example.com	Erlan	Zhaxybay	Astana	77008889999	Babysitter & tutor for school kids	pass10
11	amina@example.com	Amina	Aminova	Almaty	77110001111	Mother of two, looking for babysitter	memb1
12	marat@example.com	Marat	Kozhabayev	Astana	77110002222	Looking for elderly caregiver. No pets.	memb2
13	alya@example.com	Alya	Bayanova	Shymkent	77110003333	Need part-time playmate for 4yo	memb3
14	nurzhan@example.com	Nurzhan	Otegen	Almaty	77110004444	Single parent, needs weekend babysitter	memb4
15	saniya@example.com	Saniya	Kadyrova	Astana	77110005555	Requires elderly care for father with mobility issues	memb5
16	olat@example.com	Olat	Imangali	Astana	77110006666	Looking for occasional babysitter	memb6
17	bota@example.com	Bota	Zholdas	Almaty	77110007777	Requires playmate for creative activities	memb7
18	serik@example.com	Serik	Beksultan	Astana	77110008888	Need caregiver for elderly with dementia	memb8
19	laila@example.com	Laila	Qusain	Almaty	77110009999	House rules: No smoking	memb9
20	adil@example.com	Adil	Sultanov	Astana	77110010000	House rules: No pets. Need flexible hours	memb10
\.


--
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 224
-- Name: appointment_appointment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_appointment_id_seq', 1, false);


--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 221
-- Name: job_job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_job_id_seq', 1, false);


--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 216
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- TOC entry 3589 (class 2606 OID 16439)
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (member_user_id);


--
-- TOC entry 3595 (class 2606 OID 16480)
-- Name: appointment appointment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (appointment_id);


--
-- TOC entry 3585 (class 2606 OID 16415)
-- Name: caregiver caregiver_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregiver
    ADD CONSTRAINT caregiver_pkey PRIMARY KEY (caregiver_user_id);


--
-- TOC entry 3593 (class 2606 OID 16463)
-- Name: job_application job_application_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_application
    ADD CONSTRAINT job_application_pkey PRIMARY KEY (caregiver_user_id, job_id);


--
-- TOC entry 3591 (class 2606 OID 16453)
-- Name: job job_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_pkey PRIMARY KEY (job_id);


--
-- TOC entry 3587 (class 2606 OID 16427)
-- Name: member member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (member_user_id);


--
-- TOC entry 3581 (class 2606 OID 16408)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3583 (class 2606 OID 16406)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3598 (class 2606 OID 16440)
-- Name: address address_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.member(member_user_id) ON DELETE CASCADE;


--
-- TOC entry 3602 (class 2606 OID 16481)
-- Name: appointment appointment_caregiver_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_caregiver_user_id_fkey FOREIGN KEY (caregiver_user_id) REFERENCES public.caregiver(caregiver_user_id) ON DELETE CASCADE;


--
-- TOC entry 3603 (class 2606 OID 16486)
-- Name: appointment appointment_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.member(member_user_id) ON DELETE CASCADE;


--
-- TOC entry 3596 (class 2606 OID 16416)
-- Name: caregiver caregiver_caregiver_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregiver
    ADD CONSTRAINT caregiver_caregiver_user_id_fkey FOREIGN KEY (caregiver_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3600 (class 2606 OID 16464)
-- Name: job_application job_application_caregiver_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_application
    ADD CONSTRAINT job_application_caregiver_user_id_fkey FOREIGN KEY (caregiver_user_id) REFERENCES public.caregiver(caregiver_user_id) ON DELETE CASCADE;


--
-- TOC entry 3601 (class 2606 OID 16469)
-- Name: job_application job_application_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_application
    ADD CONSTRAINT job_application_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.job(job_id) ON DELETE CASCADE;


--
-- TOC entry 3599 (class 2606 OID 16454)
-- Name: job job_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.member(member_user_id) ON DELETE CASCADE;


--
-- TOC entry 3597 (class 2606 OID 16428)
-- Name: member member_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member
    ADD CONSTRAINT member_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


-- Completed on 2025-11-24 11:40:40 +05

--
-- PostgreSQL database dump complete
--

\unrestrict 4ELLYa6vVE4umVMN7pZuhhLrQHPVT7awgcPLVnDrx9yjBO7sbY4TGuwjLo3ZEyK

