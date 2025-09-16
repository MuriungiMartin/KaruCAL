#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99434 "Generate Student Charges NFM"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Generate Student Charges NFM.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = where("Settlement Type"=const(NFM),"Settlement Type"=const(PSSP));
            RequestFilterFields = "Student No.",Semester,Stage,"System Created",Programme;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Bill_StudentsCaption;Bill_StudentsCaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Student_No_;"Student No.")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            var
                UserSetup: Record "User Setup";
                coReg2: Record UnknownRecord61532;
                coReg1: Record UnknownRecord61532;
                acadYears: Record UnknownRecord61382;
                FeeByStage: Record UnknownRecord61523;
                FeeByUnit: Record UnknownRecord61524;
                NoSeriesMgt: Codeunit NoSeriesManagement;
                GenSetup: Record UnknownRecord61534;
                StudentCharges: Record UnknownRecord61535;
                TotalCost: Decimal;
                StageCharges: Record UnknownRecord61533;
                NewStudentCharges: Record UnknownRecord61543;
                RecFound: Boolean;
                CoursePrerequisite: Record UnknownRecord61546;
                SPrereq: Record UnknownRecord61547;
                Stages: Record UnknownRecord61516;
                ProgStages: Record UnknownRecord61516;
                StudentUnits: Record UnknownRecord61549;
                StageUnits: Record UnknownRecord61517;
                EStageUnits: Record UnknownRecord61591;
                GenJnl: Record "Gen. Journal Line";
                Units: Record UnknownRecord61517;
                ExamsByStage: Record UnknownRecord61526;
                ExamsByUnit: Record UnknownRecord61527;
                Charges: Record UnknownRecord61515;
                Sems: Record UnknownRecord61692;
                SemFound: Boolean;
                DueDate: Date;
                ACARegStoppageReasons: Record UnknownRecord66620;
                Cust: Record Customer;
                GenBatches: Record "Gen. Journal Batch";
                window: Dialog;
                GLPosting: Codeunit "Gen. Jnl.-Post Line";
                SettlementType: Record UnknownRecord61522;
                CReg: Record UnknownRecord61532;
                CustPostGroup: Record "Customer Posting Group";
                Programmes: Record UnknownRecord61511;
                CourseReg: Record UnknownRecord61532;
                CourseReg2: Record UnknownRecord61532;
                Found: Boolean;
                LibCode: Text[30];
                LibRefCodes: Record UnknownRecord61562;
                Custs: Record Customer;
                UnitType: Text[100];
                TotalUnits: Integer;
                OldStud: Boolean;
                CReg2: Record UnknownRecord61532;
                PSemester: Record UnknownRecord61525;
                StudUnits: Record UnknownRecord61549;
                PStage: Record UnknownRecord61516;
                SFee: Record UnknownRecord61523;
                ExamR: Record UnknownRecord61548;
                Prog: Record UnknownRecord61511;
                Prog2: Record UnknownRecord61511;
                AcademicYear: Record UnknownRecord61382;
                IntakeRec: Record UnknownRecord61383;
                MultipleCombination: Record UnknownRecord61601;
                HostLedger: Record "ACA-Hostel Ledger";
                HostStudent: Record "ACA-Students Hostel Rooms";
                StudentUnits_2: Record UnknownRecord61549;
                ValidateUser: Codeunit "Validate User Permissions";
                RecType: Option " ",GL,Cust,Item,Supp,FA,Emp,Sal,CourseReg,prTrans,EmpTrans;
                YearOfAdmin: Integer;
            begin
                //IF (("Settlement Type"<>'NFM') OR ("Settlement Type"<>'PSSP'))THEN CurrReport.SKIP;
                if Stage <>'Y1S1' then CurrReport.Skip;
                StudentCharges.Reset;
                StudentCharges.SetRange("Student No.","ACA-Course Registration"."Student No.");
                StudentCharges.SetRange(StudentCharges.Stage,"ACA-Course Registration".Stage);
                StudentCharges.SetRange("Tuition Fee",true);
                if StudentCharges.FindFirst then CurrReport.Skip;
                FeeByStage.Reset;
                FeeByStage.SetRange(FeeByStage."Programme Code",Programme);
                FeeByStage.SetRange(FeeByStage."Stage Code",Stage);
                FeeByStage.SetRange(FeeByStage."Settlemet Type","Settlement Type");
                FeeByStage.SetRange(FeeByStage.Semester,Semester);
                //FeeByStage.SETRANGE(FeeByStage."Student Type","Student Type");
                if FeeByStage.Find('-') then begin
                TotalCost:=0;
                TotalCost:=TotalCost+FeeByStage."Break Down";
                if Modules > 0 then
                TotalCost:=TotalCost*Modules;

                StudentCharges.Init;
                StudentCharges.Programme:=Programme;
                StudentCharges.Stage:=Stage;
                StudentCharges.Semester:=Semester;
                StudentCharges."Student No.":="Student No.";
                StudentCharges."Reg. Transacton ID":="Reg. Transacton ID";
                StudentCharges."Transaction Type":=StudentCharges."transaction type"::"Stage Fees";
                StudentCharges.Date:="Registration Date";
                StudentCharges.Code:=Stage;
                if SettlementType.Get("Settlement Type") then begin
                if SettlementType.Installments = true then begin
                if FeeByStage."Seq."=0 then
                StudentCharges.Description:='Fees for' + ' ' + Programme + '-' + Stage + '-' + 'Inst 0'
                else if FeeByStage."Seq."=1 then
                StudentCharges.Description:='Fees for' + ' ' + Programme + '-' + Stage + '-' + 'Inst 1'
                else if FeeByStage."Seq."=2 then
                StudentCharges.Description:='Fees for' + ' ' + Programme + '-' + Stage + '-' + 'Inst 2'
                else if FeeByStage."Seq."=3 then
                StudentCharges.Description:='Fees for' + ' ' + Programme + '-' + Stage + '-' + 'Inst 3'
                else if FeeByStage."Seq."=4 then
                StudentCharges.Description:='Fees for' + ' ' + Programme + '-' + Stage + '-' + 'Inst 4'
                else
                StudentCharges.Description:='Fees for' + ' ' + Programme + '-' + Stage + '-' + 'Inst';

                StudentCharges.Distribution:=Stages."Distribution Part Time (%)";
                end else begin
                StudentCharges.Description:='Fees for' + ' ' + Programme + '-' + Stage;
                StudentCharges.Distribution:=Stages."Distribution Full Time (%)";
                end;
                end else begin
                StudentCharges.Description:='Fees for' + ' ' + Programme + '-' + Stage;
                end;

                CalcFields("Total Exempted");

                //Exemptions
                // IF "Total Exempted" > 0 THEN BEGIN
                // IF TotalUnits > 0 THEN BEGIN
                // TotalCost:=(TotalUnits-"Total Exempted")*(TotalCost/TotalUnits);
                // END;
                // END;

                ///////////////////////
                //Recalculate fee based on units
                // IF Modules > 0 THEN BEGIN
                // TotalCost:=0;
                //
                // PStage.RESET;
                // PStage.SETRANGE(PStage."Programme Code",Programme);
                // PStage.SETFILTER(PStage."Student No.","Student No.");
                // PStage.SETFILTER(PStage."Reg. ID","Reg. Transacton ID");
                // IF PStage.FIND('-') THEN BEGIN
                // REPEAT
                // PStage.CALCFIELDS(PStage."Units Taken");
                //
                // IF PStage."Units Taken" > 0 THEN BEGIN
                // SFee.RESET;
                // SFee.SETRANGE(SFee."Programme Code",Programme);
                // SFee.SETRANGE(SFee."Stage Code",PStage.Code);
                // SFee.SETRANGE(SFee."Settlemet Type","Settlement Type");
                // //SFee.SETRANGE(SFee.Semester,Semester);
                // //SFee.SETRANGE(SFee."Student Type","Student Type");
                // IF SFee.FIND('-') THEN BEGIN
                // TotalCost:=TotalCost+(SFee."Break Down"*PStage."Units Taken");
                // END ELSE
                // ERROR('No fee structure defined for %1.',PStage.Code)
                //
                // END;
                //
                // UNTIL PStage.NEXT = 0;
                // END;
                // END;
                ///////////////////////


                StudentCharges.Amount:=TotalCost;
                StudentCharges."Tuition Fee":=true;
                StudentCharges."Full Tuition Fee":=TotalCost;
                StudentCharges."Transacton ID":='';
                StudentCharges."Recovery Priority":=20;
                StudentCharges.Validate(StudentCharges."Transacton ID");
                StudentCharges.Insert;

                end;
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

    var
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Bill_StudentsCaptionLbl: label 'Bill Students';
        StudentPayments: Record UnknownRecord61536;
        StudentCharges: Record UnknownRecord61535;
        GenJnl: Record "Gen. Journal Line";
        Stages: Record UnknownRecord61516;
        Units: Record UnknownRecord61517;
        ExamsByStage: Record UnknownRecord61526;
        ExamsByUnit: Record UnknownRecord61527;
        Charges: Record UnknownRecord61515;
        Receipt: Record UnknownRecord61538;
        ReceiptItems: Record UnknownRecord61539;
        GenSetUp: Record UnknownRecord61534;
        StudentCharges2: Record UnknownRecord61535;
        CourseReg: Record UnknownRecord61532;
        CurrentBill: Decimal;
        GLEntry: Record "G/L Entry";
        CustLed: Record "Cust. Ledger Entry";
        BankLedg: Record "Bank Account Ledger Entry";
        DCustLedg: Record "Detailed Cust. Ledg. Entry";
        PDate: Date;
        DocNo: Code[20];
        VendLedg: Record "Vendor Ledger Entry";
        DVendLedg: Record "Detailed Vendor Ledg. Entry";
        VATEntry: Record "VAT Entry";
        CReg: Record UnknownRecord61532;
        StudCharges: Record UnknownRecord61535;
        CustLed2: Record "Cust. Ledger Entry";
        Receipt2: Record UnknownRecord61538;
        Cont: Boolean;
        Cust: Record Customer;
        CustPostGroup: Record "Customer Posting Group";
        window: Dialog;
        GLPosting: Codeunit "Gen. Jnl.-Post Line";
        Receipts: Record UnknownRecord61538;
        CustLedg: Record "Cust. Ledger Entry";
        DueDate: Date;
        Sems: Record UnknownRecord61692;
        "Settlement Type": Record UnknownRecord61522;
        Prog: Record UnknownRecord61511;
        StudHost: Record "ACA-Students Hostel Rooms";
}

