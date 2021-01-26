FLAGS=--std=93c --ieee=synopsys
GHDL_DIR=../../ghdl
GHDL=LD_LIBRARY_PATH=$(GHDL_DIR)/lib:$$LD_LIBRARY_PATH $(GHDL_DIR)/bin/ghdl
VCD=$(GHDL_DIR)/bin/vcd-ubuntu-latest

all: logic_gates_ex half_adder_ex full_adder_ex ripple_carry_adder_ex

logic_gates_ex:
	$(eval PRJ_DIR := logic_gates)
	$(eval WORK_DIR := $(PRJ_DIR)/work)
	$(eval FLAGS := $(FLAGS) --workdir=$(WORK_DIR))
	mkdir -p $(WORK_DIR)
	$(GHDL) -a $(FLAGS) $(PRJ_DIR)/logic_gates.vhdl
	$(GHDL) -a $(FLAGS) $(PRJ_DIR)/logic_gates_tb.vhdl
	$(GHDL) -e $(FLAGS) logic_gates_tb
	$(GHDL) -r $(FLAGS) logic_gates_tb --vcd=$(PRJ_DIR)/trace.vcd
	$(VCD) $(PRJ_DIR)/trace.vcd -s=logic_gates_tb

half_adder_ex:
	$(eval PRJ_DIR := half_adder)
	$(eval WORK_DIR := $(PRJ_DIR)/work)
	$(eval FLAGS := $(FLAGS) --workdir=$(WORK_DIR))
	mkdir -p $(WORK_DIR)
	$(GHDL) -a $(FLAGS) $(PRJ_DIR)/half_adder.vhdl
	$(GHDL) -a $(FLAGS) $(PRJ_DIR)/half_adder_tb.vhdl
	$(GHDL) -e $(FLAGS) half_adder_tb
	$(GHDL) -r $(FLAGS) half_adder_tb --vcd=$(PRJ_DIR)/trace.vcd
	$(VCD) $(PRJ_DIR)/trace.vcd -s=half_adder_tb

full_adder_ex:
	$(eval PRJ_DIR := full_adder)
	$(eval WORK_DIR := $(PRJ_DIR)/work)
	$(eval FLAGS := $(FLAGS) --workdir=$(WORK_DIR))
	mkdir -p $(WORK_DIR)
	$(GHDL) -a $(FLAGS) $(PRJ_DIR)/full_adder.vhdl
	$(GHDL) -a $(FLAGS) $(PRJ_DIR)/full_adder_tb.vhdl
	$(GHDL) -e $(FLAGS) full_adder_tb
	$(GHDL) -r $(FLAGS) full_adder_tb --vcd=$(PRJ_DIR)/trace.vcd
	$(VCD) $(PRJ_DIR)/trace.vcd -s=full_adder_tb

ripple_carry_adder_ex:
	$(eval PRJ_DIR := ripple_carry_adder)
	$(eval WORK_DIR := $(PRJ_DIR)/work)
	$(eval FLAGS := $(FLAGS) --workdir=$(WORK_DIR))
	mkdir -p $(WORK_DIR)
	$(GHDL) -a $(FLAGS) $(PRJ_DIR)/half_adder.vhdl
	$(GHDL) -a $(FLAGS) $(PRJ_DIR)/full_adder.vhdl
	$(GHDL) -a $(FLAGS) $(PRJ_DIR)/ripple_carry_adder_tb.vhdl
	$(GHDL) -e $(FLAGS) ripple_carry_adder_tb
	$(GHDL) -r $(FLAGS) ripple_carry_adder_tb --vcd=$(PRJ_DIR)/trace.vcd
	$(VCD) $(PRJ_DIR)/trace.vcd -s=ripple_carry_adder_tb > $(PRJ_DIR)/trace.txt
	cat $(PRJ_DIR)/trace.txt

clean:
	rm -rf logic_gates/work logic_gates/trace.vcd logic_gates/trace.txt
	rm -rf half_adder/work half_adder/trace.vcd half_adder/trace.txt
	rm -rf full_adder/work full_adder/trace.vcd full_adder/trace.txt
	rm -rf ripple_carry_adder/work ripple_carry_adder/trace.vcd ripple_carry_adder/trace.txt