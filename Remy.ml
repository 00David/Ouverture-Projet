(* Remy.ml : Algorithme de Rémy *)
Random.self_init ();;


(** Ajoute 2 noeuds dans l'arborescence : 1 interne et 1 feuille, après avoir accédé à un noeud particulier de l'arbre.
    On modifie également les tableaux des noeuds et des feuilles de l'arbre pour réfléter ces ajouts. 
    Suppose que les tailles des tableaux aient été allouées au préalable pour permettre les ajouts.
    @param noeudCible Le noeud cible où ajouter un nouveau noeud interne, avec une nouvelle feuille. (noeudCible : racine de F par rapport à l'énoncé)
    @param a L'arbre dans lequel on ajoute le nouveau noeud.
    @param nb_noeuds Le nombre de cases actuellement utilisées pour le tableau [noeuds] dans l'arbre [a] (= nb de nos noeuds).
    @param nb_feuilles Le nombre de cases actuellement utilisées pour le tableau [feuilles] dans l'arbre [a] (= nb de nos feuilles).
    @return Le nouveau noeud interne.
*)
let ajouteNoeudRemy (noeudCible : Arbre.noeud) (a : Arbre.arbre) (nb_noeuds : int) (nb_feuilles : int) : Arbre.noeud =

    (* nb_noeuds+1 : id du nouveau noeud interne, nb_noeuds+2 : id du nouveau noeud feuille *)

    (* Création de la nouvelle feuille *)
    let nouvelleFeuille = Arbre.Empty { id = nb_noeuds+2; p = None } in

    (* Création du nouveau noeud interne *)
    let nouveauInterne =
        if Random.bool () then (* Pile : F devient enfant gauche du nouvel interne *)
            Arbre.Noeud { 
                id = nb_noeuds+1;
                g = noeudCible; 
                d = nouvelleFeuille; 
                p = match noeudCible with 
                    |Empty e -> e.p
                    |Noeud n -> n.p;
            }
        else (* Face : F devient enfant droit du nouvel interne *)
            Arbre.Noeud { 
                id = nb_noeuds+1;
                g = nouvelleFeuille; 
                d = noeudCible; 
                p = match noeudCible with 
                    |Empty e -> e.p
                    |Noeud n -> n.p;
            }
    in
        (* Le parent de noeudCible voit son enfant noeudCible remplacé par le nouveau noeud interne (si le parent existe) *)
        (match noeudCible with
            | Empty e -> (match e.p with
                            | Some parent -> Arbre.remplacerEnfant parent noeudCible nouveauInterne
                            | None -> () (* pas de parent : cible est racine *)
                        )  
            | Noeud n -> (match n.p with
                            | Some parent -> Arbre.remplacerEnfant parent noeudCible nouveauInterne
                            | None -> () (* pas de parent : cible est racine *)
                        )
        );
    
        (* Le nouveau noeud interne devient parent du noeudCible et de la nouvelleFeuille *)
        Arbre.mettre_parent noeudCible nouveauInterne;
        Arbre.mettre_parent nouvelleFeuille nouveauInterne;

        (* Mise à jour des tableaux, on ajoute notamment les 2 nouveaux noeuds dans les tableaux *)
        a.noeuds.(nb_noeuds) <- nouveauInterne;
        a.noeuds.(nb_noeuds+1) <- nouvelleFeuille;
        a.feuilles.(nb_feuilles) <- nouvelleFeuille;

        (* On renvoit le nouveau noeud interne *)
        nouveauInterne


(** Crée récursivement un nouvel arbre, en modifiant à chaque récursion un arbre créé lors du cas de base.
    Cette modification revient à insérer dans la structure 2 nouveaux noeuds (1 interne et 1 feuille) à chaque itération récursive.
    @param n Le nombre de noeuds internes à ajouter successivement dans un arbre, pour arriver à l'arbre voulu.
    @param nInitial Le paramètre [n] initial (le nombre total de noeuds internes dans l'arbre final).
    @return Un triplet (a, nb_noeuds, nb_feuilles) où :
    - [a] est l’arbre construit après ajouts successifs.
    - [nb_noeuds] est le nombre de noeuds (internes + feuilles) dans l'arbre [a].
    - [nb_feuilles] est le nombre de feuilles dans l'arbre [a].
*)
let rec creeArbreRemy (n : int) (nInitial : int) : Arbre.arbre * int * int =
    (* Cas de base, un arbre avec une unique feuille *)
    if n <= 0 
        (* Dans un arbre final de taille n, on aura alors 2*n+1 noeuds au total, et n+1 feuilles : nécessité d'initialiser la structure avec des tableaux de ces tailles *)
        then (Arbre.arbre_vide ((2*nInitial)+1) (nInitial+1), 1, 1)
    else
        
        let a, nb_noeuds, nb_feuilles = creeArbreRemy (n-1) nInitial in (* On récupère récursivement l'arbre nécessaire *)
        let i = Random.int nb_noeuds in
        let cible = a.noeuds.(i) in (* On choisit de manière uniforme l'un des noeuds de l'arbre *)
        let nouveauInterne = ajouteNoeudRemy cible a nb_noeuds nb_feuilles in (* On ajoute les nouveaux noeuds en place dans l'arbre *)
        (* Mise à jour de la racine si nécessaire *)
        if Arbre.egaliteNoeuds a.racine cible then
        a.racine <- nouveauInterne;
        a, nb_noeuds+2, nb_feuilles+1 (* On renvoit l'arbre mis à jour *)


(** Applique l'algorithme de Rémy, en appelant creeArbreRemy avec n pour les 2 paramètres.
    @param n La taille de l'arbre (en nombre de noeuds internes) à créer.
    @return L'arbre ayant n noeuds internes, après ajouts successifs.
*)
let algoRemy (n : int) : Arbre.arbre = 
    let arbreFinal, nb_noeuds, nb_feuilles = creeArbreRemy n n
    in arbreFinal