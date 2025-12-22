# Projet Ouverture : génération d'arbres binaires aléatoires

**David VADIMON 21207099**  
**Abdullah AL MAMUN 21124650**  
**Yahya MUDALLAL 21238547**  

## Rapport

[Rapport_projet_ouverture.pdf](Rapport_projet_ouverture.pdf)  

## Setup à faire

```bash
mkdir executables
```

## Architecture du projet

Fichier **Arbre.ml** : La structure de l'arbre utilisée par les algos y est définie + des fonctions utilitaires sur celle-ci ou ses noeuds.  

Fichier **Remy.ml** : L'algo de Rémy servant à générer un arbre.  
Fichier **Remy_main.ml** : Point d'entrée de l'algo de Rémy.  

Fichier **ABR.ml** : L'algo servant à générer un arbre de type ABR.  
Fichier **ABR_main.ml** : Point d'entrée de l'algo de l'arbre de type ABR.  

Fichier **EcritureDot.ml** : Les fonctions permettant d'écrire notre structure d'arbre dans le format .dot.  

Fichier **experimentation.ml** : Contient les fonctions utilisées pour récolter les datas sur les arbres, et a un point d'entrée permettant de tout récolter et mettre dans un .csv.  

Sous-répertoire **executables** : Les scripts exécutables de nos 2 algos y sont générés, en plus du script pour récupérer les datas de la partie expérimentation.  

Sous-répertoire **graphiques** : Les graphiques générés et utilisés dans le rapport y sont.  

## Exécution algorithme de Rémy

Depuis le répertoire racine du projet.  

**Compilation :**  
```bash
ocamlc -o executables/Remy Arbre.ml EcritureDot.ml Remy.ml Remy_main.ml
```

**Exécution, avec 'n' la taille de l'arbre à créer :**  
```bash
executables/Remy n
```

## Exécution algorithme ABR

Depuis le répertoire racine du projet.  

**Compilation :**  
```bash
ocamlc -o executables/ABR Arbre.ml EcritureDot.ml ABR.ml ABR_main.ml
```

**Exécution, avec 'n' la taille de l'arbre à créer :**  
```bash
executables/ABR n
```

## Exécution expérimentation (récolte des datas, prend un peu de temps)

Depuis le répertoire racine du projet.  

**Compilation :**  
```bash
ocamlc -o executables/experimentation Arbre.ml EcritureDot.ml Remy.ml ABR.ml experimentation.ml
```

**Exécution**, avec 'fichier_res.csv' le fichier de sortie dans lequel mettre les datas, et 'nb_tailles_arbres' le nombre de tailles différentes testées pour les arbres  :  
```bash
executables/experimentation fichier_res.csv nb_tailles_arbres
```

## Lecture .dot

ça c'est juste temporaire pour moi, je laisse les commandes ici pour Ctrl-c Ctrl-v dans mes terminaux.  
Comme j'ai graphviz côté Windows, il y a une commande pour copier du WSL au file sytem Windows, et l'autre c'est pour lire le .dot en powershell côté windows.

```bash
cp ./arbreRemy.dot /mnt/c/Users/David/Downloads/
```

```powershell
dot -Tpng "C:\Users\David\Downloads\arbreRemy.dot" -o "C:\Users\David\Downloads\arbreRemy.png"
```

```bash
cp ./arbreABR.dot /mnt/c/Users/David/Downloads/
```

```powershell
dot -Tpng "C:\Users\David\Downloads\arbreABR.dot" -o "C:\Users\David\Downloads\arbreABR.png"
```
## Lien temporaire rapport GDoc  

https://docs.google.com/document/d/1Pwz9IPIsNBY-8u0gIAGGEfuqpr2OZLDmix0Tm8wHAWQ/edit?usp=sharing  
