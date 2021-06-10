res = {
    results: [
        {id: 3498,
         slug: "grand-theft-auto-v",
         released: "2011-04-18"
        },
        {id: 4200,
         slug: "portal-2",
         released: "2011-04-18"
        }
    ]
}

res[:results].each_index do |index|
 puts res[:results][index][:slug]
end

res = {
    data: {
      success: true,
      cards: [
          {
            image: "https://deckofcardsapi.com/static/img/KH.png",
            value: "KING",
            suit: "HEARTS",
            code: "KH"
          },
          {
            image: "https://deckofcardsapi.com/static/img/8C.png",
            value: "8",
            suit: "CLUBS",
            code: "8C"
          },
          {
            image: "https://deckofcardsapi.com/static/img/4S.png",
            images: {
              svg: "https://deckofcardsapi.com/static/img/4S.svg",
              png: "https://deckofcardsapi.com/static/img/4S.png"
            },
            value: "4",
            suit: "SPADES",
            code: "4S",
          }        
      ],
      deck_id: "3p40paa87x90",
      remaining: 50
    }
  }

puts res[:data][:cards][0][:image]