from math import mul,sub,add,div,clamp,abs,floor,ceil,ceildiv,trunc,sqrt,rsqrt,exp2,ldexp,exp,frexp,log,log2,copysign,erf,tanh,isclose,all_true,any_true,none_true,reduce_bit_count,iota,is_power_of_2,is_odd,is_even,fma,reciprocal,identity,greater,greater_equal,less,less_equal,equal,not_equal,select,max,min,pow,div_ceil,align_down,align_up,acos,asin,atan,atan2,cos,sin,tan,acosh,asinh,atanh,cosh,sinh,expm1,log10,log1p,logb,cbrt,hypot,erfc,lgamma,tgamma,nearbyint,rint,round,remainder,nextafter,j0,j1,y0,y1,scalb,gcd,lcm,factorial,nan,isnan
from memory.unsafe import DTypePointer
from sys.info import simdwidthof
# from Error import Error
# from simd import SIMD
# from range import range
# from io import print, put_new_line, print_no_newline
from python import Python
from python.object import PythonObject
# from Bool import Bool
from .Array2D import Array

#Main struct of 2D array allows for creation and operations on numerical types
@register_passable("trivial")
struct ndarray[dtype:DType,opt_nelts: Int]:
    var create: Create[dtype,opt_nelts]# = Create[dtype,opt_nelts]
    var math: Math[dtype,opt_nelts]# = Math[dtype,opt_nelts]
    def __init__(self)->ndarray[dtype,opt_nelts]:
        # self.math = Math[dtype,opt_nelts]
        # self.create 
        return self

#Creation methods    
@register_passable("trivial")
struct Create[dtype:DType,opt_nelts: Int]:
        fn arrange(self,start:SIMD[dtype,1],end:SIMD[dtype,1],step:SIMD[dtype,1])raises->Array[dtype,opt_nelts]:

        # if start>=end:
        #     raise Error("End must be greater than start")
            let diff: SIMD[dtype,1] = end-start
            let number_of_steps: SIMD[dtype,1] = diff/step
            let int_number_of_steps: Int = number_of_steps.cast[DType.int32]().to_int() + 1
            let arr: Array[dtype,opt_nelts]=Array[dtype,opt_nelts](int_number_of_steps,1)
        # arr.fill(start)
        
            for i in range(int_number_of_steps):
                arr[i]=start+step*i
            
            return arr
    
    fn eye(self,n:Int)raises->Array[dtype,opt_nelts]:
        let ident: Array[dtype, opt_nelts] = Array[dtype, opt_nelts](n,n)
        for i in range(n):
            ident[i,i] = 1
        return ident
    
    fn zeros(self,rows:Int, cols:Int)raises->Array[dtype,opt_nelts]:
        return Array[dtype,opt_nelts](rows, cols)
    
    fn ones(self,rows:Int, cols:Int)raises->Array[dtype,opt_nelts]:
        var arr: Array[dtype,opt_nelts] = Array[dtype,opt_nelts](rows,cols)
        arr.fill(1)
        return arr

#Mathematics covering trig and other single input ops        
@register_passable("trivial")
struct Math[dtype:DType,opt_nelts:Int]:
    fn abs(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = abs[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = abs[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn floor(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = floor[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = floor[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn ceil(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = ceil[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = ceil[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr


    fn trunc(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = trunc[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = trunc[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn sqrt(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = sqrt[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = sqrt[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr
    fn rsqrt(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = rsqrt[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = rsqrt[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn exp2(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = exp2[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = exp2[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn exp(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = exp[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = exp[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr


    fn log(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = log[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = log[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn log2(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = log2[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = log2[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn erf(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = erf[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = erf[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn tanh(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = tanh[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = tanh[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn reciprocal(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = reciprocal[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = reciprocal[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn acos(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = acos[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = acos[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn asin(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = asin[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = asin[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn atan(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = atan[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = atan[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn cos(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = cos[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = cos[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn sin(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = sin[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = sin[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn tan(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = tan[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = tan[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn acosh(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = acosh[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = acosh[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn asinh(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = asinh[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = asinh[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr
    fn atanh(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = atanh[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = atanh[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn cosh(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = cosh[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = cosh[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn sinh(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = sinh[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = sinh[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn expm1(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = expm1[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = expm1[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr
    fn log10(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = log10[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = log10[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn log1p(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = log1p[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = log1p[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn logb(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = logb[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = logb[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn cbrt(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = cbrt[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = cbrt[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn erfc(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = erfc[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = erfc[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn lgamma(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = lgamma[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = lgamma[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn tgamma(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = tgamma[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = tgamma[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn nearbyint(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = nearbyint[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = nearbyint[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn rint(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = rint[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = rint[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

    fn round(self,arr:Array[dtype,opt_nelts])->Array[dtype,opt_nelts]:
        let res_arr:Array[dtype,opt_nelts]=Array[dtype,opt_nelts](arr.rows,arr.cols)
        for i in range(0, opt_nelts*(arr.size//opt_nelts), opt_nelts):
            let simd_data = round[dtype,opt_nelts](arr.data.simd_load[opt_nelts](i))
            res_arr.data.simd_store[opt_nelts](i,simd_data )

        if arr.size%opt_nelts != 0 :
            for i in range(opt_nelts*(arr.size//opt_nelts), arr.size):
                let simd_data = round[dtype,1]( arr.data.simd_load[1](i))
                res_arr.data.simd_store[1](i, simd_data)
        return res_arr

#TODO implement Logical struct and integrate into NDArray