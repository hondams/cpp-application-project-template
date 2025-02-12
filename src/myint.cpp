#include "myint.h"

MyInt::MyInt(int num)
:num_(num)
{}

bool MyInt::isOdd()
{
  // Šï”‚©‚Ç‚¤‚©‚ğ”»’è‚·‚é
  return (num_ % 2) != 0 ? true : false;
}

bool MyInt::isEven()
{
  return isOdd();  // —á‚Æ‚µ‚ÄA‚±‚±‚ÉƒoƒO‚ª‚ ‚é
}
