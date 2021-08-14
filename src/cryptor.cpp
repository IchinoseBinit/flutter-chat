#include<iostream>

using namespace std;

extern "C" std::string crypt(std::string str,bool bencrypt){
    std::string res = "";
    int shift = 3;
    if(bencrypt==true) shift = -3;
    int len = str.length();
    int index = 0;
    while(index<len){
        int ch_ascii = int(str[index]);
        res += (char) (ch_ascii+shift);
        index++;
    }
    return res;
}

extern "C" std::string encrypt(std::string str){
    return crypt(str,false);
}

extern "C" std::string decrypt(std::string str){
    return crypt(str,true);
}

extern "C" int main(){
    std::string input;
    cin>>input;
    std::string res = encrypt(input);
    cout<<res<<endl;
    cout<<decrypt(res)<<endl;
    return 0;
}