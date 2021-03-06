library model;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:convert';
import 'events.dart';
import 'cards.dart';

class Model extends Object with Observable {
  // paths
  static const String DECK_DATA_PATH = "resources/data/decks/";
  static const String DECK_DATA_FILENAME = "_decks.json";
  static const String IMAGES_PATH = "resources/images/";

  final List<Deck> decks = toObservable([]);
  @observable Deck currentDeck;
  @observable int numCards;   // difficulty is determined by how many cards are used in a game
  final List<int> difficulties = const [4, 6, 8, 12];

  Model() {
    HttpRequest.getString("$DECK_DATA_PATH$DECK_DATA_FILENAME").then((String jsonStr) {
      List<Map<String, String>> deckMaps = JSON.decode(jsonStr);

      deckMaps.forEach((Map<String, String> deck) {
        decks.add(new Deck.fromMap(deck, DECK_DATA_PATH));
      });

      eventBus.fire(modelReadyEvent, null);
    });
  }

  void newGame() {
    // make sure selected deck has loaded its cards
    // createGameDeck() will fire deckReadyEvent when everything is loaded
    currentDeck.createGameDeck((numCards / 2).floor());
  }

  // this getter allows Polymer HTML to bind to IMAGES_PATH
  String get images_path => IMAGES_PATH;
}