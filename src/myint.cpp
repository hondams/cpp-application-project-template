#include "myint.h"

MyInt::MyInt(int num)
:num_(num)
{}

bool MyInt::isOdd()
{
  // ����ǂ����𔻒肷��
  return (num_ % 2) != 0 ? true : false;
}

bool MyInt::isEven()
{
  return isOdd();  // ��Ƃ��āA�����Ƀo�O������
}
