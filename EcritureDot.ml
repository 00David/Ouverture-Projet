(* EcritureDot.ml : Fonctions permettant d'écrire nos arbres créés par nos algos au format .dot *)


(** Ecrit un arbre au fomat .dot de manière minimale.
    @param a L'arbre concerné.
    @param fichier Le chemin du fichier de sortie.
*)
let ecritureArbreDot (a : Arbre.arbre) (fichier : string) =
    let oc = open_out fichier in
    Printf.fprintf oc "graph Arbre {\n";
    Printf.fprintf oc "  node [fontname=\"Arial\"];\n";
    
    let rec aux n =
        match n with
        | Arbre.Empty e ->
            (* Feuille : box *)
            Printf.fprintf oc "  n%d [label=\"\", width=0.02, height=0.02, fixedsize=true, shape=circle];\n" e.id;
        | Arbre.Noeud n ->
            (* Noeud interne : cercle *)
            Printf.fprintf oc "  n%d [label=\"\", width=0.02, height=0.02, fixedsize=true, shape=circle];\n" n.id;
            (* Arête vers enfant gauche *)
            Printf.fprintf oc "  n%d -- n%d [penwidth=1];\n" n.id 
            (match n.g with 
                | Arbre.Empty eg -> eg.id
                | Arbre.Noeud ng -> ng.id);
            aux n.g;
            (* Arête vers enfant droit *)
            Printf.fprintf oc "  n%d -- n%d [penwidth=1];\n" n.id 
            (match n.d with 
                | Arbre.Empty ed -> ed.id
                | Arbre.Noeud nd -> nd.id);
            aux n.d
    in
    aux a.racine;
    Printf.fprintf oc "}\n";
    close_out oc;
    Printf.printf "Fichier .dot de l'arbre généré dans %s\n" fichier


(** Ecrit un arbre au fomat .dot, avec des grosses arêtes et des noeuds portant les ids pour debug.
    @param a L'arbre concerné.
    @param fichier Le chemin du fichier de sortie.
*)
let ecritureArbreDotDebug (a : Arbre.arbre) (fichier : string) =
    let oc = open_out fichier in
    Printf.fprintf oc "graph Arbre {\n";
    Printf.fprintf oc "  node [fontname=\"Arial\"];\n";
    
    let rec aux n =
        match n with
        | Arbre.Empty e ->
            (* Feuille : box *)
            Printf.fprintf oc "  n%d [label=%d, shape=box];\n" e.id e.id;
        | Arbre.Noeud n ->
            (* Noeud interne : cercle *)
            Printf.fprintf oc "  n%d [label=%d, shape=circle];\n" n.id n.id;
            (* Arête vers enfant gauche *)
            Printf.fprintf oc "  n%d -- n%d [penwidth=20];\n" n.id 
            (match n.g with 
                | Arbre.Empty eg -> eg.id
                | Arbre.Noeud ng -> ng.id);
            aux n.g;
            (* Arête vers enfant droit *)
            Printf.fprintf oc "  n%d -- n%d [penwidth=20];\n" n.id 
            (match n.d with 
                | Arbre.Empty ed -> ed.id
                | Arbre.Noeud nd -> nd.id);
            aux n.d
    in
    aux a.racine;
    Printf.fprintf oc "}\n";
    close_out oc;
    Printf.printf "Fichier .dot de l'arbre généré dans %s\n" fichier