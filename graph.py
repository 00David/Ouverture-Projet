import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

data = pd.read_csv("experimentation.csv")

# intervalle des valeurs
n_min = data["taille"].min()
n_max = data["taille"].max()
intervalle_n = np.linspace(n_min, n_max, 100)

# calcul de la fonction f(n) = 3.5*sqrt(n)
f = 3.5*np.sqrt(intervalle_n)

# calcul de la fonction g(n) = 1.7*sqrt(n)
g = 1.7*np.sqrt(intervalle_n)

# graphique du temps en fonction de la taille
plt.figure()
plt.plot(data['taille'], data['temps_ABR'], label="ABR", color='blue')
plt.plot(data['taille'], data['temps_Remy'], label="Remy", color='orange')
plt.xlabel("Taille (nombre de noeuds internes)")
plt.ylabel("Temps (s)")
plt.title("Temps d'exécution en fonction de la taille")
plt.legend()
plt.savefig("./graphiques/temps_par_taille.png")

# graphique de la hauteur en fonction de le taille
plt.figure()
plt.plot(data['taille'], data['hauteur_ABR'], label="ABR", color='blue')
plt.plot(data['taille'], data['hauteur_Remy'], label="Remy", color='orange')
plt.plot(intervalle_n, f, label=r"$3.5\sqrt{n}$")
plt.xlabel("Taille (nombre de noeuds internes)")
plt.ylabel("Hauteur de l'arbre")
plt.title("Hauteur des arbres en fonction du nombre de noeuds")
plt.legend()
plt.savefig("./graphiques/hauteur_par_taille.png")

# graphique hauteur uniquement pour ABR
plt.figure()
plt.plot(data['taille'], data['hauteur_ABR'], label="ABR", color='blue')
plt.xlabel("Taille (nombre de noeuds internes)")
plt.ylabel("Hauteur de l'arbre")
plt.title("Hauteur des arbres en fonction du nombre de noeuds")
plt.legend()
plt.savefig("./graphiques/ABR_hauteur_par_taille.png")

# graphique de la taille du sous arbre gauche en fonction de le taille
plt.figure()
plt.plot(data['taille'], data['taille_ssarbre_g_ABR'], label="ABR", color='blue')
plt.plot(data['taille'], data['taille_ssarbre_g_Remy'], label="Remy", color='orange')
plt.xlabel("Taille (nombre de noeuds internes)")
plt.ylabel("Nombre de noeuds sous arbre gauche")
plt.title("Taille des sous arbres gauche selon le nombre de noeuds")
plt.legend()
plt.savefig("./graphiques/ssarbreg_par_taille.png")

# graphique de la taille du sous arbre gauche ABR
plt.figure()
plt.plot(data['taille'], data['taille_ssarbre_g_ABR'], label="ABR", color='blue')
plt.xlabel("Taille (nombre de noeuds internes)")
plt.ylabel("Nombre de noeuds sous arbre gauche")
plt.title("Taille des sous arbres gauche selon le nombre de noeuds")
plt.legend()
plt.axis('equal')
plt.savefig("./graphiques/ABR_ssarbreg_par_taille.png")

# graphique de la taille du sous arbre gauche Remy
plt.figure()
plt.plot(data['taille'], data['taille_ssarbre_g_Remy'], label="Remy", color='orange')
plt.xlabel("Taille (nombre de noeuds internes)")
plt.ylabel("Nombre de noeuds sous arbre gauche")
plt.title("Taille des sous arbres gauche selon le nombre de noeuds")
plt.legend()
plt.axis('equal')
plt.savefig("./graphiques/Remy_ssarbreg_par_taille.png")


# graphique de la largeur des arbres selon le taille
plt.figure()
plt.plot(data['taille'], data['largeur_ABR'], label="ABR", color='blue')
plt.plot(data['taille'], data['largeur_Remy'], label="Remy", color='orange')
plt.xlabel("Taille (nombre de noeuds internes)")
plt.ylabel("Largeur de l'arbre")
plt.title("Largeur des arbres en fonction du nombre de noeuds")
plt.legend()
plt.savefig("./graphiques/largeur_par_taille.png")

# graphique largeur uniquement pour Remy
plt.figure()
plt.plot(data['taille'], data['largeur_Remy'], label="Remy", color='orange')
plt.plot(intervalle_n, g, label=r"$1.7\sqrt{n}$")
plt.xlabel("Taille (nombre de noeuds internes)")
plt.ylabel("Largeur de l'arbre")
plt.title("Largeur des arbres en fonction du nombre de noeuds")
plt.legend()
plt.savefig("./graphiques/Remy_largeur_par_taille.png")


# graphique de la profondeur moyenne des feuilles des arbres selon la taille
plt.figure()
plt.plot(data['taille'], data['prof_moy_ABR'], label="ABR", color='blue')
plt.plot(data['taille'], data['prof_moy_Remy'], label="Remy", color='orange')
plt.xlabel("Taille (nombre de noeuds internes)")
plt.ylabel("Profondeur moyenne des feuilles de l'arbre")
plt.title("Profondeur des feuilles en fonction du nombre de noeuds")
plt.legend()
plt.savefig("./graphiques/profondeur_par_taille.png")

# graphique profondeur moyenne + hauteur Remy
plt.figure()
plt.plot(data['taille'], data['prof_moy_ABR'], label="profondeur moyenne ABR", color='blue')
plt.plot(data['taille'], data['hauteur_ABR'], label="hauteur ABR", color='orange')
plt.xlabel("Taille (nombre de noeuds internes)")
plt.title("Comparaison profondeur des feuilles et hauteur ABR")
plt.legend()
plt.savefig("./graphiques/ABR_profVShauteur.png")

# graphique profondeur moyenne + hauteur ABR
plt.figure()
plt.plot(data['taille'], data['prof_moy_Remy'], label="profondeur moyenne Remy", color='blue')
plt.plot(data['taille'], data['hauteur_Remy'], label="hauteur Remy", color='orange')
plt.xlabel("Taille (nombre de noeuds internes)")
plt.title("Comparaison profondeur des feuilles et hauteur Remy")
plt.legend()
plt.savefig("./graphiques/Remy_profVShauteur.png")
