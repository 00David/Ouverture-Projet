(* Arbre.ml : Nos structures *)


(** Type représentant un noeud d'un arbre binaire. Un noeud a forcément une étiquette entière unique, et seule la racine n'a pas de parent (parent = None).
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
    @param t_noeuds Le nombre de cases actuellement utilisées pour le tableau [noeuds] (= nb de nos noeuds).
    @param t_feuilles Le nombre de cases actuellement utilisées pour le tableau [feuilles] (= nb de nos feuilles).
    Remarque : la taille de l'arbre n, en termes de noeuds internes, est donnée par n = (t_noeuds-t_feuilles).
*)
type arbre = {
    mutable racine : noeud;
    noeuds : noeud array; (* Pas mutable : on alloue sa taille 1 fois à l'initialisation de l'arbre vide *)
    feuilles : noeud array; (* Pas mutable : on alloue sa taille 1 fois à l'initialisation de l'arbre vide *)
    mutable t_noeuds : int;
    mutable t_feuilles : int;
}


(* Fonctions utilitaires sur les structures *)


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
    La feuille est initialisée avec une étiquette de valeur 1.
    @param tailleMaxNoeuds Le nombre de noeuds (internes + feuilles) maximal dans l'arbre.
    @param tailleMaxFeuilles Le nombre de feuilles maximal dans l'arbre.
    @return Un arbre vide.
*)
let arbre_vide (tailleMaxNoeuds : int) (tailleMaxFeuilles : int) : arbre =
    let r = Empty { id = 1; p = None } in
    (* Initialisation des tableaux avec des Empty “temporaires” *)
    let noeuds = Array.make tailleMaxNoeuds (Empty { id = 0; p = None }) in
    let feuilles = Array.make tailleMaxFeuilles (Empty { id = 0; p = None }) in
    (* Mise de la racine dans les tableaux *)
    noeuds.(0) <- r;
    feuilles.(0) <- r;
    (* Construction de l'arbre réduit à la racine *)
    {
        racine = r;
        noeuds = noeuds;
        feuilles = feuilles;
        t_noeuds = 1;
        t_feuilles = 1;
    }


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
    Printf.printf "Arbre :\n";
    afficherArborescence (a.racine);
    Printf.printf "\n";
    Printf.printf "%d noeuds (internes + feuilles) : " a.t_noeuds;
    Array.iter (fun x -> 
            afficherEtiquetteNoeud x; 
            Printf.printf " "
        ) a.noeuds;
    Printf.printf "\n";
    Printf.printf "%d noeuds feuilles : " a.t_feuilles;
    Array.iter (fun x -> 
            afficherEtiquetteNoeud x; 
            Printf.printf " "
        ) a.feuilles;
    Printf.printf "\n";
    Printf.printf "n = %d\n" (a.t_noeuds-a.t_feuilles)


(** Ecrit un arbre au fomat .dot.
    @param a L'arbre concerné.
    @param fichier Le fichier de sortie.
*)
let ecritureArbreDot (a : arbre) (fichier : string) =
    let oc = open_out fichier in
    Printf.fprintf oc "graph Arbre {\n";
    Printf.fprintf oc "  node [fontname=\"Arial\"];\n";
    
    let rec aux n =
        match n with
        | Empty e ->
            (* Feuille : box *)
            Printf.fprintf oc "  n%d [label=%d, shape=box];\n" e.id e.id;
        | Noeud n ->
            (* Noeud interne : cercle *)
            Printf.fprintf oc "  n%d [label=%d, shape=circle];\n" n.id n.id;
            (* Arête vers enfant gauche *)
            Printf.fprintf oc "  n%d -- n%d [penwidth=20];\n" n.id 
            (match n.g with 
                | Empty eg -> eg.id
                | Noeud ng -> ng.id);
            aux n.g;
            (* Arête vers enfant droit *)
            Printf.fprintf oc "  n%d -- n%d [penwidth=20];\n" n.id 
            (match n.d with 
                | Empty ed -> ed.id
                | Noeud nd -> nd.id);
            aux n.d
    in
    aux a.racine;
    Printf.fprintf oc "}\n";
    close_out oc;
    Printf.printf "Fichier .dot de l'arbre généré dans %s\n" fichier