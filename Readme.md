# Projet Ouverture : génération d'arbres binaires aléatoires

**David VADIMON**  
**Abdullah AL MAMUN**  
**Yahya MUDALLAL**  

## Exécutables

Les scripts exécutables sont générés dans le sous-répertoire '*executables*'.  

## Execution algorithme de Rémy

Depuis le répertoire racine du projet.  

**Compilation :**  
```bash
ocamlc -o executables/Remy Arbre.ml EcritureDot.ml Remy.ml
```

**Execution, avec 'n' la taille de l'arbre à créer :**  
```bash
executables/Remy n
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
