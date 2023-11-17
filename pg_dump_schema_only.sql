PGDMP     	                
    {            fooddb    10.23    10.23                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false                       1262    18305    fooddb    DATABASE     �   CREATE DATABASE fooddb WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';
    DROP DATABASE fooddb;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false                       0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    3                        3079    12924    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false                       0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �            1259    18459    day_nutrition    TABLE     �   CREATE TABLE public.day_nutrition (
    nutrition_day character varying(255),
    nutrition_names character varying(255),
    protein_values character varying(80),
    carb_values character varying(80),
    fat_values character varying(80)
);
 !   DROP TABLE public.day_nutrition;
       public         postgres    false    3            �            1259    18330    food    TABLE     �   CREATE TABLE public.food (
    fdc_id integer NOT NULL,
    data_type character varying(255),
    description character varying(255),
    food_category_id character varying(20),
    publication_date date
);
    DROP TABLE public.food;
       public         postgres    false    3            �            1259    18394    food_calorie_conversion_factor    TABLE     �   CREATE TABLE public.food_calorie_conversion_factor (
    food_nutrient_conversion_id integer,
    protein_value character varying(50),
    fat_value character varying(50),
    carbohydrate_value character varying(50)
);
 2   DROP TABLE public.food_calorie_conversion_factor;
       public         postgres    false    3            �            1259    18428    food_nutrient    TABLE     �  CREATE TABLE public.food_nutrient (
    id integer NOT NULL,
    fdc_id integer,
    nutrient_id integer,
    amount character varying(80),
    data_points character varying(20),
    derivation_id character varying(20),
    min character varying(40),
    max character varying(40),
    median character varying(40),
    footnote character varying(255),
    min_year_acquired character varying(60)
);
 !   DROP TABLE public.food_nutrient;
       public         postgres    false    3            �            1259    18365    food_nutrient_conversion_factor    TABLE     e   CREATE TABLE public.food_nutrient_conversion_factor (
    id integer NOT NULL,
    fdc_id integer
);
 3   DROP TABLE public.food_nutrient_conversion_factor;
       public         postgres    false    3            �            1259    18402    food_protein_conversion_factor    TABLE     �   CREATE TABLE public.food_protein_conversion_factor (
    food_nutrient_conversion_id integer,
    value character varying(50)
);
 2   DROP TABLE public.food_protein_conversion_factor;
       public         postgres    false    3            �            1259    18350    nutrient    TABLE     �   CREATE TABLE public.nutrient (
    id integer NOT NULL,
    name character varying(255),
    unit_name character varying(20),
    nutrient_nbr character varying(80),
    rank character varying(80)
);
    DROP TABLE public.nutrient;
       public         postgres    false    3            �
           2606    18369 D   food_nutrient_conversion_factor food_nutrient_conversion_factor_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.food_nutrient_conversion_factor
    ADD CONSTRAINT food_nutrient_conversion_factor_pkey PRIMARY KEY (id);
 n   ALTER TABLE ONLY public.food_nutrient_conversion_factor DROP CONSTRAINT food_nutrient_conversion_factor_pkey;
       public         postgres    false    198            �
           2606    18435     food_nutrient food_nutrient_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.food_nutrient
    ADD CONSTRAINT food_nutrient_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.food_nutrient DROP CONSTRAINT food_nutrient_pkey;
       public         postgres    false    201            �
           2606    18337    food food_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.food
    ADD CONSTRAINT food_pkey PRIMARY KEY (fdc_id);
 8   ALTER TABLE ONLY public.food DROP CONSTRAINT food_pkey;
       public         postgres    false    196            �
           2606    18354    nutrient nutrient_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.nutrient
    ADD CONSTRAINT nutrient_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.nutrient DROP CONSTRAINT nutrient_pkey;
       public         postgres    false    197            �
           2606    18397 ^   food_calorie_conversion_factor food_calorie_conversion_factor_food_nutrient_conversion_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.food_calorie_conversion_factor
    ADD CONSTRAINT food_calorie_conversion_factor_food_nutrient_conversion_id_fkey FOREIGN KEY (food_nutrient_conversion_id) REFERENCES public.food_nutrient_conversion_factor(id);
 �   ALTER TABLE ONLY public.food_calorie_conversion_factor DROP CONSTRAINT food_calorie_conversion_factor_food_nutrient_conversion_id_fkey;
       public       postgres    false    2700    199    198            �
           2606    18436 '   food_nutrient food_nutrient_fdc_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.food_nutrient
    ADD CONSTRAINT food_nutrient_fdc_id_fkey FOREIGN KEY (fdc_id) REFERENCES public.food(fdc_id);
 Q   ALTER TABLE ONLY public.food_nutrient DROP CONSTRAINT food_nutrient_fdc_id_fkey;
       public       postgres    false    201    2696    196            �
           2606    18405 ^   food_protein_conversion_factor food_protein_conversion_factor_food_nutrient_conversion_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.food_protein_conversion_factor
    ADD CONSTRAINT food_protein_conversion_factor_food_nutrient_conversion_id_fkey FOREIGN KEY (food_nutrient_conversion_id) REFERENCES public.food_nutrient_conversion_factor(id);
 �   ALTER TABLE ONLY public.food_protein_conversion_factor DROP CONSTRAINT food_protein_conversion_factor_food_nutrient_conversion_id_fkey;
       public       postgres    false    2700    200    198           