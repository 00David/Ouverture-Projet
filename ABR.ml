Random.self_init ();;

type noeud = Empty of int | Noeud of int * noeud * noeud

(* Écriture DOT *)
let ecritureArborecence (racine : noeud) (fichier : string) =
  let oc = open_out fichier in
  Printf.fprintf oc "graph Arbre {\n";
  Printf.fprintf oc "  node [fontname=\"Arial\"];\n";
  let rec aux n =
    match n with
    | Empty(id) -> Printf.fprintf oc "  n%d [label=%d, shape=box];\n" id id
    | Noeud(id, g, d) ->
        Printf.fprintf oc "  n%d [label=%d, shape=circle];\n" id id;
        Printf.fprintf oc "  n%d -- n%d[penwidth=20];\n" id (match g with Empty(idg)|Noeud(idg,_,_) -> idg);
        aux g;
        Printf.fprintf oc "  n%d -- n%d[penwidth=20];\n" id (match d with Empty(idd)|Noeud(idd,_,_) -> idd);
        aux d
  in
  aux racine;
  Printf.fprintf oc "}\n";
  close_out oc;
  Printf.printf "Fichier .dot de l'arbre généré dans %s\n" fichier

(* Génération des feuilles initiales avec IDs uniques *)
let generate_feuilles n =
  Array.init n (fun i -> Empty(i+1))

(* Algorithme ABR linéaire + aléatoire *)
let algoABR n =
  if n <= 0 then Empty(1)
  else
    let feuilles = generate_feuilles (n+1) in
    let nbFeuilles = ref (n+1) in
    let internes = ref [] in
    let cpt = ref (n+2) in  (* prochain ID pour les internes *)

    for _ = 1 to n do
      (* Options possibles *)
      let options = ref [] in
      if !nbFeuilles >= 2 then options := "ff" :: !options;
      if !nbFeuilles >= 1 && !internes <> [] then options := "fi" :: !options;
      if List.length !internes >= 2 then options := "ii" :: !options;

      let choix = List.nth !options (Random.int (List.length !options)) in

      match choix with
      | "ff" ->
          (* Tirage aléatoire de deux feuilles distinctes *)
          let idx1 = Random.int !nbFeuilles in
          let idx2 = Random.int (!nbFeuilles-1) in
          let idx2 = if idx2 >= idx1 then idx2+1 else idx2 in
          let f1 = feuilles.(idx1) in
          let f2 = feuilles.(idx2) in
          let nouveau = Noeud(!cpt, f1, f2) in
          (* Remplacer f1 par le nouveau, supprimer f2 *)
          feuilles.(idx1) <- nouveau;
          feuilles.(idx2) <- feuilles.(!nbFeuilles - 1);
          nbFeuilles := !nbFeuilles - 1;
          cpt := !cpt + 1
      | "fi" ->
          let idxf = Random.int !nbFeuilles in
          let f = feuilles.(idxf) in
          let i = List.hd !internes in
          let nouveau = Noeud(!cpt, f, i) in
          feuilles.(idxf) <- nouveau;        (* Remplacer la feuille *)
          internes := List.tl !internes;    (* Retirer l'interne utilisé *)
          cpt := !cpt + 1
      | "ii" ->
          let i1 = List.hd !internes in
          let i2 = List.nth !internes 1 in
          let nouveau = Noeud(!cpt, i1, i2) in
          internes := nouveau :: List.tl (List.tl !internes);
          cpt := !cpt + 1
      | _ -> failwith "Cas non géré"
    done;

    (* Racine finale *)
    if !internes = [] then feuilles.(0) else List.hd !internes

(* Affichage simple *)
let rec afficherArborescence n =
  match n with
  | Noeud(id,g,d) ->
      Printf.printf "Noeud%d(" id;
      afficherArborescence g;
      Printf.printf ",";
      afficherArborescence d;
      Printf.printf ")"
  | Empty(id) -> Printf.printf "Empty%d" id

(* Entrée *)
let () =
  if Array.length Sys.argv < 2 then
    Printf.printf "Usage: %s <taille_arbre>\n" Sys.argv.(0)
  else
    let n = int_of_string Sys.argv.(1) in
    let racine = algoABR n in
    afficherArborescence racine;
    Printf.printf "\n";
    ecritureArborecence racine "arbreABR.dot"
