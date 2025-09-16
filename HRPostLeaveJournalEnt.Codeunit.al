#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60198 "HR Post Leave Journal Ent."
{

    trigger OnRun()
    var
        progre: Dialog;
        counts: Integer;
        RecCount1: Text[120];
        RecCount2: Text[120];
        RecCount3: Text[120];
        RecCount4: Text[120];
        RecCount5: Text[120];
        RecCount6: Text[120];
        RecCount7: Text[120];
        RecCount8: Text[120];
        RecCount9: Text[120];
        RecCount10: Text[120];
        BufferString: Text[1024];
        Var1: Code[10];
    begin

        if Confirm('Post Leave Journal Lines?',false)=false then exit;

         hrLeaveJournal.Reset;
        // HrEmployee.SETRANGE(HrEmployee."Employee Type",HrEmployee."Employee Type"::Permanent);
         //HrEmployee.SETRANGE(HrEmployee.Status,HrEmployee.Status::Normal);
         if hrLeaveJournal.Find('-') then begin

        Clear(RecCount1);
        Clear(RecCount2);
        Clear(RecCount3);
        Clear(RecCount4);
        Clear(RecCount5);
        Clear(RecCount6);
        Clear(RecCount7);
        Clear(RecCount8);
        Clear(RecCount9);
        Clear(RecCount10);
        Clear(counts);
        progre.Open('Processing Please wait..............\#1###############################################################'+
        '\#2###############################################################'+
        '\#3###############################################################'+
        '\#4###############################################################'+
        '\#5###############################################################'+
        '\#6###############################################################'+
        '\#7###############################################################'+
        '\#8###############################################################'+
        '\#9###############################################################'+
        '\#10###############################################################'+
        '\#11###############################################################'+
        '\#12###############################################################'+
        '\#13###############################################################',
            RecCount1,
            RecCount2,
            RecCount3,
            RecCount4,
            RecCount5,
            RecCount6,
            RecCount7,
            RecCount8,
            RecCount9,
            RecCount10,
            Var1,
            Var1,
            BufferString
        );
        Clear(lastNo);
             leaveLedger.Reset;
             leaveLedger.SetFilter(leaveLedger."Entry No.",'<>%1',0);
             if leaveLedger.FindLast then begin
             lastNo:=leaveLedger."Entry No."+10;
             end else lastNo:=10;
         repeat
         //Post Leave Journals
            leaveLedger.Init;
             leaveLedger."Entry No.":=lastNo;
             leaveLedger."Employee No":=hrLeaveJournal."Staff No.";
             leaveLedger."Document No":=hrLeaveJournal."Document No.";
             leaveLedger."Leave Type":=hrLeaveJournal."Leave Type";
             leaveLedger."Transaction Date":=hrLeaveJournal."Posting Date";
             leaveLedger."Transaction Type":=hrLeaveJournal."Transaction Type";
             if ((hrLeaveJournal."Transaction Type"=hrLeaveJournal."transaction type"::"Positive Adjustment") or
             (hrLeaveJournal."Transaction Type"=hrLeaveJournal."transaction type"::Allocation)) then
             leaveLedger."No. of Days":=hrLeaveJournal."No. of Days"
             else
             if ((hrLeaveJournal."Transaction Type"=hrLeaveJournal."transaction type"::"Negative Adjustment") or
             (hrLeaveJournal."Transaction Type"=hrLeaveJournal."transaction type"::Application)) then
             leaveLedger."No. of Days":=((hrLeaveJournal."No. of Days")*(-1));

             leaveLedger."Transaction Description":=hrLeaveJournal."Transaction Description";
             leaveLedger."Leave Period":=Date2dwy(Today,3);
             leaveLedger."Created By":=UserId;
            leaveLedger.Insert;
             lastNo:=lastNo+10;
        // Insert into the ledger entry table
          if HrEmployee.Get(hrLeaveJournal."Staff No.")then begin
          end;
        Clear(Var1);
            counts:=counts+1;
            if counts=1 then
            RecCount1:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
        HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
            else if counts=2 then begin
            RecCount2:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
        HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
            end
            else if counts=3 then begin
            RecCount3:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
        HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
            end
            else if counts=4 then begin
            RecCount4:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
        HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
            end
            else if counts=5 then begin
            RecCount5:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
        HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
            end
            else if counts=6 then begin
            RecCount6:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
        HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
            end
            else if counts=7 then begin
            RecCount7:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
        HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
            end
            else if counts=8 then begin
            RecCount8:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
        HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
            end
            else if counts=9 then begin
            RecCount9:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
        HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
            end
            else if counts=10 then begin
            RecCount10:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
        HrEmployee."Middle Name"+' '+HrEmployee."Last Name"
            end else if counts>10 then begin
            RecCount1:=RecCount2;
            RecCount2:=RecCount3;
            RecCount3:=RecCount4;
            RecCount4:=RecCount5;
            RecCount5:=RecCount6;
            RecCount6:=RecCount7;
            RecCount7:=RecCount8;
            RecCount8:=RecCount9;
            RecCount9:=RecCount10;
            RecCount10:=Format(counts)+'). '+HrEmployee."No."+':'+HrEmployee."First Name"+' '+
        HrEmployee."Middle Name"+' '+HrEmployee."Last Name";
            end;
            Clear(BufferString);
            BufferString:='Total Records processed = '+Format(counts);

            progre.Update();

         until  hrLeaveJournal.Next=0;
         ////Progress Window
         progre.Close;
         end;
         hrLeaveJournal.DeleteAll;
         Message('Leave Journal posted successfully!');
    end;

    var
        lastNo: Integer;
        hrLeaveJournal: Record UnknownRecord61618;
        leaveLedger: Record UnknownRecord61659;
        objEmp: Record UnknownRecord61188;
        SalCard: Record UnknownRecord61105;
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodMonth: Integer;
        PeriodYear: Integer;
        ProcessPayroll: Codeunit "BankAcc.Recon. PostNew";
        HrEmployee: Record UnknownRecord61188;
        ProgressWindow: Dialog;
        prPeriodTransactions: Record UnknownRecord61092;
        prEmployerDeductions: Record UnknownRecord61094;
        PayrollType: Record UnknownRecord61103;
        Selection: Integer;
        PayrollDefined: Text[30];
        PayrollCode: Code[10];
        NoofRecords: Integer;
        i: Integer;
        ContrInfo: Record UnknownRecord61119;
        HREmp: Record UnknownRecord61188;
        j: Integer;
        PeriodTrans: Record UnknownRecord61092;
        salaryCard: Record UnknownRecord61105;
        dateofJoining: Date;
        dateofLeaving: Date;
        GetsPAYERelief: Boolean;
        DOJ: Date;
        SalCard2: Record UnknownRecord61105;
}

