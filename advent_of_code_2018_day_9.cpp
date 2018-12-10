#include <iostream>
#include <list>
#include <algorithm>
using namespace std;

list<int> circle;
list<int>::iterator current;

void next_iterator(){
  ++current;
  if(current == circle.end()){
    current = circle.begin();
  }
}

void back(){
  for(int i = 0; i < 7; i++){
    if(current == circle.begin()){
        current = circle.end();
    }
    --current;
  }
}

int main(){
  int all_players, all_marbles;
  long long scores[500] = {0};
  cin >> all_players >> all_marbles;
  circle.push_back(0);
  current = circle.begin();
  for(int i = 1; i <= all_marbles; i++){
    int player = i % all_players;
    if(i % 23 == 0){
      back();
      scores[player] += (i + *current);
      current = circle.erase(current);
      if(current == circle.end()){
        current = circle.begin();
      }
    }else{
      next_iterator();
      ++current;
      circle.insert(current, i);
      --current;
    }
  }

  cout << *max_element(scores, scores + all_players) << endl;
  return 0;
}
