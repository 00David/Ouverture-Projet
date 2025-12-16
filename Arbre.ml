(* Arbre.ml : Nos structures *)


(** Type représentant un noeud d'un arbre binaire. Un noeud a forcément une étiquette entière unique (id), et seule la racine n'a pas de parent (parent = None).
    La première étiquette (id) commence à 1. Si un noeud est un Empty avec une étiquette à 0, c'est un noeud temporaire.
    - [Empty] : une feuille identifiée par un entier [id].
        @param id L'étiquette unique.
        @param p Le parent du noeud.
    - [Noeud] : un noeud interne identifié par un entier [id], ayant deux enfants [g] et [d].
        @param id L'étiquette unique.
        @param g L'enfant gauche du noeud.
        @param d L'enfant droit du noeud.
        @param p Le parent du noeud.
*)
type noeud =
    | Empty of { 
        id : int; 
        mutable p : noeud option 
    }
  	| Noeud of {
        id : int;
        mutable g : noeud;
        mutable d : noeud;
        mutable p : noeud option
    }


(** Type représentant un arbre binaire.
    @param racine La racine de l'arbre en lui-même.
    @param noeuds Le tableau préalloué contenant tous les noeuds de l'arbre (internes + feuilles).
    @param feuilles Le tableau préalloué contenant les feuilles de l'arbre.
*)
type arbre = {
    mutable racine : noeud;
    noeuds : noeud array; (* Pas mutable : on alloue sa taille 1 fois à l'initialisation de l'arbre vide *)
    feuilles : noeud array; (* Pas mutable : on alloue sa taille 1 fois à l'initialisation de l'arbre vide *)
}


(* FONCTIONS UTILITAIRES SUR LES STRUCTURES *)


(* FONCTIONS POUR MODIFIER LES STRUCTURES *)


(** Regarde l'égalité entre 2 noeuds (aux racines des sous-arbres).
    @param n1 1er noeud
    @param n2 2ème noeud
    @return True si égalité entre 2 noeuds (au niveau des étiquettes racines)
*)
let egaliteNoeuds (n1 : noeud) (n2 : noeud) : bool =
    match n1, n2 with
    | Empty e1, Empty e2 -> e1.id = e2.id
    | Noeud n1, Noeud n2 -> n1.id = n2.id
    | _, _ -> false


(** Met à jour le parent d'un noeud .
    @param n Le noeud pour lequel mettre le parent à jour.
    @param p Le nouveau parent du noeud.
*)
let mettre_parent (n : noeud) (p : noeud) =
  match n with
    | Empty e -> e.p <- Some p
    | Noeud n -> n.p <- Some p


(** Remplace un enfant d'un certain noeud interne parent par un autre.
    @param parent Le noeud parent pour lequel on va changer un fils.
    @param ancienEnfant L'ancien enfant du parent.
    @param nouvelEnfant Le nouvel enfant du parent.
*)
let remplacerEnfant (parent : noeud) (ancienEnfant : noeud) (nouvelEnfant : noeud) =
    match parent with
    | Empty e -> () (* On ne fait rien si le parent est une feuille *)
    | Noeud nParent ->
        if egaliteNoeuds nParent.g ancienEnfant (* Si l'ancien enfant est le fils gauche du parent *)
            then nParent.g <- nouvelEnfant
        else
            if egaliteNoeuds nParent.d ancienEnfant  (* Si l'ancien enfant est le fils droit du parent *)
                then nParent.d <- nouvelEnfant
            else
                () (* Sinon rien *)


(** Création d'un arbre de taille 0 (0 noeud interne et 1 feuille). 
    La feuille (ici du coup la racine) est initialisée avec une étiquette de valeur 1.
    Les tableaux contenant les noeuds et les feuilles de l'arbre sont initialisés, avec donc la racine dedans.
    @param tailleMaxNoeuds Le nombre de noeuds (internes + feuilles) maximal dans l'arbre.
    @param tailleMaxFeuilles Le nombre de feuilles maximal dans l'arbre.
    @return Un arbre vide (réduit à une feuille).
*)
let arbre_vide (tailleMaxNoeuds : int) (tailleMaxFeuilles : int) : arbre =
    let r = Empty { id = 1; p = None } in
    (* Initialisation des tableaux des noeuds et des feuilles avec des Empty “temporaires”, d'id 0 : *)
    let noeuds = Array.make tailleMaxNoeuds (Empty { id = 0; p = None }) in
    let feuilles = Array.make tailleMaxFeuilles (Empty { id = 0; p = None }) in
    (* Mise de la racine dans les tableaux (à l'indice 0) : *)
    noeuds.(0) <- r;
    feuilles.(0) <- r;
    (* Construction de l'arbre réduit à une feuille en racine : *)
    {
        racine = r;
        noeuds = noeuds;
        feuilles = feuilles;
    }


(* FONCTIONS POUR ANALYSER LES STRUCTURES *)


(** Parcourt l'arborescence d'un arbre (via une fonction auxiliaire récursive interne) pour obtenir son nombre total de noeuds (internes + feuilles), et son nombre de feuilles.
    @param a L'arbre pour lequel extraire le nombre de noeuds.
    @return Un couple (nb_noeuds, nb_feuilles) où :
    - [nb_noeuds] est le nombre de noeuds (internes + feuilles) dans l'arbre [a].
    - [nb_feuilles] est le nombre de feuilles dans l'arbre [a].
    Remarque : la taille de l'arbre n, en termes de noeuds internes, est donnée par n = ([nb_noeuds]-[nb_feuilles]).
*)
let getNbNoeuds (a : arbre) : int * int =
	
	let rec aux (n : noeud) : int * int =
		match n with
		| Empty e -> (1, 1)
		| Noeud n -> 
			let nb_noeudsG, nb_feuillesG = aux n.g in
			let nb_noeudsD, nb_feuillesD = aux n.d in
			(1 + nb_noeudsG + nb_noeudsD, nb_feuillesG + nb_feuillesD)

	in aux a.racine (* On parcourt l'arbre en partant de la racine de l'arbre *)

(** Affiche seulement la nature d'un noeud (Empty ou Noeud).
    @param n noeud à afficher
*)
let afficherEtiquetteNoeud (n : noeud) =
    match n with
    | Noeud n -> Printf.printf "Noeud%d" n.id
    | Empty e -> Printf.printf "Empty%d" e.id


(** Affiche l'arborescence en profondeur d'un arbre.
    @param n L'arborescence à afficher à partir d'une racine.
*)
let rec afficherArborescence (n : noeud) =
    match n with
    | Noeud n -> 
        Printf.printf "Noeud%d(" n.id;
        afficherArborescence (n.g);
        Printf.printf ",";
        afficherArborescence (n.d);
        Printf.printf ")"
    | Empty e -> Printf.printf "Empty%d" e.id


(** Affiche toutes les infos stockées dans notre structure d'arbre.
    @param a L'arbre concerné.
*)
let afficher (a : arbre) =
	let nbNoeuds, nbFeuilles = getNbNoeuds a in
    Printf.printf "Arbre :\n";
    afficherArborescence (a.racine);
    Printf.printf "\n";
    Printf.printf "%d noeuds (internes + feuilles) : " nbNoeuds;
    Array.iter (fun x -> 
            afficherEtiquetteNoeud x; 
            Printf.printf " "
        ) a.noeuds;
    Printf.printf "\n";
    Printf.printf "%d noeuds feuilles : " nbFeuilles;
    Array.iter (fun x -> 
            afficherEtiquetteNoeud x; 
            Printf.printf " "
        ) a.feuilles;
    Printf.printf "\n";
    Printf.printf "n = %d\n" (nbNoeuds-nbFeuilles)