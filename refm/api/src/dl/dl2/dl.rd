
=== �Ȥ���

�̾�� dl/import �饤�֥��� require ���� [[c:DL::Importer]] �⥸�塼�����Ѥ��ޤ���
[[c:DL]] �⥸�塼�뼫�Τϥץ�ߥƥ��֤ʵ�ǽ�����󶡤��Ƥ��ޤ���
[[c:DL::Importer]] �⥸�塼��ϰʲ��Τ褦�˥桼������������⥸�塼����ĥ������ǻȤ��ޤ���

  require "dl/import"
  module M
    extend DL::Importer
  end

�ʸ塢���Υ⥸�塼��� dlload �� extern �ʤɤΥ᥽�åɤ����ѤǤ���褦�ˤʤ�ޤ���
�ʲ��Τ褦�� dlload ��Ȥäƥ饤�֥�������ɤ���
���Ѥ������饤�֥��ؿ����Ф��� extern �᥽�åɤ�Ƥ��
��åѡ��᥽�åɤ�������ޤ���

  require "dl/import"
  module M
    extend DL::Importer
    dlload "libc.so.6","libm.so.6"
    extern "int strlen(char*)"
  end
  # Note that we should not include the module M from some reason.
  
  p M.strlen('abc') #=> 3

M.strlen ����Ѥ��뤳�Ȥǡ��饤�֥��ؿ� strlen() ����ѤǤ��ޤ���
Ϳ����줿�ؿ�̾�κǽ��ʸ������ʸ���ʤ顢
��������᥽�å�̾�κǽ��ʸ���Ͼ�ʸ���ˤʤ�ޤ���

==== ��¤�Τ򰷤�

��¤�Τⰷ�����Ȥ��Ǥ��ޤ������Ȥ��� [[man:gettimeofday(2)]]
��ȤäƸ��߻�������������ϰʲ��ΤȤ���Ǥ���

 require 'dl/import'
 module M
   extend DL::Importer
   dlload "libc.so.6"
   extern('int gettimeofday(void *, void *)')
   Timeval = struct( ["long tv_sec",
                      "long tv_usec"])
 end
 
 timeval = M::Timeval.malloc
 e = M.gettimeofday(timeval, nil)

 if e == 0
  p timeval.tv_sec #=> 1173519547
 end

�����ǡ�����γ�����Ƥ� M::Timeval.new �ǤϤʤ�
M::Timeval.malloc ����Ѥ��Ƥ��뤳�Ȥ����դ��Ƥ���������

==== ������Хå�

�ʲ��Τ褦�˥⥸�塼��ؿ� bind ����Ѥ���������Хå�������Ǥ��ޤ���

  require 'dl/import'
  module M 
    extend DL::Importer
    dlload "libc.so.6"
    QsortCallbackWithoutBlock = bind("void *qsort_callback(void*, void*)", :temp)
    QsortCallback             = bind("void *qsort_callback2(void*,void*)"){|ptr1,ptr2| ptr1[0] <=> ptr2[0]}
    extern 'void qsort(void *, int, int, void *)'
  end

  buff = "3465721"
  M.qsort(buff, buff.size, 1, M::QsortCallback)
  p buff #=>   "1234567"

  M.qsort(buff, buff.size, 1, M::QsortCallbackWithoutBlock){|ptr1,ptr2| ptr2[0] <=> ptr1[0]}
  p buff #=>   "7654321"

������ M::QsortCallback �ϥ֥��å���Ƥ� [[c:DL::Function]] ���֥������ȤǤ���


==== �ݥ��󥿤򰷤�

�����Ȥ��ƥݥ��󥿤�������ؿ����Ф��Ƥϡ��ݥ��󥿤��Ѥ���
ʸ������Ϥ��ޤ���ʸ����ϥݥ��󥿤��ؤ������ΰ�Ȥ��ư����ޤ���

 require 'dl/import' 
 
 module M
   extend DL::Importer
   dlload 'libc.so.6'
   extern 'void * memmove(void *, void *, unsigned long)'
 end
 
 s = 'xxxyyyzzz'
 M.memmove(s, 'abc', 3)
 p s                    #=> "abcyyyzzz"

char * �ʳ��η��Υݥ��󥿤�������ؿ����Ф��Ƥ�ʸ������Ϥ��ޤ���

 module M
   extend DL::Importer
   dlload 'libm.so.6'
   extern 'double modf(double, double *)'
 end 
 
 s = ' ' * 8
 p M2.modf(1.25, s)  #=> 0.25
 p s.unpack('d')[0]  #=> 1.0