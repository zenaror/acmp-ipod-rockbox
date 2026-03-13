# Animal Crossing Music Player - Rockbox (iPod Video 5th gen)

Esse projeto é baseado no código já existe de um projeto em python do [acmp - Animal Crossing Music Player](https://github.com/mjdargen/acmp), e que depois fiz algumas alterações [*aqui*](https://github.com/zenaror/acmp) para a geolocalização ser parametros, e não por IP.

Tudo que fiz, para essa versão, foi portar para LUA, para que pudesse ser usado no [Rockbox](https://www.rockbox.org/).

## O que faz?
O script basicamente imita o comportamento do jogo, permitindo tocar uma música durante o período de 1 hora.

Como o dispositivo não tem GPS ou acesso a internet, você pode tocar o clima manualmente.

Você não precisa usar necessáriamente o conteúdo do jogo, pode personalizar ao seu gosto!

Caso você altere o jogo/clima durante uma execução, a nova música será executada após o termino da atual em reprodução.

## Instalação
Para instalar, coloque o arquivo `acmp.lua` no diretório `/.rockbox/rocks/apps/`

Você também vai precisar das músicas. Para isso, pode usar as músicas do repositório original. Coloque eles em uma pasta na raiz chamada `acmp-ipod`. Você só precisa das pastas `animal-crossing`, `wild-world`, `new-leaf`, `new-horizons`.

Um detalhe, a pasta `animal-crossing` NÃO POSSUI musicas para clima cuvoso baseado em hora. Você precisa conseguir ela de alguma forma, e renomear apenas como `raining.mp3` e colocar na pasta respectiva.
