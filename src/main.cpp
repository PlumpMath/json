//#include <json-b4dbebf.hpp>
//#include <json-c2e80a7.hpp>
#include <json-c2e80a7-fixed.hpp>
#include <string>

int main(int argc, char* argv[]) {
  using json = nlohmann::json;
  json v = "test";
  std::string test;
  test = v;
  return 0;
}