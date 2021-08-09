# Campa

[![travis build (shildes.io) badge](https://img.shields.io/travis/com/mistersourcerer/campa?style=plastic "Build Status")](https://travis-ci.com/github/mistersourcerer/campa)
[![coverage (shildes.io) badge](https://img.shields.io/codeclimate/coverage/mistersourcerer/campa?style=plastic "Coverage Status")](https://codeclimate.com/github/mistersourcerer/campa)
[![gem version (shildes.io) badge](https://img.shields.io/gem/v/campa?include_prereleases&style=plastic "Version")](https://rubygems.org/gems/campa)
[![yard docs](http://img.shields.io/badge/yard-docs-blue.svg?style=plastic)](http://rubydoc.info/github/mistersourcerer/campa "Docs")

Um [LISP](https://www.britannica.com/technology/LISP-computer-language) implementado em Ruby.

[![XKCD lisp cycles comic strip](https://imgs.xkcd.com/comics/lisp_cycles.png)](https://xkcd.com/297/)

Vem equipado com um [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)
e um framework de testes (extremamente rudimentar).

Você pode instalar essa gem normalmente com:

    $ gem install campa

E depois é possível iniciar o REPL:

    $ campa

Um prompt será exibido
sinalizando que você pode verificar se *Campa* está funcionando
através de um oferecimento aos deuses da programação:

    => (defun hello-world () (print "hello world"))
    (lambda () (print "hello world"))
    => (hello-world)
    "hello world"NIL

## O que é isso tudo afinal?

Antes de mais nada
você provavelmente precisa saber que,
em termos de implementação de LISP,
essa aqui certamente está do lado EXAGERADAMENTE simples
do dispostivo de medição - seja lá qual for essa ferramenta.

<img src="https://i.chzbgr.com/full/6819818496/h1DC5249B/measurement-fail" width="300" />

O principal propósito desse projeto
é a criação de um ambiente
para que o autor possa aprender sobre LISP
e implementação de linguagens de programação.
Eu aconselharia uma baixa na proverbial expectativa
antes de usar/ler isso aqui.


### Paul Graham's The Roots of Lisp

Existe esse artigo por [Paul Graham](http://www.paulgraham.com/)
chamado [The Roots of Lisp](http://www.paulgraham.com/rootsoflisp.html).
Até onde consigo dizer esse é um trabalho seminal
[que auxiliou muitos a entenderem LISP melhor](https://hn.algolia.com/?dateRange=all&page=0&prefix=false&query=%22roots%20of%20lisp%22&sort=byPopularity&type=story)
e talvez até tenha feito [as ideias originais de McCarthy](https://crypto.stanford.edu/~blynn/lambda/lisp.html)
ainda mais acessíveis.

Essa implementação de **LISP** cobre apenas
as funções exemplificadas pelo artigo de Graham.
O que quer dizer que alguém pode implementar *Campa* nela mesmo
(ou poderiam furar a fila e [ver aqui](../main/campa/core.cmp)
como isso já foi feito).

## Usando

### Executando arquivos .cmp

Considere um arquivo `hello.cmp`
com o seguinte código *Campa*:

```lisp
(defun hello (stuff) (print "hello" stuff))
(label thing "Marvin")

(hello thing)
```

Você pode executar esse código
usando o comando *campa*:

    $ campa hello.cmp
    hello Marvin

Note que as funções *print* e *println*
são oferecidas "gratuitamente" ao usuário
já que não são especificadas em *Roots of Lisp*.
Mas mais sobre isso depois.

### Brincando no REPL

Se você está interessado em testar algumas ideias
antes de se comprometer com elas a ponto de criar um arquivo
(ou adicioná-las ao controle de versão)
é possível fazê-lo em uma sessão do *repl* através do comando *campa*:

    $ campa
    =>

O símbolo **=>** é o *prompt*
esperando pela entrada de código.

Vou usar essa oportunidade para mostrar
outra função que vem com essa implementação
mas não é parte de *Roots of Lisp*.
Vamos carregar (*load*) o mesmo arquivo que foi usado
no exemplo anterior
na atual sessão do *REPL*.

    => (load "./hello.cmp")
    hello  MarvinNIL

O **NIL** mostrado logo depois da mensagem (hello Marvin)
é o valor returnado pela função *print*.

Note também que a função *hello*,
declarada no arquivo *hello.cmp*,
agora está disponível na sessão.

    => (hello "World")
    hello  WorldNIL

## As Raízes

As seguintes funções estão disponíveis
e são consideradas o cerne (**core**) dessa implementação de LISP.
Todas elas tem o comportamento especificado
no já mencionado [*The Roots of Lisp*](http://www.paulgraham.com/rootsoflisp.html).

```lisp
(atom thing)
(car list)
(cdr list)
(cond ((condition) some-value) ((other-condition) other-value))
(cons 'new-head '(list with stuffz))
(defun func-name (params, more-params) (do-something))
(eq 'meaning-of-life 42)
(label a-symbol 4,20)
(lambda (params, more-params) (do-something))
(list 'this 'creates 'a 'list 'with 'all 'given 'params)
(quote '(a b c))
```

Além das funções em si
o uso de aspas simples (') como notação
para *quote* de objetos também foi implementado em *runtime*.

### Detalhes de implementação

Essas funções foram todas implementadas em Ruby
[e vivem aqui](../3b43a21/lib/campa/lisp).

## Além das Raízes

Nesse Readme algumas menções foram feitas
a respeito de funções/funcionalidades de *Campa*
que não foram especificadas em *Roots of Lisp*.

São basicamente dois tipos de "coisas":
as implementadas em código *Campa*
e as implementadas em *runtime* (código Ruby).

### Extras em Campa

  - [(assert x y)](../3b43a21/campa/test.cmp#L1)
    Retorna **true** se x e y forem *eq*

### Extras em Ruby (runtime)

  - [(load a-file another-file)](../3b43a21/lib/campa/core/load.rb)
    Lê e evalua os arquivos dados como parâmetro
  - [(print "some" "stuff" 4 '("even" "lists"))](../3b43a21/lib/campa/core/print.rb)
    Printa o parâmetro em uma representação amigável para humanos
  - [(println stuffz here)](../3b43a21/lib/campa/core/println.rb)
    Mesmo que *print* mas adiciona nova linha (`\n`) após cada parâmetro

#### Testes

Há também um framework de testes muito simples
implementado em runtime.
Isto é disponibilizado através do comando *campa*
seguido da opção **test**.
O comando recebe como parâmetro arquivos contendo... testes.

A definição de um teste nesse contexto é
qualquer função que comece como *test-* ou *test_* (case insensitive)
e retorna *true* para sucesso
ou *false* para falha.
A "parte LISP" de *Campa* usa essa ferramenta
e você pode [verificar como aqui](../3b43a21/test/core_test.cmp).

    $ campa test test/core_test.cmp

    10 tests ran
    Success: none of those returned false

Internamente esse "framework" é formado
pelas duas funções a seguir:

  - [(tests-run optional-name other-optional-name)](../3b43a21/lib/campa/core/test.rb)
  - [(tests-report (tests-run))](../3b43a21/lib/campa/core/test_report.rb)

##### (tests-run)

A função *tests-run* encontra
qualquer função com nomes no padrão *test-* ou *test_* (case insensitive)
no contexto atual e as executa.
Uma função que retorne *false*
é considerada uma falha.

Podemos simular isso claramente no REPL:

    $ campa
    => (defun test-one () "do nothing" false)
    (lambda () "do nothing" false)
    => (defun test-two () "great success" true)
    (lambda () "great success" true)
    => (tests-run)
    ((success (test-two)) (failures (test-one)))

Essa estrutura de dados retornada por *tests-run*
é muito conhecida de uma segunda função...

##### (tests-report)

... podemos usar a função *tests-report*
para aparesentar um bom resumo dos testes executados:

    => (tests-report (tests-run))
    2 tests ran
    FAIL!
      1 tests failed
      they are:
        - test-one
    false

Perceba que *tests-report* retorna *false* se houver falha
ou *true* se todos os testes passam.
Isso é um jeito fácil de integrar essa ferramenta
com ambientes de CI ou qualquer tipo de build "progressivo".

Um exemplo de como isso é usado
nessa implementação [pode ser lido aqui](../3b43a21/Rakefile#L12).


## Desenvolvimento

Depois de fazer o check out do repositório,
rode `bin/setup` para instalar dependências.
Então execute `rake spec` para rodar os testes.
Você também pode executar `bin/console`
para iniciar um prompt interativo para experimentos.

Para instalar essa gem localmente execute `bundle exec rake install`.

## Contributing

Bug reports e pull requests são bem vindos no GitHub em https://github.com/mistersourcerer/campa.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
