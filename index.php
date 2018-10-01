<?php
//1. Придумать класс, который описывает любую сущность из предметной области интернет-магазинов: продукт, ценник, посылка и т.п.
//2. Описать свойства класса из п.1 (состояние).
//3. Описать поведение класса из п.1 (методы).
//4. Придумать наследников класса из п.1. Чем они будут отличаться?

class Item
{
    public $id;
    public $category;
    public $brand;
    public $model;
    public $characteristics=[];
    public $price;
    public $description;

    function __construct($id, $category, $brand, $model, $characteristics, $price, $description)
    {
        $this -> id = $id;
        $this -> category = $category;
        $this -> brand = $brand;
        $this -> model = $model;
        $this -> characteristics = $characteristics;
        $this -> price = $price;
        $this -> description = $description;
    }

    public function getItem()
    {
        return [
            'id' => $this -> id,
            'category' => $this -> category,
            'brand' => $this -> brand,
            'model' => $this -> model,
            'characterisrics' => $this -> characteristics,
            'price' => $this -> price,
            'description' => $this -> description
        ];
    }
};

//$renault19 = new Item(1, 'cars', 'renault', '19', [], 20000, 'lorem');
//var_dump($renault19 -> getItem());

class ItemModification extends Item
{
    public $id;
    public $color;
    public $version;
    public $extraCharge;
    public $price;

    public function __construct($id, $category, $brand, $model, $characteristics, $price, $description, $color, $version, $extraCharge)
    {
       $this -> id = $id;
       $this -> category = $category;
       $this -> brand = $brand;
       $this -> model = $model;
       $this -> characteristics = $characteristics;
       $this -> price = $price;
       $this -> description = $description;
       $this -> color = $color;
       $this -> version = $version;
       $this -> extraCharge = $extraCharge;
    }


    public function getItemModification()
    {
        return [
            'id' => $this -> id,
            'category' => $this -> category,
            'brand' => $this -> brand,
            'model' => $this -> model,
            'characterisrics' => $this -> characteristics,
            'price' => $this -> price + $this -> extraCharge,
            'description' => $this -> description,
            'color' => $this -> color,
            'version' => $this -> version
        ];
    }
}
//$renault19 = new ItemModification(1, 'cars', 'renault', '19', [], 20000, 'lorem', 'blue', '1.4', 2000);
//var_dump($renault19 -> getItemModification());

//5. Дан код:
//Что он выведет на каждом шаге? Почему?

//class A {
//    public function foo() {
//        static $x = 0;
//        echo ++$x;
//    }
//}
//$a1 = new A();
//$a2 = new A();
//$a1->foo(); - выведет 1, т.к. выполнилась foo() и $x стала равна 1.
//$a2->foo(); - выведет 2, т.к. $x на предыдущем щаге в самом классе была перезаписана на 1, поскольку она static, выполнилась foo() и $x стала равна 2.
//$a1->foo(); - выведет 3.
//$a2->foo(); - выведет 4.


// Немного изменим п.5:
//6. Объясните результаты в этом случае.

//class A {
//    public function foo() {
//        static $x = 0;
//        echo ++$x;
//    }
//}
//class B extends A {
//}
//$a1 = new A();
//$b1 = new B();
//$a1->foo(); - выведет 1, выполнилась foo() объекта new A(), при этом $x в классе перезаписана на 1, поскольку она static.
//$b1->foo(); - выведет 1, выполнилась foo() объекта new B(), при этом $x в классе перезаписана на 1, поскольку она static.
//$a1->foo(); - выведет 2, 2-й раз выполнилась foo() объекта new A().
//$b1->foo(); - выведет 2, 2-й раз выполнилась foo() объекта new B().

?>
