--
-- PostgreSQL database dump
--

\restrict Cp0mmhKsfzr1I6uF4yEYNXPDucD3rET2sKqhInRjSTNyEfIGT8AZ4NR37dF83K0

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.0

-- Started on 2026-02-03 18:39:52

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
-- TOC entry 235 (class 1255 OID 12256239)
-- Name: trg_mock_vahan_before_save(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_mock_vahan_before_save() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- force uppercase
    NEW.vehicle_number := UPPER(NEW.vehicle_number);
    NEW.vehicle_type   := UPPER(NEW.vehicle_type);

    -- auto update timestamp
    NEW.updated_at := NOW();

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_mock_vahan_before_save() OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 12256254)
-- Name: trg_parkingfield_before_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_parkingfield_before_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_parkingfield_before_update() OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 12256392)
-- Name: trg_pps_2w_before_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_pps_2w_before_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_pps_2w_before_update() OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 12256411)
-- Name: trg_pps_3w_before_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_pps_3w_before_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_pps_3w_before_update() OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 12256430)
-- Name: trg_pps_4w_before_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_pps_4w_before_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_pps_4w_before_update() OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 12256276)
-- Name: trg_staff_before_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_staff_before_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_staff_before_update() OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 12256355)
-- Name: trg_staff_logs_before_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_staff_logs_before_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_staff_logs_before_update() OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 12256321)
-- Name: trg_vehicle_session_before_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_vehicle_session_before_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_vehicle_session_before_update() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 223 (class 1259 OID 12256281)
-- Name: email_otps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_otps (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    otp character varying(10) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    expires_at timestamp without time zone NOT NULL,
    is_verified boolean DEFAULT false
);


ALTER TABLE public.email_otps OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 12256333)
-- Name: email_otps_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.email_otps ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.email_otps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 12256229)
-- Name: mock_vahan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mock_vahan (
    id integer NOT NULL,
    vehicle_number text NOT NULL,
    vehicle_type text NOT NULL,
    mobile_number text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.mock_vahan OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 12256228)
-- Name: mock_vahan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mock_vahan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mock_vahan_id_seq OWNER TO postgres;

--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 217
-- Name: mock_vahan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mock_vahan_id_seq OWNED BY public.mock_vahan.id;


--
-- TOC entry 230 (class 1259 OID 12256376)
-- Name: parking_payment_structure_2w; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parking_payment_structure_2w (
    id integer NOT NULL,
    fkparkingfield integer NOT NULL,
    min_pay numeric NOT NULL,
    per_hour_increment numeric NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.parking_payment_structure_2w OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 12256375)
-- Name: parking_payment_structure_2w_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parking_payment_structure_2w_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.parking_payment_structure_2w_id_seq OWNER TO postgres;

--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 229
-- Name: parking_payment_structure_2w_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parking_payment_structure_2w_id_seq OWNED BY public.parking_payment_structure_2w.id;


--
-- TOC entry 232 (class 1259 OID 12256395)
-- Name: parking_payment_structure_3w; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parking_payment_structure_3w (
    id integer NOT NULL,
    fkparkingfield integer NOT NULL,
    min_pay numeric NOT NULL,
    per_hour_increment numeric NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.parking_payment_structure_3w OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 12256394)
-- Name: parking_payment_structure_3w_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parking_payment_structure_3w_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.parking_payment_structure_3w_id_seq OWNER TO postgres;

--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 231
-- Name: parking_payment_structure_3w_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parking_payment_structure_3w_id_seq OWNED BY public.parking_payment_structure_3w.id;


--
-- TOC entry 234 (class 1259 OID 12256414)
-- Name: parking_payment_structure_4w; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parking_payment_structure_4w (
    id integer NOT NULL,
    fkparkingfield integer NOT NULL,
    min_pay numeric NOT NULL,
    per_hour_increment numeric NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.parking_payment_structure_4w OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 12256413)
-- Name: parking_payment_structure_4w_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parking_payment_structure_4w_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.parking_payment_structure_4w_id_seq OWNER TO postgres;

--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 233
-- Name: parking_payment_structure_4w_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parking_payment_structure_4w_id_seq OWNED BY public.parking_payment_structure_4w.id;


--
-- TOC entry 220 (class 1259 OID 12256244)
-- Name: parkingfield; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parkingfield (
    id integer NOT NULL,
    place_name text NOT NULL,
    address text NOT NULL,
    district text NOT NULL,
    state_union text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.parkingfield OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 12256243)
-- Name: parkingfield_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parkingfield_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.parkingfield_id_seq OWNER TO postgres;

--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 219
-- Name: parkingfield_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parkingfield_id_seq OWNED BY public.parkingfield.id;


--
-- TOC entry 222 (class 1259 OID 12256259)
-- Name: staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff (
    id integer NOT NULL,
    fkparkingfield integer NOT NULL,
    emailid text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    is_admin boolean DEFAULT false
);


ALTER TABLE public.staff OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 12256258)
-- Name: staff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_id_seq OWNER TO postgres;

--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 221
-- Name: staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_id_seq OWNED BY public.staff.id;


--
-- TOC entry 228 (class 1259 OID 12256338)
-- Name: staff_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff_logs (
    id integer NOT NULL,
    fkstaff integer NOT NULL,
    login_status boolean DEFAULT false NOT NULL,
    logout_status boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.staff_logs OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 12256337)
-- Name: staff_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_logs_id_seq OWNER TO postgres;

--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 227
-- Name: staff_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_logs_id_seq OWNED BY public.staff_logs.id;


--
-- TOC entry 225 (class 1259 OID 12256290)
-- Name: vehicle_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicle_session (
    id integer NOT NULL,
    fkparkingfield integer NOT NULL,
    fkmock_vahan integer NOT NULL,
    fkstaff integer NOT NULL,
    exit_otp text,
    entry_status boolean DEFAULT false NOT NULL,
    exit_status boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    is_black_listed boolean DEFAULT false,
    black_list_reason text,
    total_pay numeric DEFAULT 0,
    pay_type text,
    fkstaff_exit integer,
    exit_at timestamp without time zone
);


ALTER TABLE public.vehicle_session OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 12256289)
-- Name: vehicle_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vehicle_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vehicle_session_id_seq OWNER TO postgres;

--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 224
-- Name: vehicle_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vehicle_session_id_seq OWNED BY public.vehicle_session.id;


--
-- TOC entry 4790 (class 2604 OID 12256232)
-- Name: mock_vahan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mock_vahan ALTER COLUMN id SET DEFAULT nextval('public.mock_vahan_id_seq'::regclass);


--
-- TOC entry 4814 (class 2604 OID 12256379)
-- Name: parking_payment_structure_2w id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parking_payment_structure_2w ALTER COLUMN id SET DEFAULT nextval('public.parking_payment_structure_2w_id_seq'::regclass);


--
-- TOC entry 4817 (class 2604 OID 12256398)
-- Name: parking_payment_structure_3w id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parking_payment_structure_3w ALTER COLUMN id SET DEFAULT nextval('public.parking_payment_structure_3w_id_seq'::regclass);


--
-- TOC entry 4820 (class 2604 OID 12256417)
-- Name: parking_payment_structure_4w id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parking_payment_structure_4w ALTER COLUMN id SET DEFAULT nextval('public.parking_payment_structure_4w_id_seq'::regclass);


--
-- TOC entry 4793 (class 2604 OID 12256247)
-- Name: parkingfield id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parkingfield ALTER COLUMN id SET DEFAULT nextval('public.parkingfield_id_seq'::regclass);


--
-- TOC entry 4796 (class 2604 OID 12256262)
-- Name: staff id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff ALTER COLUMN id SET DEFAULT nextval('public.staff_id_seq'::regclass);


--
-- TOC entry 4809 (class 2604 OID 12256341)
-- Name: staff_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_logs ALTER COLUMN id SET DEFAULT nextval('public.staff_logs_id_seq'::regclass);


--
-- TOC entry 4802 (class 2604 OID 12256293)
-- Name: vehicle_session id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_session ALTER COLUMN id SET DEFAULT nextval('public.vehicle_session_id_seq'::regclass);


--
-- TOC entry 4836 (class 2606 OID 12256288)
-- Name: email_otps email_otps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_otps
    ADD CONSTRAINT email_otps_pkey PRIMARY KEY (id);


--
-- TOC entry 4826 (class 2606 OID 12256238)
-- Name: mock_vahan mock_vahan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mock_vahan
    ADD CONSTRAINT mock_vahan_pkey PRIMARY KEY (id);


--
-- TOC entry 4849 (class 2606 OID 12256385)
-- Name: parking_payment_structure_2w parking_payment_structure_2w_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parking_payment_structure_2w
    ADD CONSTRAINT parking_payment_structure_2w_pkey PRIMARY KEY (id);


--
-- TOC entry 4852 (class 2606 OID 12256404)
-- Name: parking_payment_structure_3w parking_payment_structure_3w_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parking_payment_structure_3w
    ADD CONSTRAINT parking_payment_structure_3w_pkey PRIMARY KEY (id);


--
-- TOC entry 4855 (class 2606 OID 12256423)
-- Name: parking_payment_structure_4w parking_payment_structure_4w_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parking_payment_structure_4w
    ADD CONSTRAINT parking_payment_structure_4w_pkey PRIMARY KEY (id);


--
-- TOC entry 4830 (class 2606 OID 12256253)
-- Name: parkingfield parkingfield_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parkingfield
    ADD CONSTRAINT parkingfield_pkey PRIMARY KEY (id);


--
-- TOC entry 4847 (class 2606 OID 12256347)
-- Name: staff_logs staff_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_logs
    ADD CONSTRAINT staff_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4834 (class 2606 OID 12256268)
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (id);


--
-- TOC entry 4843 (class 2606 OID 12256301)
-- Name: vehicle_session vehicle_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_session
    ADD CONSTRAINT vehicle_session_pkey PRIMARY KEY (id);


--
-- TOC entry 4823 (class 1259 OID 12256242)
-- Name: idx_mock_vahan_mobile_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mock_vahan_mobile_number ON public.mock_vahan USING btree (mobile_number);


--
-- TOC entry 4824 (class 1259 OID 12256241)
-- Name: idx_mock_vahan_vehicle_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_mock_vahan_vehicle_number ON public.mock_vahan USING btree (vehicle_number);


--
-- TOC entry 4827 (class 1259 OID 12256256)
-- Name: idx_parkingfield_district; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_parkingfield_district ON public.parkingfield USING btree (district);


--
-- TOC entry 4828 (class 1259 OID 12256257)
-- Name: idx_parkingfield_state_union; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_parkingfield_state_union ON public.parkingfield USING btree (state_union);


--
-- TOC entry 4831 (class 1259 OID 12256275)
-- Name: idx_staff_emailid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_staff_emailid ON public.staff USING btree (emailid);


--
-- TOC entry 4832 (class 1259 OID 12256274)
-- Name: idx_staff_fkparkingfield; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_staff_fkparkingfield ON public.staff USING btree (fkparkingfield);


--
-- TOC entry 4844 (class 1259 OID 12256353)
-- Name: idx_staff_logs_fkstaff; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_staff_logs_fkstaff ON public.staff_logs USING btree (fkstaff);


--
-- TOC entry 4845 (class 1259 OID 12256354)
-- Name: idx_staff_logs_login_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_staff_logs_login_status ON public.staff_logs USING btree (login_status, logout_status);


--
-- TOC entry 4837 (class 1259 OID 12256317)
-- Name: idx_vehicle_session_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_session_active ON public.vehicle_session USING btree (fkparkingfield, entry_status, exit_status);


--
-- TOC entry 4838 (class 1259 OID 12256320)
-- Name: idx_vehicle_session_exit_otp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_session_exit_otp ON public.vehicle_session USING btree (exit_otp) WHERE (exit_otp IS NOT NULL);


--
-- TOC entry 4839 (class 1259 OID 12256319)
-- Name: idx_vehicle_session_staff; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_session_staff ON public.vehicle_session USING btree (fkstaff);


--
-- TOC entry 4840 (class 1259 OID 12256332)
-- Name: idx_vehicle_session_staff_exit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_session_staff_exit ON public.vehicle_session USING btree (fkstaff_exit);


--
-- TOC entry 4841 (class 1259 OID 12256318)
-- Name: idx_vehicle_session_vehicle; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vehicle_session_vehicle ON public.vehicle_session USING btree (fkmock_vahan);


--
-- TOC entry 4850 (class 1259 OID 12256391)
-- Name: uniq_pps_2w_parkingfield; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_pps_2w_parkingfield ON public.parking_payment_structure_2w USING btree (fkparkingfield);


--
-- TOC entry 4853 (class 1259 OID 12256410)
-- Name: uniq_pps_3w_parkingfield; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_pps_3w_parkingfield ON public.parking_payment_structure_3w USING btree (fkparkingfield);


--
-- TOC entry 4856 (class 1259 OID 12256429)
-- Name: uniq_pps_4w_parkingfield; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_pps_4w_parkingfield ON public.parking_payment_structure_4w USING btree (fkparkingfield);


--
-- TOC entry 4866 (class 2620 OID 12256240)
-- Name: mock_vahan trg_mock_vahan_before_insert_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_mock_vahan_before_insert_update BEFORE INSERT OR UPDATE ON public.mock_vahan FOR EACH ROW EXECUTE FUNCTION public.trg_mock_vahan_before_save();


--
-- TOC entry 4867 (class 2620 OID 12256255)
-- Name: parkingfield trg_parkingfield_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_parkingfield_updated_at BEFORE UPDATE ON public.parkingfield FOR EACH ROW EXECUTE FUNCTION public.trg_parkingfield_before_update();


--
-- TOC entry 4871 (class 2620 OID 12256393)
-- Name: parking_payment_structure_2w trg_pps_2w_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_pps_2w_updated_at BEFORE UPDATE ON public.parking_payment_structure_2w FOR EACH ROW EXECUTE FUNCTION public.trg_pps_2w_before_update();


--
-- TOC entry 4872 (class 2620 OID 12256412)
-- Name: parking_payment_structure_3w trg_pps_3w_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_pps_3w_updated_at BEFORE UPDATE ON public.parking_payment_structure_3w FOR EACH ROW EXECUTE FUNCTION public.trg_pps_3w_before_update();


--
-- TOC entry 4873 (class 2620 OID 12256431)
-- Name: parking_payment_structure_4w trg_pps_4w_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_pps_4w_updated_at BEFORE UPDATE ON public.parking_payment_structure_4w FOR EACH ROW EXECUTE FUNCTION public.trg_pps_4w_before_update();


--
-- TOC entry 4870 (class 2620 OID 12256356)
-- Name: staff_logs trg_staff_logs_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_staff_logs_updated_at BEFORE UPDATE ON public.staff_logs FOR EACH ROW EXECUTE FUNCTION public.trg_staff_logs_before_update();


--
-- TOC entry 4868 (class 2620 OID 12256277)
-- Name: staff trg_staff_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_staff_updated_at BEFORE UPDATE ON public.staff FOR EACH ROW EXECUTE FUNCTION public.trg_staff_before_update();


--
-- TOC entry 4869 (class 2620 OID 12256322)
-- Name: vehicle_session trg_vehicle_session_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_vehicle_session_updated_at BEFORE UPDATE ON public.vehicle_session FOR EACH ROW EXECUTE FUNCTION public.trg_vehicle_session_before_update();


--
-- TOC entry 4863 (class 2606 OID 12256386)
-- Name: parking_payment_structure_2w fk_pps_2w_parkingfield; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parking_payment_structure_2w
    ADD CONSTRAINT fk_pps_2w_parkingfield FOREIGN KEY (fkparkingfield) REFERENCES public.parkingfield(id) ON DELETE CASCADE;


--
-- TOC entry 4864 (class 2606 OID 12256405)
-- Name: parking_payment_structure_3w fk_pps_3w_parkingfield; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parking_payment_structure_3w
    ADD CONSTRAINT fk_pps_3w_parkingfield FOREIGN KEY (fkparkingfield) REFERENCES public.parkingfield(id) ON DELETE CASCADE;


--
-- TOC entry 4865 (class 2606 OID 12256424)
-- Name: parking_payment_structure_4w fk_pps_4w_parkingfield; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parking_payment_structure_4w
    ADD CONSTRAINT fk_pps_4w_parkingfield FOREIGN KEY (fkparkingfield) REFERENCES public.parkingfield(id) ON DELETE CASCADE;


--
-- TOC entry 4862 (class 2606 OID 12256348)
-- Name: staff_logs fk_staff_logs_staff; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_logs
    ADD CONSTRAINT fk_staff_logs_staff FOREIGN KEY (fkstaff) REFERENCES public.staff(id) ON DELETE CASCADE;


--
-- TOC entry 4857 (class 2606 OID 12256269)
-- Name: staff fk_staff_parkingfield; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT fk_staff_parkingfield FOREIGN KEY (fkparkingfield) REFERENCES public.parkingfield(id) ON DELETE CASCADE;


--
-- TOC entry 4858 (class 2606 OID 12256307)
-- Name: vehicle_session fk_vehicle_session_mock_vahan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_session
    ADD CONSTRAINT fk_vehicle_session_mock_vahan FOREIGN KEY (fkmock_vahan) REFERENCES public.mock_vahan(id) ON DELETE CASCADE;


--
-- TOC entry 4859 (class 2606 OID 12256302)
-- Name: vehicle_session fk_vehicle_session_parkingfield; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_session
    ADD CONSTRAINT fk_vehicle_session_parkingfield FOREIGN KEY (fkparkingfield) REFERENCES public.parkingfield(id) ON DELETE CASCADE;


--
-- TOC entry 4860 (class 2606 OID 12256312)
-- Name: vehicle_session fk_vehicle_session_staff; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_session
    ADD CONSTRAINT fk_vehicle_session_staff FOREIGN KEY (fkstaff) REFERENCES public.staff(id) ON DELETE CASCADE;


--
-- TOC entry 4861 (class 2606 OID 12256327)
-- Name: vehicle_session fk_vehicle_session_staff_exit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_session
    ADD CONSTRAINT fk_vehicle_session_staff_exit FOREIGN KEY (fkstaff_exit) REFERENCES public.staff(id) ON DELETE SET NULL;


-- Completed on 2026-02-03 18:39:52

--
-- PostgreSQL database dump complete
--

\unrestrict Cp0mmhKsfzr1I6uF4yEYNXPDucD3rET2sKqhInRjSTNyEfIGT8AZ4NR37dF83K0

