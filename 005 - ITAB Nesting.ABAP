"----------------------------------------------------------------------------------------------------------------------------------------

*Instructions
*Learn how to combine data from three different internal tables into one result internal table while nesting the associated data.
*
*Your class will be given three internal tables which contain three completely different datasets, ARTISTS, ALBUMS, and SONGS.
*
*TYPES: BEGIN OF artists_type,
*         artist_id   TYPE string,
*         artist_name TYPE string,
*       END OF artists_type.
*TYPES: artists TYPE STANDARD TABLE OF artists_type WITH KEY artist_id.
*TYPES: BEGIN OF albums_type,
*         artist_id  TYPE string,
*         album_id   TYPE string,
*         album_name TYPE string,
*       END OF albums_type.
*TYPES: albums TYPE STANDARD TABLE OF albums_type WITH KEY artist_id album_id.
*TYPES: BEGIN OF songs_type,
*         artist_id TYPE string,
*         album_id  TYPE string,
*         song_id   TYPE string,
*         song_name TYPE string,
*       END OF songs_type.
*TYPES: songs TYPE STANDARD TABLE OF songs_type WITH KEY artist_id album_id song_id.
*The data in the ARTISTS table is as shown below.
*
*ARTIST_ID	ARTIST_NAME
*1	Godsmack
*2	Shinedown
*The data in the ALBUMS table is as shown below.
*
*ARTIST_ID	ALBUM_ID	ALBUM_NAME
*1	1	Faceless
*1	2	When Lengends Rise
*2	1	The Sound of Madness
*2	2	Planet Zero
*The data in the SONGS table is as shown below.
*
*ARTIST_ID	ALBUM_ID	SONG_ID	SONG_NAME
*1	1	1	Straight Out Of Line
*1	1	2	Changes
*1	2	1	Bullet Proof
*1	2	2	Under Your Scars
*2	1	1	Second Chance
*2	1	2	Breaking Inside
*2	2	1	Dysfunctional You
*2	2	2	Daylight
*Your task is to return an internal table with records which combine the values of each internal table in a structured way, 
*nesting the SONGS internal table into the ALBUMS internal table and of course nesting the ALBUMS internal table into the ARTISTS internal table.
*
*The expected return table has the following definition:
*
*TYPES: BEGIN OF song_nested_type,
*         song_id   TYPE string,
*         song_name TYPE string,
*       END OF song_nested_type.
*TYPES: BEGIN OF album_song_nested_type,
*         album_id   TYPE string,
*         album_name TYPE string,
*         songs      TYPE STANDARD TABLE OF song_nested_type WITH KEY song_Id,
*       END OF album_song_nested_type.
*TYPES: BEGIN OF artist_album_nested_type,
*         artist_id   TYPE string,
*         artist_name TYPE string,
*         albums      TYPE STANDARD TABLE OF album_song_nested_type WITH KEY album_id,
*       END OF artist_album_nested_type.
*TYPES: nested_data TYPE STANDARD TABLE OF artist_album_nested_type WITH KEY artist_id.
*Bonus
*There are many ways to accomplish this task in ABAP. How efficiently can you complete the task?

"----------------------------------------------------------------------------------------------------------------------------------------

report zexercism.


class zcl_itab_nesting definition
  final
  create public .

  public section.

    types: begin of artists_type,
             artist_id   type string,
             artist_name type string,
           end of artists_type.
    types artists type standard table of artists_type with key artist_id.
    types: begin of albums_type,
             artist_id  type string,
             album_id   type string,
             album_name type string,
           end of albums_type.
    types albums type standard table of albums_type with key artist_id album_id.
    types: begin of songs_type,
             artist_id type string,
             album_id  type string,
             song_id   type string,
             song_name type string,
           end of songs_type.
    types songs type standard table of songs_type with key artist_id album_id song_id.


    types: begin of song_nested_type,
             song_id   type string,
             song_name type string,
           end of song_nested_type.
    types: begin of album_song_nested_type,
             album_id   type string,
             album_name type string,
             songs      type standard table of song_nested_type with key song_id,
           end of album_song_nested_type.
    types: begin of artist_album_nested_type,
             artist_id   type string,
             artist_name type string,
             albums      type standard table of album_song_nested_type with key album_id,
           end of artist_album_nested_type.
    types nested_data type standard table of artist_album_nested_type with key artist_id.

    methods perform_nesting
      importing
        artists            type artists
        albums             type albums
        songs              type songs
      returning
        value(nested_data) type nested_data.

  protected section.
  private section.
endclass.

class zcl_itab_nesting implementation.

  method perform_nesting.
    
    "tabelas e estruturas
    data: it_artists     type artists,                       "tabela de entrada
          it_albums      type albums,                        "tabela de entrada
          it_songs       type songs,                         "tabela de entrada
          it_nested_data type nested_data,                   "tabela de saida
          ls_nested_data like line of it_nested_data,        "estrutura da tabela de saida
          ls_album       like line of ls_nested_data-albums, "estrutura da tabela da tabela de saida
          ls_song        like line of ls_album-songs.        "estrutura da tabela da tabela da tabela de saida

"                                        teste
*    it_artists = value #( ( artist_id = 1 artist_name = 'Godsmack' )
*                          ( artist_id = 2 artist_name = 'Shinedown' ) ).
*
*    it_albums = value #( ( artist_id = 1 album_id = 1 album_name = 'Faceless' )
*                         ( artist_id = 1 album_id = 2 album_name = 'When Legends Rise' )
*                         ( artist_id = 2 album_id = 1 album_name = 'The Sound of Madness' )
*                         ( artist_id = 2 album_id = 2 album_name = 'Planet Zero' ) ).
*
*    it_songs = value #( ( artist_id = 1 album_id = 1 song_id = 1 song_name = 'Straight Out Of Line' )
*                        ( artist_id = 1 album_id = 1 song_id = 2 song_name = 'Changes'              )
*                        ( artist_id = 1 album_id = 2 song_id = 1 song_name = 'Bullet Proof'         )
*                        ( artist_id = 1 album_id = 2 song_id = 2 song_name = 'Under Your Scars'     )
*                        ( artist_id = 2 album_id = 1 song_id = 1 song_name = 'Second Chance'        )
*                        ( artist_id = 2 album_id = 1 song_id = 2 song_name = 'Breaking Inside'      )
*                        ( artist_id = 2 album_id = 2 song_id = 1 song_name = 'Dysfunctional You'    )
*                        ( artist_id = 2 album_id = 2 song_id = 2 song_name = 'Daylight'             ) ).

    "tabelas recebem parametros de entrada
    it_artists = artists. 
    it_albums  = albums.
    it_songs   = songs.
    
    "sempre começamos do menor para o maior
    "iterando sobre a menor e mais importante tabela
    loop at it_artists into data(ls_data).
      "estrutura principal recebe os artistas desta tabela
      ls_nested_data-artist_id   = ls_data-artist_id.
      ls_nested_data-artist_name = ls_data-artist_name.
      "agora iteramos sobre os albums criados por estes artistas
      loop at it_albums into data(ls_data2) where artist_id eq ls_data-artist_id.
        "estrutura recebe os dados referentes ao album
        ls_album-album_id = ls_data2-album_id.
        ls_album-album_name     = ls_data2-album_name.
        "por fim, itereamos sobre as musicas dos albuns dos artistas.
        loop at it_songs into data(ls_data3) where album_id eq ls_data2-album_id.
          "estrutura recebe as musicas
          ls_song-song_id   = ls_data3-song_id.
          ls_song-song_name = ls_data3-song_name.
          
          append ls_song to ls_album-songs.

        endloop.
        "é de suma importancia limpar as estruturas no caso de tabelas aninhadas
        append ls_album to ls_nested_data-albums.
        clear ls_album.

      endloop.

      append ls_nested_data to it_nested_data.
      clear ls_nested_data.

    endloop.
    "tabela de saida recebe tabela finalmente populada
    nested_data = it_nested_data.

  endmethod.

endclass.

start-of-selection.

  data: ol_itab_nesting type ref to zcl_itab_nesting.

  create object ol_itab_nesting.

  data: itab_artists     type ol_itab_nesting->artists,
        itab_albums      type ol_itab_nesting->albums,
        itab_songs       type ol_itab_nesting->songs,
        itab_nested_data type ol_itab_nesting->nested_data.

  itab_nested_data = ol_itab_nesting->perform_nesting(
                       artists = itab_artists
                       albums  = itab_albums
                       songs   = itab_songs
                     ).

"loop para iterar sobre os dados aninhados
  loop at itab_nested_data into data(ls_artist).
    write: / 'Artist ID:', ls_artist-artist_id,
             'Artist Name:', ls_artist-artist_name.

    loop at ls_artist-albums into data(ls_album).
      write: / '  Album ID:', ls_album-album_id,
               'Album Name:', ls_album-album_name.

      loop at ls_album-songs into data(ls_song).
        write: / '    Song ID:', ls_song-song_id,
                 'Song Name:', ls_song-song_name.
      endloop.

    endloop.

  endloop.
