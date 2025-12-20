import pandas as pd
import matplotlib.pyplot as plt

data = pd.read_csv("experimentation.csv")

# graphique du temps en fonction de la taille
plt.figure()
plt.plot(data['taille'], data['temps_ABR'], label="ABR")
plt.plot(data['taille'], data['temps_Remy'], label="Remy")
plt.xlabel("Nombre de noeuds")
plt.ylabel("Temps (s)")
plt.title("Temps d'exécution en fonction de la taille")
plt.legend()
plt.savefig("./graphiques/temps_par_taille.png")

# graphique de la hauteur en fonction de le taille
plt.figure()
plt.plot(data['taille'], data['hauteur_ABR'], label="ABR")
plt.plot(data['taille'], data['hauteur_Remy'], label="Remy")
plt.xlabel("Nombre de noeuds")
plt.ylabel("Hauteur de l'arbre")
plt.title("Hauteur des arbres en fonction du nombre de noeuds")
plt.legend()
plt.savefig("./graphiques/hauteur_par_taille.png")

# graphique de la taille du sous arbre gauche en fonction de le taille
plt.figure()
plt.plot(data['taille'], data['taille_ssarbre_g_ABR'], label="ABR")
plt.plot(data['taille'], data['taille_ssarbre_g_Remy'], label="Remy")
plt.xlabel("Nombre de noeuds")
plt.ylabel("Nombre de noeuds sous arbre gauche")
plt.title("Taille des sous arbres gauche selon le nombre de noeuds")
plt.legend()
plt.savefig("./graphiques/ssarbreg_par_taille.png")

# graphique de la largeur des arbres selon le taille
plt.figure()
plt.plot(data['taille'], data['largeur_ABR'], label="ABR")
plt.plot(data['taille'], data['largeur_Remy'], label="Remy")
plt.xlabel("Nombre de noeuds")
plt.ylabel("Largeur de l'arbre")
plt.title("Largeur des arbres en fonction du nombre de noeuds")
plt.legend()
plt.savefig("./graphiques/largeur_par_taille.png")

# graphique de la profondeur moyenne des feuilles des arbres selon la taille
plt.figure()
plt.plot(data['taille'], data['prof_moy_ABR'], label="ABR")
plt.plot(data['taille'], data['prof_moy_Remy'], label="Remy")
plt.xlabel("Nombre de noeuds")
plt.ylabel("Profondeur moyenne des feuilles de l'arbre")
plt.title("Profondeur des feuilles en fonction du nombre de noeuds")
plt.legend()
plt.savefig("./graphiques/profondeur_par_taille.png")




