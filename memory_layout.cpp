#include <iostream>

struct Empty {};

struct Base {
    int a;
    virtual void func() {}
};

struct Derived : Base {
    int b;
};

struct AlignDemo {
    char c;
    int i;
    double d;
};

int main() {
    std::cout << "sizeof(Empty): " << sizeof(Empty) << std::endl;   // 1
    std::cout << "sizeof(Base): " << sizeof(Base) << std::endl;     // 16 (int 4 + vptr 8 + 对齐)
    std::cout << "sizeof(Derived): " << sizeof(Derived) << std::endl; // 24 (Base 16 + int 4 + 对齐)
    std::cout << "sizeof(AlignDemo): " << sizeof(AlignDemo) << std::endl; // 16 (char 1 + 填充 + int 4 + double 8)

    // 打印地址偏移（需要取成员地址，但虚函数表地址不可直接取）
    Base b;
    std::cout << "Address of b: " << &b << std::endl;
    std::cout << "Address of b.a: " << &(b.a) << std::endl;
    // 观察地址差：通常 vptr 在对象开头，然后才是成员 a

    return 0;
}