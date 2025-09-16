#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51524 "Student Fee Receipts"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Fee Receipts.rdlc';
    UseSystemPrinter = true;

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("Receipt No.");
            RequestFilterFields = "Receipt No.","Auto  Receipted","Auto  Receipt Date";
            column(ReportForNavId_5672; 5672)
            {
            }
            column(pic;CompanyInfo.Picture)
            {
            }
            column(compName;CompanyInfo.Name)
            {
            }
            column(compAddress;CompanyInfo.Address)
            {
            }
            column(compCity;CompanyInfo.City)
            {
            }
            column(compPhone;CompanyInfo."Phone No.")
            {
            }
            column(compEmail;CompanyInfo."E-Mail")
            {
            }
            column(compHomePage;CompanyInfo."Home Page")
            {
            }
            column(Receipt__Student_No__;"Student No.")
            {
            }
            column(Receipt__Receipt_No__;"Receipt No.")
            {
            }
            column(UserName;'You were served by: '+UserName)
            {
            }
            column(Names;Names)
            {
            }
            column(Receipt__Transaction_Date_;"Transaction Date")
            {
            }
            column(Receipt__Transaction_Time_;"Transaction Time")
            {
            }
            column(Receipt__User_ID_;"User ID")
            {
            }
            column(Intake;Intake)
            {
            }
            column(RecAmount;"ACA-Receipt".Amount)
            {
            }
            column(paymode;Format("ACA-Receipt"."Payment Mode"))
            {
            }
            column(transno;"ACA-Receipt"."Bank Slip/Cheque No")
            {
            }
            column(CurrBalance;CurrBalance)
            {
            }
            column(Pname;Pname)
            {
            }
            column(Mode____FORMAT__Payment_Mode_______Transaction_No_____Bank_Slip_Cheque_No_;'Mode: '+Format("Payment Mode")+',  Transaction No: '+"Bank Slip/Cheque No")
            {
            }
            column(NumberText_1_;NumberText[1])
            {
            }
            column(Desc_4_;Desc[4])
            {
            }
            column(Desc_5_;Desc[5])
            {
            }
            column(Receipt_Amount;Amount)
            {
            }
            column(Desc_1_;Desc[1])
            {
            }
            column(Desc_2_;Desc[2])
            {
            }
            column(Desc_3_;Desc[3])
            {
            }
            column(Amt_1_;Amt[1])
            {
            }
            column(Amt_2_;Amt[2])
            {
            }
            column(Amt_3_;Amt[3])
            {
            }
            column(Amt_4_;Amt[4])
            {
            }
            column(Amt_5_;Amt[5])
            {
            }
            column(Desc_7_;Desc[7])
            {
            }
            column(Desc_6_;Desc[6])
            {
            }
            column(Desc_12_;Desc[12])
            {
            }
            column(Desc_11_;Desc[11])
            {
            }
            column(Desc_10_;Desc[10])
            {
            }
            column(Desc_9_;Desc[9])
            {
            }
            column(Desc_8_;Desc[8])
            {
            }
            column(Amt_10_;Amt[10])
            {
            }
            column(Amt_9_;Amt[9])
            {
            }
            column(Amt_8_;Amt[8])
            {
            }
            column(Amt_7_;Amt[7])
            {
            }
            column(Amt_6_;Amt[6])
            {
            }
            column(Amt_11_;Amt[11])
            {
            }
            column(Amt_12_;Amt[12])
            {
            }
            column(Desc_13_;Desc[13])
            {
            }
            column(Amt_13_;Amt[13])
            {
            }
            column(Amt_14_;Amt[14])
            {
            }
            column(Desc_14_;Desc[14])
            {
            }
            column(Cashier__Caption;Cashier__CaptionLbl)
            {
            }
            column(Room;RoomNo)
            {
            }
            column(HostelName;HostelName)
            {
            }
            column(RoomNo_Receipt;"ACA-Receipt"."Room No")
            {
            }
            dataitem(CustL_1;"Cust. Ledger Entry")
            {
                DataItemLink = "Document No."=field("Receipt No."),"Customer No."=field("Student No.");
                column(ReportForNavId_1; 1)
                {
                }
                dataitem(DCustL;"Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Customer No."=field("Customer No."),"Cust. Ledger Entry No."=field("Entry No.");
                    DataItemTableView = where("Entry Type"=filter(Application));
                    column(ReportForNavId_4; 4)
                    {
                    }
                    column(ItemDesc;CustL_1.Description)
                    {
                    }
                    column(ItemAmount;CustL_1.Amount)
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                TDate:=Format("ACA-Receipt".Date);
                DFilter:='01/01/01..01/01/01';
                CDesc:='';
                RTotal:=0;
                i:=0;
                Clear(Pname);
                
                Clear(UserName);
                usersTable.Reset;
                usersTable.SetRange(usersTable."User Name","ACA-Receipt"."User ID");
                if usersTable.Find('-') then begin
                if usersTable."Full Name"<>'' then
                 UserName:=usersTable."Full Name"
                 else UserName:="ACA-Receipt"."User ID";
                end else UserName:="ACA-Receipt"."User ID";
                
                RAmount:="ACA-Receipt".Amount;
                
                
                RItems.Reset;
                RItems.SetRange(RItems."Receipt No","ACA-Receipt"."Receipt No.");
                if RItems.Find('-') then begin
                CDesc:='';
                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Student No.","ACA-Receipt"."Student No.");
                CourseReg.SetRange(CourseReg."Reg. Transacton ID",RItems."Reg. No");
                if CourseReg.Find('-') then begin
                prog.Reset;
                prog.SetRange(prog.Code,CourseReg.Programme);
                if prog.Find('-') then begin
                  Pname:=prog.Description;
                end;
                if CourseReg."Student Type" = CourseReg."student type"::"Full Time" then
                Intake:='Full Time'
                else
                Intake:='Part Time';
                
                CDesc:=CourseReg.Programme + ', ' + CourseReg.Stage + ', ' + CourseReg.Semester + ', ' + Intake;
                RegDate:=Format(CourseReg."Registration Date");
                PRegDate:=Format(CalcDate('-1D',CourseReg."Registration Date"));
                DFilter2:=RegDate +'..'+TDate;
                DFilter:='01/01/05..'+PRegDate;
                end;
                end;
                
                if CDesc ='' then begin
                RItems.Reset;
                RItems.SetRange(RItems."Receipt No","ACA-Receipt"."Receipt No.");
                if RItems.Find('+') then begin
                CDesc:='';
                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Student No.","ACA-Receipt"."Student No.");
                CourseReg.SetRange(CourseReg."Reg. Transacton ID",RItems."Reg. No");
                if CourseReg.Find('-') then begin
                if CourseReg."Student Type" = CourseReg."student type"::"Full Time" then
                Intake:='Full Time'
                else
                Intake:='Part Time';
                
                CDesc:=CourseReg.Programme + ', ' + CourseReg.Stage + ', ' + CourseReg.Semester + ', ' + Intake;
                RegDate:=Format(CourseReg."Registration Date");
                PRegDate:=Format(CalcDate('-1D',CourseReg."Registration Date"));
                DFilter2:=RegDate +'..'+TDate;
                DFilter:='01/01/05..'+PRegDate;
                end;
                end;
                end;
                
                
                RItems.Reset;
                RItems.SetRange(RItems."Receipt No","ACA-Receipt"."Receipt No.");
                if RItems.Find('+') then begin
                CDesc:='';
                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Student No.","ACA-Receipt"."Student No.");
                CourseReg.SetRange(CourseReg."Reg. Transacton ID",RItems."Reg. No");
                if CourseReg.Find('-') then begin
                if CourseReg."Student Type" = CourseReg."student type"::"Full Time" then
                Intake:='Full Time'
                else
                Intake:='Part Time';
                
                CDesc:=CourseReg.Programme + ', ' + CourseReg.Stage + ', ' + CourseReg.Semester + ', ' + Intake;
                end;
                end;
                
                
                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Reg. Transacton ID",RItems."Reg. No");
                if CourseReg.Find('-') = false then
                DFilter:='01/01/01..01/01/01';
                
                
                Cust.Reset;
                Cust.SetFilter(Cust."Date Filter",DFilter);
                Cust.SetRange(Cust."No.","ACA-Receipt"."Student No.");
                if  Cust.Find('-') then begin
                Cust.CalcFields(Cust."Balance (LCY)");
                Names :=Cust.Name;
                BalBF:=Cust."Balance (LCY)";
                end;
                
                Cust.Reset;
                Cust.SetFilter(Cust."Date Filter",DFilter2);
                Cust.SetRange(Cust."No.","ACA-Receipt"."Student No.");
                if  Cust.Find('-') then begin
                Cust.CalcFields(Cust."Debit Amount (LCY)",Cust."Credit Amount (LCY)",Cust."Balance (LCY)");
                Names :=Cust.Name;
                Debit:=Cust."Debit Amount (LCY)";
                Credit:=Cust."Credit Amount (LCY)";
                //IF BalBF > 0 THEN
                //OBal:=((Debit-BalBF)-Credit)
                //ELSE
                OBal:=((Debit+BalBF)-Credit);
                end;
                
                
                
                
                CheckReport.InitTextVariable;
                //CheckReport.FormatNoText(NumberText,CheckAmount,GenJnlLine."Currency Code");
                CheckReport.FormatNoText(NumberText,"ACA-Receipt".Amount,'');
                
                RoomNo:='';
                HLedger.Reset;
                HLedger.SetRange(HLedger."Space No","ACA-Receipt"."Room No", HLedger."Hostel Name");
                if HLedger.Find('-') then begin
                // IF Hostel.GET(HLedger."Hostel No") THEN
                HostelName:=Hostel.Description;
                end;
                
                StudHost.Reset;
                StudHost.SetRange(StudHost.Student,"ACA-Receipt"."Student No.");
                if StudHost.Find('-') then begin
                StudHost.CalcFields("Hostel Name");
                HostelName:=StudHost."Hostel Name";
                RoomNo:=StudHost."Space No";
                end;
                
                i:=0;
                CustL.Reset;
                CustL.SetRange(CustL."Customer No.","ACA-Receipt"."Student No.");
                CustL.SetRange(CustL."Document No.","ACA-Receipt"."Receipt No.");
                if CustL.Find('-') then begin
                DLedg.Reset;
                DLedg.SetRange(DLedg."Customer No.",CustL."Customer No.");
                DLedg.SetRange(DLedg."Applied Cust. Ledger Entry No.",CustL."Entry No.");
                DLedg.SetRange(DLedg."Entry Type",DLedg."entry type"::Application);
                if DLedg.Find('-') then begin
                repeat
                if DLedg.Amount<0 then begin
                i:=i+1;
                if CustL2.Get(DLedg."Cust. Ledger Entry No.") then
                Desc[i]:=CustL2.Description;
                Amt[i]:=DLedg.Amount;
                end;
                until DLedg.Next=0;
                end;
                end;
                
                
                
                Clear(amountBilled);
                Clear(amountPaid);
                Clear(CurrBalance);
                //CLEAR("balB/F");
                
                      // populate Billed & Paid
                         Cust.Reset;
                         Cust.SetRange(Cust."No.","ACA-Receipt"."Student No.");
                         if Cust.Find('-') then begin
                         Cust.CalcFields(Cust."Balance (LCY)");
                           CurrBalance:=Cust."Balance (LCY)";
                         end;
                        /*
                         Cust.RESET;
                         Cust.SETRANGE(Cust."No.",Receipt."Student No.");
                         Cust.SETFILTER(Cust."Date Filter",'%1..%2',finCalender."Start Date",finCalender."End Date");
                         IF Cust.FIND('-') THEN BEGIN
                         Cust.CALCFIELDS(Cust."Credit Amount (LCY)",Cust."Imported Rcpt",Cust."Debit Amount (LCY)");
                            amountBilled:=Cust."Debit Amount (LCY)";
                            amountPaid:=Cust."Credit Amount (LCY)"+Cust."Imported Rcpt";
                         END;*/

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
         CompanyInfo.Reset;
         if CompanyInfo.Find('-') then begin
         CompanyInfo.CalcFields(Picture);
         end;
    end;

    var
        UserName: Text[250];
        usersTable: Record User;
        amountPaid: Decimal;
        amountBilled: Decimal;
        prog: Record UnknownRecord61511;
        Hostel: Record "ACA-Hostel Card";
        HLedger: Record "ACA-Hostel Ledger";
        Cust: Record Customer;
        Names: Text[200];
        Debit: Decimal;
        Credit: Decimal;
        "Oustanding Bal": Decimal;
        CourseReg: Record UnknownRecord61532;
        Course: Text[250];
        Intake: Text[50];
        GenJnlLine: Record "Gen. Journal Line";
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        CompanyInfo: Record "Company Information";
        CheckReport: Report Check;
        FormatAddr: Codeunit "Format Address";
        CheckToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        NumberText: array [2] of Text[80];
        CheckStatusText: Text[30];
        CheckAmount: Decimal;
        MCount: Integer;
        CDesc: Text[250];
        RItems: Record UnknownRecord61539;
        IBal: Decimal;
        OBal: Decimal;
        TDate: Text[50];
        DFilter: Text[150];
        DFilter2: Text[150];
        RegDate: Text[50];
        PRegDate: Text[50];
        BalBF: Decimal;
        Desc: array [20] of Text[100];
        Amt: array [20] of Decimal;
        i: Integer;
        CustL: Record "Cust. Ledger Entry";
        RTotal: Decimal;
        RAmount: Decimal;
        PrepaymentExist: Boolean;
        Cashier__CaptionLbl: label 'Cashier: ';
        RoomNo: Code[20];
        HostelName: Text[100];
        DLedg: Record "Detailed Cust. Ledg. Entry";
        StudHost: Record "ACA-Students Hostel Rooms";
        CustL2: Record "Cust. Ledger Entry";
        Pname: Text[150];
        CurrBalance: Decimal;
        studType: Code[30];
}

