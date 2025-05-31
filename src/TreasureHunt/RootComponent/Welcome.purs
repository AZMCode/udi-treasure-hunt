module TreasureHunt.RootComponent.Welcome(welcome) where

import Halogen.HTML (div, h3, p_, text, button, hr, HTML, ClassName(ClassName)) as HH
import Halogen.HTML.Properties (classes) as HP
import Halogen.HTML.Events (onClick) as HE

welcome :: forall w i. i -> HH.HTML w i
welcome skip = HH.div [
        HP.classes [
                HH.ClassName "p-5",
                HH.ClassName "is-flex",
                HH.ClassName "is-flex-direction-column",
                HH.ClassName "is-align-content-center",
                HH.ClassName "is-align-content-center"
            ]
    ] [
        HH.h3 [ 
                HP.classes [ HH.ClassName "is-size-3" ]
            ] [
                HH.text "Bienvenido a la Caza de QR de E2"
            ],
        HH.p_ [
                HH.text "Hola! Soy un Estudiante de la UDI que se aburrió demasiado en clases, así que decidió hacer un juego de Realidad Alternativa!"
            ],
        HH.p_ [
                HH.text "(Bueno, si se puede llamar eso)"
            ],
        HH.p_ [
                HH.text "En resumen, he escondido muchos de éstos QRs a lo largo de toda la universidad UDI"
            ],
        HH.p_ [
                HH.text "Y si encuentras cierta cantidad de ellos, puedes descubir un mensaje secreto!"
            ],
        HH.p_ [
                HH.text "(No hay recompensa por encontrar más de el requisito)"
        ],
        HH.p_ [
                HH.text "Si no te interesa ésto, simplemente deja el QR donde lo encontraste, o mejor, escóndelo en otro lugar!"
            ],
        HH.hr [

            ],
        HH.button [
                HE.onClick \_ -> skip,
                HP.classes [ HH.ClassName "button", HH.ClassName "is-primary" ]
            ] [
                HH.text "Continuar"
            ]
    ]