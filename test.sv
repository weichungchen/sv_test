`ifdef basic_display
class transaction;
    
    bit [7:0]b1;

    //function new(bit [7:0]b1);
    function new(bit [7:0]trans);
        //this.b1=b1;
        b1=trans;
    endfunction

    //function void display();
    virtual function void display();
        //$display("%m %s : Basic transcation, b1 : %0d ", $time, b1);
        $display("%0t: %m: Basic transcation, b1 : %0h ", $time, b1);
    endfunction

endclass

class ext_transaction extends transaction;
    
    bit [7:0]b2;
    
    function new(bit [7:0]b2);
        //this.b2=b2;  // Syntax error: super.new has to be the first statement in new function definition
        super.new(b2);
        this.b2=b2;
    endfunction


    function void display();
        $display("%0t: %m: EXT transcation, b2 : %0h", $time, b2);
    endfunction

    function void display_2();
        $display("%0t: %m: EXT transcation, b2 : %0h", $time, b2);
    endfunction

endclass

class ext_trans extends transaction;
    
    bit [7:0] ext_trans_b2;
    
    function new(bit [7:0]ext_trans_b2);
        super.new(ext_trans_b2);
        this.ext_trans_b2=ext_trans_b2;
    endfunction


    function void ext_trans_b2_display();
        $display("%0t: %m: ext_trans, ext_trans_b2 : %0h", $time, ext_trans_b2);
    endfunction

    function void ext_trans_b2_display_2();
        $display("%0t: %m: ext_trans, ext_trans_b2 : %0h", $time, ext_trans_b2);
    endfunction

endclass

class ext2_transaction extends ext_transaction;
    
    bit [7:0]b3;
    
    function new(bit [7:0]b3);
        super.new(b3);
        this.b3=b3;
    endfunction


    function void ext2_display();
        $display("%0t: %m: EXT2 transcation, b3 : %0h", $time, b3);
    endfunction

    function void ext2_display_2();
        $display("%0t: %m: EXT2 transcation, b3 : %0h", $time, b3);
    endfunction

    function void display();
        $display("%0t: %m: EXT2 transcation, b3 : %0h", $time, b3);
    endfunction

endclass


module tb;
    transaction tr;
    ext_transaction ext_tr1, ext_tr2;
    ext2_transaction ext2_tr;
    ext_trans et;
    logic [7:0] a;
    //$display("%0t: %m: a : %0h", $time, a);

    initial
    begin
        //a=8'h10; // compiler error if assign here, SystemVerilog  keyword 'bit' is not expected to be used in this context.
        bit [7:0] et_trans;
        bit [7:0] trans=8'h68;
        a=8'h10;
        ext_tr1=new(trans);
        #10;
        $display("ext_tr1.display()");
        ext_tr1.display();

        tr=ext_tr1;
        $display("After tr=ext_tr1");
        //ext_tr2=tr;
        #10;
        $display("tr.display()");
        tr.display();
        $display("ext_tr1.display()");
        ext_tr1.display();

        trans=8'h77;
        $display("After trans=77");
        ext_tr1=new(trans);
        #10;
        $display("tr.display()");
        tr.display();
        $display("ext_tr1.display()");
        ext_tr1.display();

        //tr.display_2();  // Could not find member 'display_2' in class 'transaction', at "test.sv", 1
        $cast(ext_tr2, tr); 
        #10;
        $display("tr.display()");
        tr.display();
        //tr.display_2();  // Could not find member 'display_2' in class 'transaction', at "test.sv", 1.
        $display("ext_tr2.display()");
        ext_tr2.display();
        $display("ext_tr2.display_2()");
        ext_tr2.display_2();
        
        trans=8'h99;
        $display("After trans=99");
        ext2_tr=new(trans);
        $display("ext2_tr.display()");
        ext2_tr.display();
        $display("ext2_tr.ext2_display()");
        ext2_tr.ext2_display();
        $display("ext2_tr.ext2_display_2()");
        ext2_tr.ext2_display_2();
        tr=ext2_tr;
        $display("tr=ext2_tr tr.display()");
        tr.display();

        et_trans=8'h11;
        $display("After trans=11");
        et=new(et_trans);
        $display("et.ext_trans_b2_display()");
        et.ext_trans_b2_display();
        $display("et.ext_trans_b2_display_2()");
        et.ext_trans_b2_display_2();
        $display("et.display()");
        et.display();

        //logic [7:0] a;
        //a=0;
        //$display("%0t: %m: a : %0h", $time, a);
    end

endmodule

`elsif static_test
class ErrorH;
  static int count=0, max_count=10;

  static function void print(input string s);
  //function void print(input string s);
    //$error(s);    // should check this function
    $display("*** %s", s);
    if (++count >= max_count) begin
      $display("*** Error max %0d exceeded", max_count);
      $finish(0);
    end
  endfunction

  static function void set_max_count(input int m);
    max_count = m;
  endfunction
endclass

module tb;
    initial begin
      ErrorH::set_max_count(2); // Limit the number of errors
      ErrorH::print("one");
      ErrorH::print("two - should end sim");
      ErrorH::print("three - should not print");
    end
endmodule

/*
// Name Scope
program automatic top;
    //int limit;

    class Foo;
        int limit, array[];
        function void print (input int limit);
            for (int i=0 ; i<limit ; i++)
            begin
                $display("%m: array[%0d]=%0d", i, array[i]);
            end
        endfunction
    endclass

    initial
    begin : test
        int limit = 3;

        Foo bar;

        bar = new();
        bar.array = new[limit];
        bar.print (limit);
    end : test

endprogram
*/
/*
class Foo;
    bit [31:0] limit, array[];

    function new(bit [31:0] limit);
        this.limit=limit;
    endfunction

    function void print ();
        for (int i=0 ; i<limit ; i++)
        begin : test
            $display("%m: i=%0d", i);
            $display("%m: limit=%0d", limit);
            $display("%m: array[%0d]=%0d", i, array[i]);
        end : test
    endfunction

    function void print2();
        $display("%m: limit=%0d", limit);
    endfunction
endclass

module  top;
    Foo bar;
    initial
    begin 
        bit [31:0] limit = 32'h3;

        bar = new(limit);
        bar.array = new[limit];
        bar.print ();
        bar.print2();
    end 

endmodule
*/
`elsif stream

module tb;
    initial
    begin
        bit [15:0] h;
        bit [3:0] b, g[4], j[4] = '{4'b0100, 4'b0011, 4'b0010, 4'b0001}; // 4'h4, 4'h3, 4'h2, 4'h1
        bit [3:0] q, r, s, t;

        h = {>>{j}};
        $display("h={>>{j}}:%0b", h);
        $display("h={>>{j}}:%0h", h);
        h = {<<{j}};
        $display("h={<<{j}}:%0b", h);
        $display("h={<<{j}}:%0h", h);
        {>>{q, r, s, t}} = j;
        $display(">>{q, r, s, t}  q:%0b, r:%0b, s:%0b, t:%0b", q, r, s, t);
        $display(">>{q, r, s, t}  q:%0h, r:%0h, s:%0h, t:%0h", q, r, s, t);
        {<<{q, r, s, t}} = j;
        $display("<<{q, r, s, t}  q:%0b, r:%0b, s:%0b, t:%0b", q, r, s, t);
        $display("<<{q, r, s, t}  q:%0h, r:%0h, s:%0h, t:%0h", q, r, s, t);
        {<<4{q, r, s, t}} = j;
        $display("<<4{q, r, s, t}  q:%0b, r:%0b, s:%0b, t:%0b", q, r, s, t);
        $display("<<4{q, r, s, t}  q:%0h, r:%0h, s:%0h, t:%0h", q, r, s, t);
        h = {<<8{j}};
        $display("h = {<<8{j}}  h:%0b", h);
        $display("h = {<<8{j}}  h:%0h", h);
        {<<{h}} = {<<8{j}};
        $display("{<<{h}} = {<<8{j}}  h:%0b", h);
        $display("{<<{h}} = {<<8{j}}  h:%0h", h);

        /*
        foreach(j[i])
            $display("j[%0d]:%0h", i, j[i]);
        h = {>>{j}};
        $display("h={>>{j}}:%0h", h);
        h = {>>byte{j}};
        $display("h={>>byte{j}}:%0h", h);
        h = {<<{j}};
        $display("h={<<{j}}:%0h", h);
        h = {<<byte{j}};
        $display("h={<<byte{j}}:%0h", h);
        {>>{q, r, s, t}} = j;
        $display(">>{q, r, s, t}  q:%0h, r:%0h, s:%0h, t:%0h", q, r, s, t);
        $display(">>{q, r, s, t}  q:%0b, r:%0b, s:%0b, t:%0b", q, r, s, t);
        {>>byte{q, r, s, t}} = j;
        $display(">>byte{q, r, s, t}  q:%0h, r:%0h, s:%0h, t:%0h", q, r, s, t);
        {<<{q, r, s, t}} = j;
        $display("<<{q, r, s, t}  q:%0h, r:%0h, s:%0h, t:%0h", q, r, s, t);
        $display("j[0]:%0b, j[1]:%0b, j[2]:%0b, j[3]:%0b,", j[0], j[1], j[2], j[3]);
        $display("<<{q, r, s, t}  q:%0b, r:%0b, s:%0b, t:%0b", q, r, s, t);
        {<<byte{q, r, s, t}} = j;
        $display("<<byte{q, r, s, t}  q:%0h, r:%0h, s:%0h, t:%0h", q, r, s, t);
        {>>{g}} = {<<byte{j}};
        foreach(g[i])
            $display("{>>{g}} = {<<byte{%0d}}  g[%0d]:%0h", i, i, g[i]);
        {>>{h}} = {<<byte{j}};
        $display("{>>{h}} = {<<byte{j}}  h:%0h", h);
        {>>{h}} = {<<byte{j}};
        $display("{>>{h}} = {<<byte{j}}  h:%0b", h);
        {<<byte{h}} = {<<byte{j}};
        $display("{<<byte{h}} = {<<byte{j}}  h:%0h", h);
        */
    end
endmodule

/*
class Transaction;
    static bit [31:0] data;
    int id;
endclass
module tb;
    Transaction tr[5];
    Transaction tr2;
    initial
    begin
        foreach (tr[i])
        begin
            tr[i] = new();
            tr[i].data = i+1;
            tr[i].id = i*10;
            $display("%0t: tr[%0d].data:%0d, tr[%0d].id:%0d", $time, i, tr[i].data, i, tr[i].id);
        end

        foreach (tr[i])
            $display("%0t: tr[%0d].data:%0d, tr[%0d].id:%0d", $time, i, tr[i].data, i, tr[i].id);
    end

    initial
    begin
        //tr2 = new();
        repeat (3)
        begin
            tr2 = new();
            tr2.data += 1;
            tr2.id = tr2.data*10;
            $display("%0t: tr2.data:%0d, tr2.id:%0d", $time, tr2.data, tr2.id);
        end

    end

endmodule
*/
`elsif copy_fun
`define SV_RAND_CHECK(r) \
    do \
    begin \
        if(!(r)) \
        begin \
            $display("%s:%0d: Randomization failed \"%s\"", \
                    `__FILE__, `__LINE__, `"r`"); \
        end \
    end \
    while(0)

class Transaction;
    rand bit [31:0] src, dst, data[8];
         bit [31:0] csm;

    virtual function void calc_csm();
        csm = src | dst | data.and;
    endfunction

    virtual function Transaction copy(input Transaction to = null);
    // this.src/dst/data/csm means variable in Transaction scope, not in copy
    // function scope
        if(to == null)
            copy = new();
        else
            copy = to;

        copy.src = this.src;
        copy.dst = this.dst;
        copy.data = this.data;
        copy.csm = this.csm;

        //return copy;
    endfunction

    virtual function void display(input string prefix="");
        $display("%s Tr: src=%h, dst=%h, csm=%h, data=%p",
                 prefix, src, dst, csm, data);
    endfunction
endclass : Transaction

class BadTr extends Transaction;
    rand bit bad_csm;

    virtual function void calc_csm();
        super.calc_csm();
        if(bad_csm)
            csm = ~csm;
    endfunction

    //virtual function Transaction copy(input Transaction to = null);
    virtual function BadTr copy(input BadTr to = null);
        BadTr bad;  
        if(to == null)
            bad = new();
            // copy = new();
        else
            $cast(bad, to);  
            // $cast(copy, to);  
            // copy = to;  // Expression 'to' on rhs is not a class or a compatible class and hence cannot be assigned to a class handle on lhs.

        super.copy(bad);
        //super.copy(copy);
        bad.bad_csm = this.bad_csm;
        // copy.bad_csm = this.bad_csm;
        return bad;
    endfunction

    virtual function void display(input string prefix="");
        $write("%s BadTr: bad_csm=%b, ", prefix, bad_csm);
        super.display();
    endfunction

endclass : BadTr

class Generator;
    Transaction tr;
    mailbox #(Transaction) mbx;
    string prefix="jchen";

    function new(input mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run(input int count);
        repeat(count)
        begin
            tr = new();
            `SV_RAND_CHECK(tr.randomize);
            mbx.put(tr);
            tr.display(prefix);
        end
    endtask

endclass : Generator

class Driver;
    Transaction tr;
    mailbox #(Transaction) mbx;

    function new(input mailbox #(Transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run(input int count);
        repeat(count)
        begin
            mbx.get(tr);
        end
    endtask

endclass : Driver

class Environment;
    Generator gen;
    Driver drv;
    mailbox #(Transaction) mbx;
    int count;

    virtual function void build();
        mbx = new();
        gen = new(mbx);
        drv = new(mbx);
        //mbx = new();  // Null object access
        count = $urandom_range(50);
    endfunction

    virtual task run();
        fork
            gen.run(count);
            //gen.tr.display();
            drv.run(count);
        join
    endtask

    virtual task wrap_up;

    endtask

endclass : Environment

program automatic test;
    Environment env;

    initial
    begin
        env=new();
        env.build();
        env.run();
        env.wrap_up();
    end
endprogram : test

/*
virtual class Base;
    pure virtual function void display();
endclass

class ext_Base extends Base;
    function void display();
        $display("test pure virtual function");
    endfunction
endclass

module tb;
    Base b;
    ext_Base eb;
    int a[];
    int a_a[string];

    initial
    begin
        //b = new();
        //b.display();
        a = new[5];
        a = '{5{9}};

        a_a = '{ "RED":20,
                 "GREEM" : 25,
                 "YELLOW" :30 };

        eb = new();
        eb.display();
        
        b=eb;
        b.display();
    
        foreach(a[i])
            $display("a[%0d]:%0d", i, a[i]);

        a.delete;
        
        foreach(a[i])
            $display("a[%0d]:%0d", i, a[i]);

        foreach(a_a[s])
            $display("a[%s]:%0d", s, a_a[s]);

    end
endmodule
*/
/*
typedef enum {OKAY, EXOKAY, SLVERR, DECERR} resp_type;

class slaver_driver;
    resp_type resp;

    virtual task update_resp;
    endtask

    task send_resp;
        std::randomize(resp) with {resp == OKAY;};
        update_resp;
    endtask
endclass

class err_inject extends slaver_driver;
    virtual task update_resp;
        $display("Inject SLVERR");
        resp = SLVERR;
    endtask
endclass
*/
`elsif callback
typedef enum {GOOD, BAD_ERR1, BAD_ERR2} pkt_type;

class Driver;

    pkt_type pkt;

    task pkt_sender;
        std::randomize(pkt) with {pkt == GOOD;};
        modify_pkt;
    endtask

    virtual task modify_pkt;
    endtask

endclass

class Err_driver extends Driver;

    task modify_pkt;
        $display("Injecting error pkt");
        std::randomize(pkt) with {pkt inside {BAD_ERR1, BAD_ERR2};};
    endtask

endclass

class Environment;

    bit inject_err;
    Driver drv;
    Err_driver drv_err;

    function new();
        drv = new();
        drv_err = new();
    endfunction

    task run();
        std::randomize(inject_err) with {inject_err inside {0, 1};};
        $display("inject_err : %0d", inject_err);
        if(inject_err) drv = drv_err;
        drv.pkt_sender();
        $display("Sending pkt = %s", drv.pkt.name());
    endtask

endclass
module tb;

    Environment env;

    initial
    begin
        repeat (20)
        begin
            env = new();  // new env 20 times??? want to new item 20 times
            env.run();
        end
    end
    
endmodule

`elsif var_type
program test;
    class A;
      integer data;
      local   integer addr;
      protected integer cmd;
      static integer credits;
      function new();
        begin
          data = 100;
          addr = 200;
          cmd  = 1;
          credits = 10;
        end
      endfunction
      task printA();
        begin
          $write ("value of data %0d in A\n", data);
          $write ("value of addr %0d in A\n", addr);
          $write ("value of cmd  %0d in A\n", cmd);
        end
      endtask
    endclass
    
    class B extends A;
        /*
        integer data;
        integer addr;
        integer cmd;

        function new();
            super.new();
            data = 6;
            addr = 7;
            cmd = 8;
        endfunction
        */
      task printB();
        begin
          $write ("value of data %0d in B\n", data);
          // Below line will give compile error
          //$write ("value of addr %0d in B\n", addr);  // Local member 'addr' of class 'A' is not visible to scope 'B'.
          $write ("value of cmd  %0d in B\n", cmd);
        end
      endtask
    endclass
    
    class C;
      A a;
      B b;
      function new();
        begin
          a = new();
          b = new();
          b.data = 2;
        end
      endfunction
      task printC();
        begin
          $write ("value of data %0d in C\n", a.data);
          $write ("value of data %0d in C\n", b.data);
          // Below line will give compile error
          //$write ("value of addr %0d in C\n", a.addr);  // Local member 'addr' of class 'A' is not visible to scope 'C'.
          //$write ("value of cmd  %0d in C\n", a.cmd);  // Protected member 'cmd' of class 'A' is not visible to scope 'C'.
          //$write ("value of addr %0d in C\n", b.addr);
          //$write ("value of cmd  %0d in C\n", b.cmd);
        end
      endtask
    endclass
    
    initial begin
      C c = new();
      c.a.printA();
      c.b.printB();
      c.printC();
      $write("value of credits is %0d\n",c.a.credits); 
      $write("value of credits is %0d\n",c.b.credits); 
      c.a.credits ++;
      $write("value of credits is %0d\n",c.a.credits); 
      $write("value of credits is %0d\n",c.b.credits); 
      c.b.credits ++;
      $write("value of credits is %0d\n",c.a.credits); 
      $write("value of credits is %0d\n",c.b.credits); 
      //c.b.cmd ++;
      //$write("value of credits is %0d\n",c.a.credits); 
      //$write("value of credits is %0d\n",c.b.credits);
      //c.b.addr ++;
      //$write("value of credits is %0d\n",c.a.credits); 
      //$write("value of credits is %0d\n",c.b.credits);
    end
endprogram

`elsif para_fun
parameter int SIZE = 10;
class stack #(type T=int);
    local T stack_s[SIZE];
    local int top;

    function void push(input T i);
        stack_s[top++] = i;
    endfunction

    function T pop(output T o);
        // return stack_s[--top];
        o = stack_s[--top];
    endfunction
endclass : stack

module tb;
    //stack  #(real) s;
    stack  #(logic [31:0]) s2;
    logic [31:0]tb_arg;

    initial
    begin
        //s = new();
        s2 = new();
        
        for(int i = 0 ; i<SIZE ; i++)
        begin
            //s.push(i*5.0);
            s2.push(i+5);
        end

        for(int i = 0 ; i<SIZE ; i++)
        begin : test
            s2.pop(tb_arg);
            //$display("%f", s.pop());
            $display("%m %0t : %0h", $time, tb_arg);
        end : test

    end
endmodule

`elsif conf_database
class config_db # (type T=int);
    
    static T db[string];
    static function void set(input string name, input T value);
        db[name] = value;
    endfunction

    static function void get(input string name, ref T value);
        value = db[name];
    endfunction

    static function void print();
        $display("\nConfiguration database %s", $typename(T));
        foreach(db[i])
            $display("%0t : db[%s] = %0p", $time, i, db[i]);
    endfunction
endclass

class Tiny;
    int i;
endclass

module tb;
    //int i = 42;
    //int j = 43;
    int a;
    int i;
    int j;
    int k;
    //real pi = 22.0/7.0;
    real pi;
    real r;
    Tiny t;

    logic [31:0] g;
    //i = 42;
    //j = 43;
    //pi = 22.0/7.0;
    initial
    begin
        i = 42;
        j = 43;
        pi = 22.0/7.0;

        config_db#(int)::set("a", a);   
        config_db#(int)::set("i", i);   
        config_db#(int)::set("j", j);   
        config_db#(int)::set("k", k);   
        config_db#(real)::set("pi", pi);
        config_db#(logic)::set("g", g);

        t = new();
        t.i = 8;
        config_db#(Tiny)::set("t", t);
        config_db#(Tiny)::set("null", null);

        config_db#(int)::get("i", k);
        $display("Fetched value (%0d) of i (%0d)",i , k);

        config_db#(int)::print();   
        config_db#(real)::print();   
        config_db#(Tiny)::print();   
        config_db#(logic)::print();   
    end

    initial
    begin
        i = 11;
        j = 22;
        config_db#(int)::set("i", i);   
        config_db#(int)::set("j", j);
        config_db#(int)::set("k", k);   

        config_db#(int)::print();
    end

endmodule

`elsif svm_object

virtual class svm_object;

endclass

virtual class svm_component extends svm_object;
    
    protected svm_component m_child[string];
    string name;

    function new(string name);
            this.name = name;
            $display("%m name = %s", name);
    endfunction

    pure virtual task run_test();

endclass : svm_component

virtual class svm_object_wrapper;
    pure virtual function string get_type_name();
    pure virtual function svm_object create_object(string name);
endclass

class svm_component_registry
#(
    type T = svm_component, 
    string Tname = "<unknown>"
)
extends svm_object_wrapper;

    virtual function string get_type_name();
        return Tname;
    endfunction

    local static this_type me = get();  // me is a handle, handle to singleton, variable type is not user defined type

    static function this_type get();

        if(me == null)
        begin
            svm_factory f = svm_factory::get();
            me = new();
            f.register(me);
        end

        return me;

    endfunction

    virtual function svm_object create_object(string name="");
        
        T obj;
        obj = new(name);
        return obj;

    endfunction

    static function T create(string name);
        create = new(name);
    endfunction

endclass : svm_component_registry

class svm_factory;
    
    static svm_object_wrapper m_type_names[string];

    static svm_factory m_inst;  // handle to this singleton

    static function svm_factory get();
    
        if (m_inst == null)
            m_inst = new();

        return m_inst;

    endfunction

    static function void register(svm_object_wrapper c);
        m_type_names[c.get_type_name()] = c;
    endfunction

    static function svm_component get_test();
    
        string name;
        svm_object_wrapper test_wrapper;
        svm_component test_comp;

        if (!$value$plusargs("SVM_TESTNAME=%s", name))
        begin
            $display("FATAL +SVM_TESTNAME no found");
            $finish;
        end

        $display("%m found +SVM_TESTNAME=%s", name);
        test_wrapper = svm_factory::m_type_names[name];

        $cast(test_comp, test_wrapper.create_object(name));  // type : class svm_object_wrapper convert to class svm_component 
        return test_comp;

    endfunction

endclass : svm_factory

`define svm_component_utils(T) \
    typedef svm_component_registry #(T, `"T`") type_id; \
    virtual function string get_type_name (); \
    return `"T`"; \
    endfunction

class TestBase extends svm_component;

    //Environment env;
    `svm_component_utils(TestBase)

    function new(string name);
        super.new(name);
        $display("%m");
        //env = new();
    endfunction

    virtual task run_test();
    endtask

endclass

program automatic test;
    initial
    begin
        svm_component test_obj;
        test_obj = svm_factory::get_test();
        test_obj.run_test();
    end
endprogram

`elsif rand_test

class rand_operation;

    rand bit [7:0] lo, med, hi;
    rand bit [31:0] addr;

    constraint t
    {
        lo < med;
        med < hi;
    }
    
    constraint t2
    {
        lo > 5;
        med < 200;
    }

    //constraint v
    //{
    //    lo > 5;
    //}

    constraint t3
    {
        //addr [11:0] inside {[10:12], [14:16]};
        addr  inside {[10:12], [14:16]};
    }

    constraint ext_t;  // external constraint

    function void display;
        $display("show random lo : %5d, med : %5d, hi : %5d, addr : %5d", lo, med, hi, addr);
    endfunction
    //$display("show random lo : %0d, med : %0d, hi : %0d", lo, med, hi);  // $display can't show in class
endclass

constraint rand_operation::ext_t {med < 100;}

module tb;
/*
    class rand_operation;
    
        rand bit [7:0] lo, med, hi;
    
        constraint t
        {
            lo < med;
            med < hi;
        }
        
        constraint t2
        {
            lo > 5;
            med < 200;
        }
    
        constraint ext_t;  // external constraint
    
        function void display;
            $display("show random lo : %5d, med : %5d, hi : %5d", lo, med, hi);
        endfunction
    endclass
*/

    rand_operation ro;

    //constraint rand_operation::ext_t {med < 100;}  // $unit, "constraint ext_t;"
                                                   // The constraint ext_t declared in the class rand_operation is not defined.
                                                   // Provide a definition of the constraint body ext_t or remove the constraint 
                                                   // declaration ext_t from the class declaration rand_operation.

    initial
    begin
        ro = new();
        repeat (10)
        begin
            ro.randomize;
            ro.display;
        end
        $display("ro.lo : %0d, ro.med : %0d, ro.hi : %0d", ro.lo, ro.med, ro.hi);
    end

endmodule

`elsif rand_test2

class rand_fib;
    rand bit [7:0] f;
    bit [7:0] vals[] = '{1, 2, 3, 5, 8};
    constraint c_fib
    {
        f inside vals;
    }
endclass

module tb;

    rand_fib rf;
    int count[9], maxx[$];
    //int maxx;  // if maxx isn't array or queue, it will compile error
                 // Mismatching types cannot be used in assignments, initializations and 
                 // instantiations. The type of the target is 'int', while the type of the 
                 // source is 'int$[$]'.
                

    initial
    begin
        rf =new();

        repeat (20)
        begin
            rf.randomize;
            $display("rf.f=%5d", rf.f);
            count[rf.f]++;
        end

        maxx = count.max();
        $display("maxx[0]=%5d", maxx[0]);

        foreach(count[i])
        begin
            //$display("count[%0d]=%5d", i, count[i]);
            if(count[i])  // element in count[i] isn't empty
            begin
                $write("count[%0d]=%5d", i, count[i]);
                $display;  // this like print "\n"
                //$write("maxx[%0d]=%5d", i, maxx[i]);
                //$display;  // this like print "\n"
            end
        end
    end
endmodule
    
`elsif rand_test3

class Days;
    typedef enum {SUN, MON, TUE, WED, THU, FRI, SAT} days_e;

    days_e choices[$];
    rand days_e choice;

    constraint cd {choice inside choices;}

endclass

module tb;
    
    Days days;

    initial
    begin
        days = new();
        days.choices = {Days::SUN, Days::SAT};

        days.randomize;
        $display("random weekend day %s", days.choice.name());

        days.choices = {Days::MON, Days::TUE, Days::WED, Days::THU, Days::FRI};
        days.randomize;
        $display("random week day %s", days.choice.name());

    end
endmodule

`elsif rand_test4

class RandcInside;

    int array[];
    randc bit [15:0] index;

    constraint c_size {index < array.size();}

    function new(input int a[]);
        array = a;
    endfunction

    function int pick();
        return array[index];
    endfunction

endclass

module tb;

    RandcInside ri;
    initial
    begin
        ri = new('{1, 3, 5, 7, 9, 11});

        $display("ri.array.size() : %0d", ri.array.size());
        repeat (ri.array.size())
        begin
            ri.randomize;
            $display("picked %2d [%0d]", ri.pick(), ri.index);
        end
    end
endmodule

`elsif rand_test5

class Bathtub;
    bit [31:0] val;
    bit [31:0] WIDTH = 50, DEPTH = 6, seed = 1;

    function void pre_rand();
        val = $dist_exponential(seed, DEPTH);
        if(val > WIDTH) val  = WIDTH;

        if($urandom_range(1)) val = WIDTH - val;
    endfunction

    function void display;
        $display("val: %5d, WIDTH: %5d, DEPTH: %5d, seed: %5d", val, WIDTH, DEPTH, seed);
    endfunction
endclass

module tb;

    Bathtub b;

    initial
    begin
        b = new();

        repeat (5)
        begin
            b.pre_rand;
            b.display;
        end
    end
    
endmodule

`elsif rand_test6

class sum_test;

    randc bit [9:0] len [];

    constraint c_len
    {
        foreach (len[i])
            len[i] inside {[1:255]};

        len.sum() < 1024;
        len.size() inside {[1:8]};
    }

    function void pre_randomize();
        $display("len.size = %4d", len.size());

        foreach (len[i])
        begin
            if (len[i] < 20)
                len[i] = 20;
            else if (len[i] > 200)
                len[i] = 200;
            $display("len[%0d] = %4d", i, len[i]);
        end
        $display("len.size = %4d", len.size());
        $display("pre randomize");
    endfunction

    function void display;
        $write("sum = %4d, val = ", len.sum());
        foreach (len[i])
        begin
            $write("%4d ", len[i]);
        end
        $display;
    endfunction
endclass

module tb;

    sum_test st;

    initial
    begin
        st =new();

        repeat (5)
        begin
            st.randomize();
            st.display;
        end
    end
endmodule

`elsif rand_local

class item;
    rand bit [7:0] id;

    constraint item_id { id < 25; }

endclass

module tb;



    initial
    begin : tb_initial
        item i;
        bit [7:0] id;
        
        i = new();

        id = 10;
        i.randomize() with { id == local::id; };

        $display("%m: %l: item id = %0d", id, id);
        $display("%m: %l: item id = %0d", i.id, i.id);
    end
endmodule

`elsif rand_case

module tb;

    initial
    begin
        for(int i = 0 ; i<10 ; i++)
            randcase
                0 : $display ("Wt 0");
                5 : $display ("Wt 5");
                3 : $display ("Wt 3");
                default : $display ("Wt other");
            endcase
    end
endmodule
`elsif thread_fork

class randc_item;
    
    randc bit [31:0]item;

    constraint i
    {
        item inside {[1:100]};
    }

endclass


class Gen_drive;
    
    task run(input int n);
        randc_item ri;

        fork
            repeat (n)
            begin : test1
                ri = new();
                ri.randomize();
                #10 $display("%0t: ri = %5d", $time, ri.item);
            end
            /*
            begin : test2
                #10 $display("%0t: show 2_1 in fork none", $time);
                #10 $display("%0t: show 2_2 in fork none", $time);
            end

            begin : test3
                #10 $display("%0t: show 3_1 in fork none", $time);
                #10 $display("%0t: show 3_2 in fork none", $time);
            end
            */
        join_none
        $display("%0t: after join_none", $time);
    endtask

endclass

module tb;

    Gen_drive gd;

    initial
    begin
        gd = new();
        repeat (3)
        begin
            gd.run(10);
            $display("%0t: In tb initial", $time);
        end
    end

endmodule

`elsif thread_fork2

module tb;

    initial
    begin
        for (int i= 0 ; i <3 ; i++)
        begin
            automatic int j = i;
            //int j = i;
            fork
                #10 $display("%t: i_0 = %0d", $time, i);
                    $display("%t: i_1 = %0d", $time, i);
                #10 $display("%t: j_0 = %0d", $time, j);
                    $display("%t: j_1 = %0d", $time, j);
            //join
            join_none
            //join_any
        end
        //#0 $display("%0t: test", $time);
        //$display("%0t: test", $time);
    end

endmodule

`elsif var_shre

module tb;

    int i;

    initial
    begin
        for(int i=0 ; i < 10 ; i++)
        begin
            #10 $display("%2t: i_0=%0d", $time, i);
        end
    end

    initial
    begin
        for(int i=0 ; i < 10 ; i++)
        begin
            #10 $display("%2t: i_1=%0d", $time, i);
        end
/*
        for(i=0 ; i < 10 ; i++)
        begin
            #10 $display("%2t: i_2=%0d", $time, i);
        end
*/
    end

endmodule

`elsif pass_event

class Generator;

    event done;
    function new (input event done);
        this.done = done;
    endfunction

    task run();
        fork
            $display("Thread 1 in fork_join");
            $display("Thread 2 in fork_join");
            -> done;
        join
    endtask
endclass

module tb;

    event gen_done;
    Generator gen;

    initial
    begin
        gen = new(gen_done);
        gen.run();
        wait(gen_done.triggered);
        $display("Pass event finish");
    end
endmodule

`elsif initial_para

module tb;

    int array_int[];

    initial
    begin
        array_int = new[10];
        foreach(array_int[i])
            $display("%0t: array_int[%0d] = %0d", $time, i, array_int[i]);
    end

    initial
    begin
        array_int = new[5];
        foreach(array_int[i])
            $display("%0t: array_int[%0d] = %0d", $time, i, array_int[i]);
    end


endmodule

`elsif disable_fork

module tb;

    initial 
    begin
        fork:f1
            #10 $display("%0t: Thread 1", $time);
            #20 $display("%0t: Thread 2", $time);
            begin
                #5 $display("%0t: Thread 3", $time);
                $display("%0t: Thread 4", $time);
            end

            fork:f2
                $display("%0t: Thread 5", $time);
                #30 $display("%0t: Thread 6", $time);
            join
            //join_none
            //disable fork;  // nothing special happened
            //#2 disable fork;  // nothing special happened unless a delay is added
            //#2 disable f1;  // nothing special happened unless a delay is added
            #2 disable f2;  // nothing special happened unless a delay is added
        join_any
        //join

        //disable fork;
        //disable f2;  // Undefined disable target 'f2', please make sure the target exists.
    end
endmodule

`elsif semaphore_test

class write;
    
    semaphore sem_w;

    function new(input semaphore sem);
        sem_w = sem;
    endfunction

    task write_mem();
        #2 sem_w.get(1);
        $display("%0t: Before write memory", $time);
        #5;
        $display("%0t: Write memory completed", $time);
        sem_w.put(1);
    endtask
endclass

class read;

    semaphore sem_r;

    function new(input semaphore sem);
        sem_r = sem;
    endfunction

    task read_mem();
        sem_r.get(2);
        $display("%0t: Before read memory", $time);
        #4;
        $display("%0t: read memory completed", $time);
        sem_r.put(1);  // if don't put back enough key, it will block next thread which uses semaphore

    endtask
endclass

module tb;

    semaphore sem;
    write w;
    read r;
    
    initial
    begin
        sem = new(2);
        w = new(sem);
        r = new(sem);

        fork
            w.write_mem();
            r.read_mem();
        join
    end
endmodule

`elsif fork_join

module tb;
    
    initial
    begin
        fork
            #10 $display("Thread 1");
            #5  $display("Thread 2");
            #20 $display("Thread 3");
            #50 $display("Thread 4");
        join_any
            $display("out of fork join_any");
        wait fork;
            $display("fork join_any done");
    end

endmodule

`elsif fork_for

module tb;

    initial
    begin
        for(int i=0 ; i < 5 ; i++)
        begin
            fork
                #5 $display("%0t: i = %0d", $time, i);
            join
        end
    end

/*
    initial
    begin
        fork
            for(int i=0 ; i < 5 ; i++)
                #5 $display("%0t: i = %0d", $time, i);
        join_none
    end
*/
endmodule

`elsif array_method

module tb;

    int array_int[3];
    initial
    begin
        array_int = '{0, 1, 2};
        $display("array : %p", array_int);
        array_int.reverse();
        $display("array : %p", array_int);
    end
endmodule

`elsif out_of_queue

module tb;

    int queue[$];

    initial
    begin
        queue = {0, 1, 2};
        $display("queue = %p", queue);
        queue.push_back(3);
        $display("queue = %p", queue);
        queue.push_front(-1);
        $display("queue = %p", queue);
        queue.insert(9, 9);  // Error-[DT-MCWII] Method called with invalid index
        $display("queue = %p", queue);
    end
endmodule

`elsif wait_event

module tb;

    event a, b, c;

    initial
    begin
        #10 ->c;
        #10 ->a;
        #10 ->b;
        #10 ->c;
        #10 ->b;
    end

    initial
    begin
        wait_order(a, b, c)
            $display("%0t: correspond order", $time);
        //else  // if the fail sttement is not specified, a failure generates
                //a run-time error
            //$display("%0t: out of order", $time);
    end
endmodule

`elsif assign_event

module tb;

    event event_a, event_b;

    initial
    begin
        fork
            begin
                wait(event_a.triggered);
                //if(event_a.triggered)
                $display("%0t: event a happened.", $time);
            end

            begin
                wait(event_b.triggered);
                //if(event_b.triggered)
                $display("%0t: event b happened.", $time);
            end
            
            #20 ->event_a;

            //#30 ->event_b;

            //->event_a;
            //->event_b;
            //event_a = event_b;
            //#1 ->event_b;
            begin
                #10 event_b = event_a;
            end
            //#40 event_b = event_a;
        join
        $display("%0t: fork join end.", $time);
    end

endmodule

`elsif assign_event2

module tb;

    event a, b;

    initial 
    begin
        a = b;
        #1 -> a;
        //#1 -> b;
        if (a.triggered) $display("%0t: a triggered", $time);
        if (b.triggered) $display("%0t: b triggered", $time);
    end

endmodule

`elsif copy_fun2

module tb;

    class base;

        int var_a;

        virtual function base copy(input base dst=null);
            //copy = new();
            if (dst == null)
                copy = new();
            else
                copy = dst;

            copy.var_a=this.var_a;

            return copy;

        endfunction

    endclass : base

    class ext extends base;
        
        int var_b;
        
        virtual function base copy(input base dst=null);
            ext ext_tmp_hdl;
            if (dst == null)
                ext_tmp_hdl = new();
            else
                $cast(ext_tmp_hdl, dst);

            super.copy(ext_tmp_hdl);
            ext_tmp_hdl.var_b=this.var_b;

            return ext_tmp_hdl;

        endfunction

    endclass : ext

    base b_hdl_1, b_hdl_2;
    ext  e_hdl_1, e_hdl_2;

    initial
    begin
        b_hdl_1        = new();
        b_hdl_2        = new();
        b_hdl_1.var_a  = 3;
        //b_hdl_2        = b_hdl_1.copy(b_hdl_1);
        b_hdl_2        = b_hdl_1.copy();
        b_hdl_2.var_a  = 4;
/*        
        b_hdl_1        = e_hdl_1;
        //$cast(e_hdl_2, b_hdl_1);
        e_hdl_1 = b_hdl_1.copy(b_hdl_1); 
*/

        e_hdl_1        = new();
        //e_hdl_2        = new();
        e_hdl_1.var_a  = 5;
        e_hdl_1.var_b  = 6;

        $cast(e_hdl_2, e_hdl_1.copy());
        //e_hdl_2        = e_hdl_1.copy();
        //e_hdl_2.copy(e_hdl_1);  // appear 0 ???
        e_hdl_2.var_a  = 7;
        e_hdl_2.var_b  = 8;

        $display("b_hdl_1.var_a : %0d", b_hdl_1.var_a);
        $display("b_hdl_2.var_a : %0d", b_hdl_2.var_a);
        $display("e_hdl_1.var_a : %0d", e_hdl_1.var_a);
        $display("e_hdl_1.var_b : %0d", e_hdl_1.var_b);
        $display("e_hdl_2.var_a : %0d", e_hdl_2.var_a);
        $display("e_hdl_2.var_b : %0d", e_hdl_2.var_b);
    end

endmodule

`elsif assign_value

module tb;

    class a_d;
        int a;
        function display();
            $display("a: %0d", a);
        endfunction
    endclass


    a_d ad;

    initial
    begin
        ad = new();
        ad.a = 10;
        ad.display();
    end

endmodule

`elsif ext_ext_virtual

class base;
    virtual function void display(input int a);
        $display("%m, a: %0d", a);
    endfunction
endclass

class ext extends base;
    function void display(input int a);
        $display("%m, b: %0d", a);
    endfunction
endclass

class ext_ext extends ext;
    virtual function void display(input int a);
        $display("%m, c: %0d", a);
    endfunction
endclass

module tb;
    base b;
    ext  e;
    ext_ext ee;

    initial
    begin
        e = new();
        b = e;
        b.display(3);
        //e = ee;
        e.display(4);
        //ee.display(5);
    end

endmodule

`elsif ppt_ex

module tb;

    class base;
        int a;

        function new(input init_a);
            a = init_a;
        endfunction

        virtual function void copy(ref base hdl_dst, ref base hdl_src);
            if(hdl_dst == null)
                hdl_dst = new(8);
            
            hdl_dst.a = hdl_src.a;

        endfunction

    endclass

    class extn extends base;
        int b;

        virtual function void copy(ref base hdl_dst, ref base hdl_src);
            if(hdl_dst == null)
                hdl_dst = new(0);

            super.copy(hdl_dst, hdl_src);
            hdl_dst.b = hdl_src.b;

        endfunction

    endclass

    
/*
    initial
    begin
        src = new();
        dst = new();
        src.a = 2; 
        $display("show src.a = %0d, dst.a = %0d", src.a, dst.a);
        dst.a = src.a;
        $display("show src.a = %0d, dst.a = %0d", src.a, dst.a);
    end
*/
endmodule

`elsif ppt_ex2

module tb;

    class base;
        int a;

        function new(int init_a);
            a = init_a;
        endfunction

        virtual function base copy();
            copy = new(6);
            copy.a = this.a;  // equal copy.a = a;
            return copy;
        endfunction

    endclass

    base src, dst;

    initial 
    begin
        src = new(5);
        dst = new(8);
        $display("src.a = %0d, dst.a = %0d", src.a, dst.a);
        dst = src.copy();
        $display("src.a = %0d, dst.a = %0d", src.a, dst.a);
    end

endmodule

`elsif ppt_ex3

module tb;

    class base;
        int a;

        virtual function base copy(input base dst);
            if(dst==null)
                dst=new();

            dst.a = this.a;

            return dst;
        endfunction

    endclass


    class ext extends base;
        int b;

        virtual function base copy(input base dst);
            ext ext_hdl;
            if(dst==null)
                ext_hdl=new();
            else
                $cast(ext_hdl, dst);

            super.copy(ext_hdl);
            ext_hdl.b = this.b;
            
            return ext_hdl;
        endfunction

    endclass

endmodule

`elsif cover_PbR

module tb;

    bit [2:0] dst_a, dst_b;

    covergroup Cov(ref bit [2:0] dst, input int mid);
    {
        bins lo = {0:mid-1};
        bins hi = {mid:$};
    }

endmodule
`endif


