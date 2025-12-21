(** experimentation.ml : comparaison des algorithmes ABR et Remy*)

(**parcours récursivement l'arbre pour calculer la hauteur
	@param a arbre
	@return la hauteur de l'arbre
*)
let hauteur_arbre (a : Arbre.arbre) : int =
	
	let rec aux (n : Arbre.noeud) : int =
		match n with 
		| Arbre.Empty e -> 0
		| Arbre.Noeud n -> 
			let hauteurG = aux n.g in
			let hauteurD = aux n.d in
			if hauteurG > hauteurD then 1 + hauteurG else 1 + hauteurD
	
	in aux a.racine


(** récupère le nombre de noeud dans le sous arbre gauche
	@param a arbre
	@return le nombre de noeud du sous arbre gauche 
*)
let taille_sous_arbre_gauche (a : Arbre.arbre) : int =
	match a.racine with
	| Arbre.Empty e -> 0
	| Arbre.Noeud n -> 
		let ss_arbre_g = {Arbre.racine = n.g; Arbre.noeuds = [||]; Arbre.feuilles = [||]} in
		let nb_noeuds, _ = Arbre.getNbNoeuds ss_arbre_g in
		nb_noeuds

(**Calcul de la largeur de l'arbre (nombre maximal de nœuds à une même profondeur),
	@param a arbre
	@return la largeur de l'arbre
*)
let largeur_arbre (a : Arbre.arbre) : int =

	let rec aux (queue : Arbre.noeud list) (maxw : int) : int =
		match queue with
		| [] -> maxw
		| _ ->
			let level_count = List.length queue in
			let next_rev =
				List.fold_left (fun acc n ->
					match n with
				| Arbre.Empty _ -> acc
				| Arbre.Noeud n -> n.d :: n.g :: acc
				) [] queue
			in
			aux (List.rev next_rev) (if level_count > maxw then level_count else maxw)
	in
	aux [a.racine] 0
		
(** Calcul de la moyenne d'une liste de nombres *)
let moyenne (l : float list) : float =
	match l with
	| [] -> 0.0
	| _ ->
		let sum = List.fold_left (fun x y -> x +. y) 0.0 l in
		sum /. float_of_int (List.length l)


(**Calcul de la profondeur moyennes des feuilles d'un arbre
	@param a arbre
	@return la profondeur moyennes des feuille de l'arbre
*)
let profondeur_moyenne (a : Arbre.arbre) : float = 
    let rec aux (n : Arbre.noeud) (p : int) : int * int =
        match n with
        | Arbre.Empty _ -> (p, 1)
        | Arbre.Noeud n ->
            let (somme_g, nb_g) = aux n.g (p + 1) in
            let (somme_d, nb_d) = aux n.d (p + 1) in
            (somme_g + somme_d, nb_g + nb_d)
    in 
    let (somme, nb) = aux a.racine 0 in
    if nb = 0 then 0.0 else (float_of_int somme) /. (float_of_int nb)

let () =

	if Array.length Sys.argv < 3 then
		Printf.printf "Usage: %s <fichier_res.csv> <nb_arbres>\n" Sys.argv.(0)
	else
		
	Printf.printf "Calcul des datas ...\n%!";

	(* ouverture du fichier csv *)
	let oc  = open_out Sys.argv.(1) in

	(* taille maximale des arbres *)
	let max_arbres = int_of_string Sys.argv.(2) in 

	(* écriture de l'entête du csv *)
	Printf.fprintf oc "taille,temps_ABR,temps_Remy,largeur_ABR,largeur_Remy,hauteur_ABR,hauteur_Remy,taille_ssarbre_g_ABR,taille_ssarbre_g_Remy,prof_moy_ABR,prof_moy_Remy\n";

	let rec boucler_tailles i =
		if i > max_arbres then ()
		else begin 
			let taille = i * 1000 in

        	let rec boucler_simulations j acc_ABR acc_Remy =
          		match j with
				| 0 ->  (acc_ABR, acc_Remy)
				| _ -> 
					(* calcul des temps d'exécution *)
					let debut_ABR = Sys.time () in
					let arbre_ABR = ABR.algoABR taille in
					let fin_ABR = Sys.time () in
					
					let debut_Remy = Sys.time() in  
					let arbre_Remy = Remy.algoRemy taille in
					let fin_Remy = Sys.time() in
            
					(* On déstructure les accumulateurs actuels *)
					let (t_ABR, h_ABR, g_ABR, l_ABR, p_ABR) = acc_ABR in
					let (t_Remy, h_Remy, g_Remy, l_Remy, p_Remy) = acc_Remy in

		            (* Mise à jour des accumulateurs ABR *)
					let new_acc_ABR = (
					(fin_ABR -. debut_ABR) :: t_ABR,
					(hauteur_arbre arbre_ABR) :: h_ABR,
					(taille_sous_arbre_gauche arbre_ABR) :: g_ABR,
					(largeur_arbre arbre_ABR) :: l_ABR,
					(profondeur_moyenne arbre_ABR) :: p_ABR
					) in

					(* Mise à jour des accumulateurs Remy *)
					let new_acc_Remy = (
					(fin_Remy -. debut_Remy) :: t_Remy,
					(hauteur_arbre arbre_Remy) :: h_Remy,
					(taille_sous_arbre_gauche arbre_Remy) :: g_Remy,
					(largeur_arbre arbre_Remy) :: l_Remy,
					(profondeur_moyenne arbre_Remy) :: p_Remy
					) in

					(* Appel récursif *)
					boucler_simulations (j - 1) new_acc_ABR new_acc_Remy
			in

			(* Lancement des 100 simulations avec des listes vides au départ *)
			let (res_ABR, res_Remy) = boucler_simulations 100 ([],[],[],[],[]) ([],[],[],[],[]) in
			
			(* Déstructuration des résultats finaux *)
			let (list_t_ABR, list_h_ABR, list_g_ABR, list_l_ABR, list_p_ABR) = res_ABR in
			let (list_t_Remy, list_h_Remy, list_g_Remy, list_l_Remy, list_p_Remy) = res_Remy in

			(* calcul des moyennes *)
			let moy_temps_ABR = moyenne list_t_ABR in
			let moy_temps_Remy = moyenne list_t_Remy in

			let moy_hauteur_ABR = int_of_float (moyenne (List.map float_of_int list_h_ABR)) in
			let moy_hauteur_Remy = int_of_float (moyenne (List.map float_of_int list_h_Remy)) in

			let moy_taille_ssarbre_g_ABR = int_of_float (moyenne (List.map float_of_int list_g_ABR)) in
			let moy_taille_ssarbre_g_Remy = int_of_float (moyenne (List.map float_of_int list_g_Remy)) in

			let moy_largeur_ABR = int_of_float (moyenne (List.map float_of_int list_l_ABR)) in
			let moy_largeur_Remy = int_of_float (moyenne (List.map float_of_int list_l_Remy)) in

			let moy_prof_moy_ABR = moyenne list_p_ABR in
			let moy_prof_moy_Remy = moyenne list_p_Remy in

			(* affichage console *)
			Printf.printf "Pour taille = %d\n%!" taille;	
			Printf.printf "temps ABR = %f\n%!" moy_temps_ABR; 
			Printf.printf "temps Remy = %f\n%!" moy_temps_Remy;
			Printf.printf "hauteur ABR = %d\n%!" moy_hauteur_ABR; 
			Printf.printf "hauteur Remy = %d\n%!" moy_hauteur_Remy;
			Printf.printf "largeur ABR = %d\n%!" moy_largeur_ABR;
			Printf.printf "largeur Remy = %d\n%!" moy_largeur_Remy;
			Printf.printf "taille sous arbre gauche ABR = %d\n%!" moy_taille_ssarbre_g_ABR; 
			Printf.printf "taille sous arbre droit Remy = %d\n%!" moy_taille_ssarbre_g_Remy;
			Printf.printf "Profondeur moyenne des feuilles ABR = %f\n%!" moy_prof_moy_ABR; 
			Printf.printf "Profondeur moyenne des feuilles Remy = %f\n%!" moy_prof_moy_Remy; 

			(* ecriture des données dans le csv *)
			Printf.fprintf oc "%d,%f,%f,%d,%d,%d,%d,%d,%d,%f,%f\n" 
				taille 
				moy_temps_ABR 
				moy_temps_Remy
				moy_largeur_ABR
				moy_largeur_Remy
				moy_hauteur_ABR  
				moy_hauteur_Remy  
				moy_taille_ssarbre_g_ABR
				moy_taille_ssarbre_g_Remy
				moy_prof_moy_ABR
				moy_prof_moy_Remy;

			(* Appel récursif *)
			boucler_tailles (i + 1)
		end
	in

	boucler_tailles 1;
	
	close_out oc;
