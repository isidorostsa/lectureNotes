#include <iostream>
#include <set>
#include <vector>

int main() {
    std::vector<int> v;
    for (int i = 0; i < 100; i++) {
        v.push_back(i);
        v.push_back(i*i);
    }

    std::set<int> s(v.begin(), v.end());

    for(std::set<int>::iterator it = s.begin(); it != s.end(); it++) {
        std::cout << std::distance(s.begin(), it) << std::endl;
    }
}