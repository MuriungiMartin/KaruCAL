#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51542 "Student Billings"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Billings.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type") where(Posted=const(Yes),Reversed=const(No));
            RequestFilterFields = Programme,Stage,Semester,"Settlement Type","Student No.","Reg. Transacton ID";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(ColumnH_1_;ColumnH[1])
            {
            }
            column(ColumnH_8_;ColumnH[8])
            {
            }
            column(ColumnH_6_;ColumnH[6])
            {
            }
            column(ColumnH_7_;ColumnH[7])
            {
            }
            column(ColumnH_4_;ColumnH[4])
            {
            }
            column(ColumnH_3_;ColumnH[3])
            {
            }
            column(ColumnH_5_;ColumnH[5])
            {
            }
            column(ColumnH_2_;ColumnH[2])
            {
            }
            column(ColumnH_15_;ColumnH[15])
            {
            }
            column(ColumnH_14_;ColumnH[14])
            {
            }
            column(ColumnH_13_;ColumnH[13])
            {
            }
            column(ColumnH_12_;ColumnH[12])
            {
            }
            column(ColumnH_10_;ColumnH[10])
            {
            }
            column(ColumnH_9_;ColumnH[9])
            {
            }
            column(ColumnH_11_;ColumnH[11])
            {
            }
            column(ColumnH_23_;ColumnH[23])
            {
            }
            column(ColumnH_22_;ColumnH[22])
            {
            }
            column(ColumnH_21_;ColumnH[21])
            {
            }
            column(ColumnH_20_;ColumnH[20])
            {
            }
            column(ColumnH_19_;ColumnH[19])
            {
            }
            column(ColumnH_18_;ColumnH[18])
            {
            }
            column(ColumnH_17_;ColumnH[17])
            {
            }
            column(ColumnH_16_;ColumnH[16])
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Course_Registration__Registration_Date_;"Registration Date")
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(Course_Registration__Fees_Billed_;"Fees Billed")
            {
            }
            column(ColumnV_1_;ColumnV[1])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_8_;ColumnV[8])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_7_;ColumnV[7])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_6_;ColumnV[6])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_5_;ColumnV[5])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_4_;ColumnV[4])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_3_;ColumnV[3])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_2_;ColumnV[2])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_14_;ColumnV[14])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_13_;ColumnV[13])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_12_;ColumnV[12])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_11_;ColumnV[11])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_10_;ColumnV[10])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_9_;ColumnV[9])
            {
                DecimalPlaces = 0:0;
            }
            column(Course_Registration__Total_Billed_;"Total Billed")
            {
            }
            column(ColumnV_23_;ColumnV[23])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_22_;ColumnV[22])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_21_;ColumnV[21])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_20_;ColumnV[20])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_19_;ColumnV[19])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_18_;ColumnV[18])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_17_;ColumnV[17])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_16_;ColumnV[16])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_15_;ColumnV[15])
            {
                DecimalPlaces = 0:0;
            }
            column(Course_Registration__Total_Billed__Control1102760065;"Total Billed")
            {
            }
            column(Course_Registration__Fees_Billed__Control1102760066;"Fees Billed")
            {
            }
            column(TColumnV_1_;TColumnV[1])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_8_;TColumnV[8])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_7_;TColumnV[7])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_6_;TColumnV[6])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_5_;TColumnV[5])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_4_;TColumnV[4])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_3_;TColumnV[3])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_2_;TColumnV[2])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_14_;TColumnV[14])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_13_;TColumnV[13])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_12_;TColumnV[12])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_11_;TColumnV[11])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_10_;TColumnV[10])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_9_;TColumnV[9])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_23_;TColumnV[23])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_22_;TColumnV[22])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_21_;TColumnV[21])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_20_;TColumnV[20])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_19_;TColumnV[19])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_18_;TColumnV[18])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_17_;TColumnV[17])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_16_;TColumnV[16])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_15_;TColumnV[15])
            {
                DecimalPlaces = 0:0;
            }
            column(SCount;SCount)
            {
                DecimalPlaces = 0:0;
            }
            column(Student_Billings_AnalysisCaption;Student_Billings_AnalysisCaptionLbl)
            {
            }
            column(Course_Registration_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Course_Registration_StageCaption;FieldCaption(Stage))
            {
            }
            column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Course_Registration__Registration_Date_Caption;FieldCaption("Registration Date"))
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(Course_Registration__Fees_Billed_Caption;FieldCaption("Fees Billed"))
            {
            }
            column(Course_Registration__Total_Billed_Caption;FieldCaption("Total Billed"))
            {
            }
            column(TotalsCaption;TotalsCaptionLbl)
            {
            }
            column(Student_CountCaption;Student_CountCaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
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
            begin
                i:=0;

                Charges.Reset;
                Charges.SetRange(Charges.Show,true);
                Charges.SetFilter(Charges."Student No. Filter","ACA-Course Registration"."Student No.");
                Charges.SetFilter(Charges."Reg. ID Filter","ACA-Course Registration"."Reg. Transacton ID");
                if Charges.Find('-') then begin
                repeat
                Charges.CalcFields(Charges."Total Billing");
                i:=i+1;
                ColumnH[i]:=Charges.Code;
                ColumnV[i]:=Charges."Total Billing";
                TColumnV[i]:=TColumnV[i]+Charges."Total Billing";

                until Charges.Next = 0;
                end;

                SCount:=SCount+1;


                if Cust.Get("ACA-Course Registration"."Student No.") then
;

            trigger OnPreDataItem()
            begin
                SCount:=0;
                //"Course Registration".SETRANGE("Course Registration".Programme,GETFILTER("Course Registration"."Programme Filter"));
                //"Course Registration".SETRANGE("Course Registration".Stage,GETFILTER("Course Registration"."Stage Filter"));
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
        Cust: Record Customer;
        Charges: Record UnknownRecord61515;
        ColumnH: array [30] of Text[100];
        ColumnV: array [30] of Decimal;
        i: Integer;
        TColumnV: array [30] of Decimal;
        SCount: Integer;
        Student_Billings_AnalysisCaptionLbl: label 'Student Billings Analysis';
        NamesCaptionLbl: label 'Names';
        TotalsCaptionLbl: label 'Totals';
        Student_CountCaptionLbl: label 'Student Count';
}

