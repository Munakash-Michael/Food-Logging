import psycopg2
import tkinter as tk 
import datetime

conn = psycopg2.connect(host = 'localhost', dbname = 'fooddb', user = 'postgres', password = 'Michaelm82!', port = 5433)
cur = conn.cursor()

window = tk.Tk()
frame = tk.Frame(window)
main_frame = tk.LabelFrame(frame, text ="Log", padx=100, pady=50)
results_frame = tk.LabelFrame(frame, text ="Result", padx=100, pady=10)
food_description = tk.Label(main_frame, text = "Food Description: ")
date = tk.Label(main_frame, text="Date(YYYY-MM-DD): ")
food_input = tk.Entry(main_frame)
day_input = tk.Entry(main_frame)
button_frame = tk.Frame(window)
nutrients_listbox = tk.Listbox(results_frame)
protein_listbox = tk.Listbox(results_frame)
fat_listbox = tk.Listbox(results_frame)
carb_listbox = tk.Listbox(results_frame)

def reset():
    nutrients_listbox.delete(1,"end")
    protein_listbox.delete(1,"end")
    fat_listbox.delete(1,"end")
    carb_listbox.delete(1,"end")

def get_nutrients_food_log():
    reset()
    input = food_input.get()
#   Input is the input of the food description
    cur.execute("SELECT name FROM nutrient WHERE id IN (SELECT nutrient_id FROM food_nutrient WHERE fdc_id IN (SELECT fdc_id FROM food WHERE description = '{0}'));".format(str(input)))
    nutrients = cur.fetchall()
    for i in nutrients:
        nutrients_listbox.insert("end", i)
#   Some protein values are in the food_calorie_conversion_factor table and not in the food_protein_conversion_factor
    cur.execute("SELECT protein_value FROM food_calorie_conversion_factor WHERE food_nutrient_conversion_id IN (SELECT id from food_nutrient_conversion_factor WHERE fdc_id IN (SELECT fdc_id FROM food WHERE description = '{0}')) UNION SELECT value FROM food_protein_conversion_factor WHERE food_nutrient_conversion_id IN (SELECT id from food_nutrient_conversion_factor WHERE fdc_id IN (SELECT fdc_id FROM food WHERE description = '{0}'));".format(str(input)))
    protein_list = cur.fetchone()
    protein_listbox.insert("end", protein_list)

    cur.execute("SELECT carbohydrate_value FROM food_calorie_conversion_factor WHERE food_nutrient_conversion_id IN (SELECT id from food_nutrient_conversion_factor WHERE fdc_id IN (SELECT fdc_id FROM food WHERE description = '{0}'));".format(str(input)))
    carb_list = cur.fetchone()
    carb_listbox.insert("end", carb_list)

    cur.execute("SELECT fat_value FROM food_calorie_conversion_factor WHERE food_nutrient_conversion_id IN (SELECT id from food_nutrient_conversion_factor WHERE fdc_id IN (SELECT fdc_id FROM food WHERE description = '{0}'));".format(str(input)))
    fat_list = cur.fetchone()
    fat_listbox.insert("end", fat_list)

    current_date = datetime.date.today()
    date = str(current_date)
    
    cur.execute("INSERT INTO day_nutrition (nutrition_day, nutrition_names, protein_values, carb_values, fat_values) VALUES (%s, %s, %s, %s, %s);", (date,  nutrients[0], protein_list[0], (carb_list[0]), fat_list[0]))
#   To fix the index of the table in the database 
    nutrients.pop(0)
#   print rest of nutrients starting from index 1 
    for i in nutrients:
        cur.execute("INSERT INTO day_nutrition (nutrition_day, nutrition_names) VALUES (%s, %s);", (date, i))  
    print("Protein Saved")
    conn.commit()

def get_day_nutrition():
    reset()
    input = str(day_input.get())
    cur.execute("SELECT nutrition_names FROM day_nutrition WHERE nutrition_day = '{0}'".format(str(input)))
    nutrients = cur.fetchall()
    for i in nutrients:
        nutrients_listbox.insert("end", i)

    cur.execute("SELECT protein_values FROM day_nutrition WHERE nutrition_day = '{0}'".format(str(input)))
    cur.execute("SELECT protein_values FROM day_nutrition WHERE carb_values IS NOT NULL;")
    proteins = cur.fetchall()
    for i in proteins:
        protein_listbox.insert("end", i)

    cur.execute("SELECT carb_values FROM day_nutrition WHERE nutrition_day = '{0}';".format(str(input)))
    cur.execute("SELECT carb_values FROM day_nutrition WHERE carb_values IS NOT NULL;")
    carbs = cur.fetchall()
    for i in carbs:
        carb_listbox.insert("end", i)

    cur.execute("SELECT fat_values FROM day_nutrition WHERE nutrition_day = '{0}'".format(str(input)))
    cur.execute("SELECT fat_values FROM day_nutrition WHERE carb_values IS NOT NULL;")
    fats= cur.fetchall()
    for i in fats:
        fat_listbox.insert("end", i)

window.title("Food Tracker")
window.geometry("600x600")

frame.pack()

main_frame.grid(row=0, column=0)
results_frame.grid(row=1, column=0)
food_description.grid(row=0, column=0)
date.grid(row=0,column=3)
food_input.grid(row=1, column=0)
day_input.grid(row=1, column=3)

button_frame.pack()
submit_button = tk.Button(main_frame, text= "Submit", command=get_nutrients_food_log)
day_submit_button = tk.Button(main_frame, text= "Submit", command= get_day_nutrition)
reset_button = tk.Button(main_frame, text = "Reset", command=reset) 
submit_button.grid(row=2, column=0) 
day_submit_button.grid(row=2, column=3)
reset_button.grid(row=3, column=0)

nutrients_listbox.pack(side= "left")
protein_listbox.pack(side="left")
fat_listbox.pack(side="right")
carb_listbox.pack(side="right")

nutrients_listbox.insert(0, "NUTRIENTS")
protein_listbox.insert(0, "PROTEIN")
carb_listbox.insert(0, "CARBOHYDRATES")
fat_listbox.insert(0, "FAT")
    
window.mainloop() 
cur.close()
conn.close()