--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

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
-- Data for Name: packages; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.packages (id, attr_path, name, version, description, source_url, build_phase, install_phase, unpack_phase, source_hash) VALUES (1, 'hello-world', 'hello-world', '1.0.0', 'A basic Hello World program', 'https://gist.githubusercontent.com/samrose/3ac76cf99e7e0bea627823e30b9bdd92/raw/6545635aca025918c986301a7eef903034193544/hello.c', '$CC hello.c -o hello', 'mkdir -p $out/bin; cp hello $out/bin/', 'cp $src hello.c', 'sha256-n1VVXku/KHEg+HU0SZJlGvI5yrGhwaoYMehYTiPVE40=');


--
-- Name: packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.packages_id_seq', 1, false);


--
-- PostgreSQL database dump complete
--

