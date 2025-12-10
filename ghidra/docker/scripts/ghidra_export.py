# -*- coding: utf-8 -*-
import sys, os, json
from ghidra.app.decompiler import DecompInterface
from ghidra.util.task import ConsoleTaskMonitor
from ghidra.program.model.pcode import HighFunction
from ghidra.program.model.listing import Function 
from ghidra.program.model.symbol import Reference

# Output directory (passed as CLI arg)
if len(sys.argv) > 1:
    output_dir = sys.argv[1]
else:
    output_dir = "/output"

if not os.path.exists(output_dir):
    os.makedirs(output_dir)


#Initializeing Decompiler and Reference Manager for efficient access
# decomp = DecompInterface()
# decomp.openProgram(currentProgram)
# ref_mgr = currentProgram.getReferenceManager()

funcs = currentProgram.getFunctionManager().getFunctions(True)
# results = []
# monitor = ConsoleTaskMonitor()

# Collect functions
#funcs = currentProgram.getFunctionManager().getFunctions(True)

#Decompiles functions and extracts local vars, callees, and data references
# def decompile_and_extract_details(func, decomp, ref_mgr):
#     #Decompile and run decompilation
#     decomp.toggleCCode(True)
#     decomp.toggleSyntaxTree(True)
#     result = decomp.decompileFunction(func, 30, monitor)
    
#     if result.decompiledFunction is None:
#         return None
    
#     code = result.decompiledFunction.getC()
#     high_func = result.getHighFunction()
    
#     #Extract local variables
#     local_vars = []
#     if high_func:
#         for var in high_func.getLocalSymbolMap().getSymbols():
#             if not var.isParameter():
#                 local_vars.append({
#                     "name": var.getName(),
#                     "data_type": str(var.getDataType()),
#                     "storage": str(var.getVariableStorage())
#                 })
    
#     #Extract callees
#     callees = []
#     for callee in func.getCalledFunctions(monitor):
#         callees.append({
#             "name": callee.getName(),
#             "entry_point": str(callee.getEntryPoint())
#         })
        
#     #Extract data references
#     data_refs = []
#     for ref in ref_mgr.getReferenceIterator(func.getBody()):
#         if ref.getReferenceType().isData():
#             target_addr = ref.getToAddress()
#             symbol = currentProgram.getSymbolTable().getPrimarySymbol(target_addr)
            
#             data_refs.append({
#                 "source_instruction": str(ref.getFromAddress()),
#                 "target_address": str(target_addr),
#                 "target_name": symbol.getName() if symbol else None,
#                 "type": str(ref.getReferenceType())
#             })
            
#     #Compile final dictionary
#     return {
#         "name": func.getName(),
#         "entry_point": str(func.getEntryPoint()),
#         "signature": str(func.getSignature()),
#         "decompiled": code,
#         "local_variables": local_vars,
#         "callees": callees,
#         "data_references": data_refs
#     }

# for f in funcs:
#     try:
#         details = decompile_and_extract_details(f, decomp, ref_mgr)
#         if details:
#             results.append(details)
#     except Exception as e:
#         print("Error processing function", f.getName(), ":", e)


# Decompiles a function and returns the C code
def decompile_function(func):
    decomp = DecompInterface()
    decomp.openProgram(currentProgram)
    decomp.toggleCCode(True)
    decomp.toggleSyntaxTree(True)
    result = decomp.decompileFunction(func, 30, ConsoleTaskMonitor())
    if result.decompiledFunction is None:
        return None
    return result.decompiledFunction.getC()

results = []

#Retrieve key details for each function
for f in funcs:
    try:
        code = decompile_function(f)
        results.append({
            "name": f.getName(),
            "entry_point": str(f.getEntryPoint()),
            "signature": str(f.getSignature()),
            "decompiled": code
        })
    except Exception as e:
        print("Error in", f.getName(), e)

output_file = os.path.join(output_dir, "decompiled.json")

with open(output_file, "w") as f:
    json.dump(results, f, indent=2)

print("Export complete →", output_file)
