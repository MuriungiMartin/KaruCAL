#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51511 "Exam Card Label-Plain"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Exam Card Label-Plain.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields = "Programme Filter","Stage Filter","Semester Filter","Intake Filter","Exam Period Filter",Status,"No.","Balance (LCY)";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(Customer_No_;"No.")
            {
            }
            column(Customer_Programme_Filter;"Programme Filter")
            {
            }
            column(Customer_Stage_Filter;"Stage Filter")
            {
            }
            column(Customer_Semester_Filter;"Semester Filter")
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = "Student No."=field("No."),Programme=field("Programme Filter"),Stage=field("Stage Filter"),Semester=field("Semester Filter");
                DataItemTableView = sorting("Student No.") where(Reversed=const(No),"Units Taken"=filter(<>0));
                MaxIteration = 1;
                column(ReportForNavId_2901; 2901)
                {
                }
                column(Addr_1__1_;Addr[1][1])
                {
                }
                column(Addr_1__2_;Addr[1][2])
                {
                }
                column(Addr_1__3_;Addr[1][3])
                {
                }
                column(Addr_1__4_;Addr[1][4])
                {
                }
                column(Addr_1__5_;Addr[1][5])
                {
                }
                column(Addr_1__6_;Addr[1][6])
                {
                }
                column(Addr_1__7_;Addr[1][7])
                {
                }
                column(Addr_2__1_;Addr[2][1])
                {
                }
                column(Addr_2__2_;Addr[2][2])
                {
                }
                column(Addr_2__3_;Addr[2][3])
                {
                }
                column(Addr_2__4_;Addr[2][4])
                {
                }
                column(Addr_2__5_;Addr[2][5])
                {
                }
                column(Addr_2__6_;Addr[2][6])
                {
                }
                column(Addr_2__7_;Addr[2][7])
                {
                }
                column(StudUnits_1__1_;StudUnits[1][1])
                {
                }
                column(StudUnits_1__2_;StudUnits[1][2])
                {
                }
                column(StudUnits_1__3_;StudUnits[1][3])
                {
                }
                column(StudUnits_1__5_;StudUnits[1][5])
                {
                }
                column(StudUnits_1__7_;StudUnits[1][7])
                {
                }
                column(StudUnits_1__4_;StudUnits[1][4])
                {
                }
                column(StudUnits_1__6_;StudUnits[1][6])
                {
                }
                column(StudUnits_1__8_;StudUnits[1][8])
                {
                }
                column(StudUnits_1__10_;StudUnits[1][10])
                {
                }
                column(StudUnits_1__9_;StudUnits[1][9])
                {
                }
                column(StudUnits_2__10_;StudUnits[2][10])
                {
                }
                column(StudUnits_2__9_;StudUnits[2][9])
                {
                }
                column(StudUnits_2__8_;StudUnits[2][8])
                {
                }
                column(StudUnits_2__7_;StudUnits[2][7])
                {
                }
                column(StudUnits_2__6_;StudUnits[2][6])
                {
                }
                column(StudUnits_2__5_;StudUnits[2][5])
                {
                }
                column(StudUnits_2__4_;StudUnits[2][4])
                {
                }
                column(StudUnits_2__3_;StudUnits[2][3])
                {
                }
                column(StudUnits_2__2_;StudUnits[2][2])
                {
                }
                column(StudUnits_2__1_;StudUnits[2][1])
                {
                }
                column(StudUnits_3__10_;StudUnits[3][10])
                {
                }
                column(StudUnits_4__10_;StudUnits[4][10])
                {
                }
                column(StudUnits_3__9_;StudUnits[3][9])
                {
                }
                column(StudUnits_4__9_;StudUnits[4][9])
                {
                }
                column(StudUnits_3__8_;StudUnits[3][8])
                {
                }
                column(StudUnits_4__8_;StudUnits[4][8])
                {
                }
                column(StudUnits_3__7_;StudUnits[3][7])
                {
                }
                column(StudUnits_4__7_;StudUnits[4][7])
                {
                }
                column(StudUnits_3__6_;StudUnits[3][6])
                {
                }
                column(StudUnits_4__6_;StudUnits[4][6])
                {
                }
                column(StudUnits_3__5_;StudUnits[3][5])
                {
                }
                column(StudUnits_4__5_;StudUnits[4][5])
                {
                }
                column(StudUnits_3__4_;StudUnits[3][4])
                {
                }
                column(StudUnits_4__4_;StudUnits[4][4])
                {
                }
                column(StudUnits_3__3_;StudUnits[3][3])
                {
                }
                column(StudUnits_4__3_;StudUnits[4][3])
                {
                }
                column(StudUnits_3__2_;StudUnits[3][2])
                {
                }
                column(StudUnits_4__2_;StudUnits[4][2])
                {
                }
                column(StudUnits_3__1_;StudUnits[3][1])
                {
                }
                column(StudUnits_4__1_;StudUnits[4][1])
                {
                }
                column(Addr_3__7_;Addr[3][7])
                {
                }
                column(Addr_4__7_;Addr[4][7])
                {
                }
                column(Addr_3__6_;Addr[3][6])
                {
                }
                column(Addr_4__6_;Addr[4][6])
                {
                }
                column(Addr_3__5_;Addr[3][5])
                {
                }
                column(Addr_4__5_;Addr[4][5])
                {
                }
                column(Addr_3__4_;Addr[3][4])
                {
                }
                column(Addr_4__4_;Addr[4][4])
                {
                }
                column(Addr_3__3_;Addr[3][3])
                {
                }
                column(Addr_4__3_;Addr[4][3])
                {
                }
                column(Addr_3__2_;Addr[3][2])
                {
                }
                column(Addr_4__2_;Addr[4][2])
                {
                }
                column(Addr_3__1_;Addr[3][1])
                {
                }
                column(Addr_4__1_;Addr[4][1])
                {
                }
                column(Exam_PeriodCaption;Exam_PeriodCaptionLbl)
                {
                }
                column(Student_TypeCaption;Student_TypeCaptionLbl)
                {
                }
                column(LevelCaption;LevelCaptionLbl)
                {
                }
                column(ProgrammeCaption;ProgrammeCaptionLbl)
                {
                }
                column(Admission_No_Caption;Admission_No_CaptionLbl)
                {
                }
                column(Student_No_Caption;Student_No_CaptionLbl)
                {
                }
                column(NamesCaption;NamesCaptionLbl)
                {
                }
                column(Units_Taken_Caption;Units_Taken_CaptionLbl)
                {
                }
                column(Units_Taken_Caption_Control1102756023;Units_Taken_Caption_Control1102756023Lbl)
                {
                }
                column(NamesCaption_Control1102756024;NamesCaption_Control1102756024Lbl)
                {
                }
                column(Student_No_Caption_Control1102756025;Student_No_Caption_Control1102756025Lbl)
                {
                }
                column(Admission_No_Caption_Control1102756026;Admission_No_Caption_Control1102756026Lbl)
                {
                }
                column(ProgrammeCaption_Control1102756027;ProgrammeCaption_Control1102756027Lbl)
                {
                }
                column(LevelCaption_Control1102756028;LevelCaption_Control1102756028Lbl)
                {
                }
                column(Student_TypeCaption_Control1102756029;Student_TypeCaption_Control1102756029Lbl)
                {
                }
                column(Exam_PeriodCaption_Control1102756030;Exam_PeriodCaption_Control1102756030Lbl)
                {
                }
                column(SignatureCaption;SignatureCaptionLbl)
                {
                }
                column(SignatureCaption_Control1102756044;SignatureCaption_Control1102756044Lbl)
                {
                }
                column(SignatureCaption_Control1102756109;SignatureCaption_Control1102756109Lbl)
                {
                }
                column(SignatureCaption_Control1102756111;SignatureCaption_Control1102756111Lbl)
                {
                }
                column(Units_Taken_Caption_Control1102756153;Units_Taken_Caption_Control1102756153Lbl)
                {
                }
                column(Units_Taken_Caption_Control1102756154;Units_Taken_Caption_Control1102756154Lbl)
                {
                }
                column(Exam_PeriodCaption_Control1102756159;Exam_PeriodCaption_Control1102756159Lbl)
                {
                }
                column(Student_TypeCaption_Control1102756165;Student_TypeCaption_Control1102756165Lbl)
                {
                }
                column(LevelCaption_Control1102756171;LevelCaption_Control1102756171Lbl)
                {
                }
                column(ProgrammeCaption_Control1102756180;ProgrammeCaption_Control1102756180Lbl)
                {
                }
                column(Admission_No_Caption_Control1102756183;Admission_No_Caption_Control1102756183Lbl)
                {
                }
                column(Student_No_Caption_Control1102756189;Student_No_Caption_Control1102756189Lbl)
                {
                }
                column(NamesCaption_Control1102756195;NamesCaption_Control1102756195Lbl)
                {
                }
                column(Exam_PeriodCaption_Control1102756199;Exam_PeriodCaption_Control1102756199Lbl)
                {
                }
                column(Student_TypeCaption_Control1102756200;Student_TypeCaption_Control1102756200Lbl)
                {
                }
                column(LevelCaption_Control1102756201;LevelCaption_Control1102756201Lbl)
                {
                }
                column(ProgrammeCaption_Control1102756202;ProgrammeCaption_Control1102756202Lbl)
                {
                }
                column(Admission_No_Caption_Control1102756203;Admission_No_Caption_Control1102756203Lbl)
                {
                }
                column(Student_No_Caption_Control1102756204;Student_No_Caption_Control1102756204Lbl)
                {
                }
                column(NamesCaption_Control1102756205;NamesCaption_Control1102756205Lbl)
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
                begin
                    RecordNo := RecordNo + 1;
                    ColumnNo := ColumnNo + 1;

                    progrec.Reset;
                    Programmedesc:='';
                    progrec.SetRange(progrec.Code,"ACA-Course Registration".Programme);
                    if progrec.Find('-') then begin
                      Programmedesc:=progrec.Description;
                    end;


                    //"Course Registration".CALCFIELDS("Course Registration".Faculty);

                    dimrec.Reset;
                    DimDesc:='';
                    //dimrec.SETRANGE(dimrec.Code,"Course Registration".Faculty);
                    if dimrec.Find('-') then begin
                      DimDesc:=dimrec.Name;
                    end;

                    //....

                    if Students.Get("ACA-Course Registration"."Student No.") then
                    "ACA-Course Registration".CalcFields("ACA-Course Registration"."Units Taken");
                    if "ACA-Course Registration"."Units Taken">0 then begin
                    Addr[ColumnNo][1] := Format(Students.Name);
                    Addr[ColumnNo][2] := Format("ACA-Course Registration"."Student No.");
                    Addr[ColumnNo][3] := Format("ACA-Course Registration"."Admission No.");
                    if Programmes.Get("ACA-Course Registration".Programme) then
                    Addr[ColumnNo][4] := Format(Programmes.Description);
                    if Stages.Get("ACA-Course Registration".Programme,"ACA-Course Registration".Stage) then
                    Addr[ColumnNo][5] := Format(Stages.Description);
                    Addr[ColumnNo][6] := Format("ACA-Course Registration"."Student Type");
                    Addr[ColumnNo][7] := Format(Customer.GetFilter(Customer."Exam Period Filter"));

                    CompressArray(Addr[ColumnNo][7]);
                    //CLEAR(StudUnits[ColumnNo][ColumnNo]);

                      for i:=1 to 10 do begin
                        Clear(StudUnits[ColumnNo][i]);
                      end;


                     x:=0;
                    StudentUnits.Reset;
                    StudentUnits.SetRange(StudentUnits.Taken,true);
                    StudentUnits.SetRange(StudentUnits.Programme,"ACA-Course Registration".Programme);
                    StudentUnits.SetRange(StudentUnits.Stage,"ACA-Course Registration".Stage);
                    StudentUnits.SetRange(StudentUnits.Semester,"ACA-Course Registration".Semester);
                    StudentUnits.SetRange(StudentUnits."Student No.","ACA-Course Registration"."Student No.");
                    //StudentUnits.SETRANGE(StudentUnits."Reg. Transacton ID","Course Registration"."Reg. Transacton ID");
                    if StudentUnits.Find('-') then

                    repeat
                     x := x + 1;
                     Units.Reset;
                     Units.SetRange(Units."Programme Code",StudentUnits.Programme);
                     Units.SetRange(Units."Stage Code",StudentUnits.Stage);
                     Units.SetRange(Units.Code,StudentUnits.Unit);
                     if Units.Find('-') then
                      StudUnits[ColumnNo][x] := Format(StudentUnits.Unit) + ' - ' + Format(Units.Desription);
                    until StudentUnits.Next = 0;
                    end;
                    //....

                    CompressArray(StudUnits[ColumnNo][ColumnNo]) ;


                    if RecordNo = NoOfRecords then begin

                      for i := ColumnNo + 1 to NoOfColumns do
                        Clear(Addr[i][i]);

                      ColumnNo := 0;
                    end else begin
                      if ColumnNo = NoOfColumns then
                        ColumnNo := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfRecords := Count;
                    NoOfColumns := 4;

                    "ACA-Course Registration".SetFilter("ACA-Course Registration".Programme,Customer.GetFilter(Customer."Programme Filter"));
                    "ACA-Course Registration".SetFilter("ACA-Course Registration".Semester,Customer.GetFilter(Customer."Semester Filter"));
                    "ACA-Course Registration".SetFilter("ACA-Course Registration".Stage,Customer.GetFilter(Customer."Stage Filter"));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Customer.CalcFields(Customer."Student Programme");
                //Customer."Programme Filter"
            end;

            trigger OnPostDataItem()
            begin
                  /*
                  FOR i :=1 + 1 TO 100 DO BEGIN
                      CLEAR(StudUnits[i][i]);
                  END;
                  */

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
        Addr: array [50000,20] of Text[250];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        i: Integer;
        Sname: Text[150];
        Cust: Record Customer;
        dimrec: Record "Dimension Value";
        DimDesc: Text[150];
        Programmedesc: Text[150];
        progrec: Record UnknownRecord61511;
        Students: Record Customer;
        Programmes: Record UnknownRecord61511;
        Stages: Record UnknownRecord61516;
        StudUnits: array [100,100] of Text[250];
        StudentUnits: Record UnknownRecord61549;
        x: Integer;
        Units: Record UnknownRecord61517;
        y: Integer;
        EPeriod: Text[150];
        UnitArr: Integer;
        Exam_PeriodCaptionLbl: label 'Exam Period';
        Student_TypeCaptionLbl: label 'Student Type';
        LevelCaptionLbl: label 'Level';
        ProgrammeCaptionLbl: label 'Programme';
        Admission_No_CaptionLbl: label 'Admission No.';
        Student_No_CaptionLbl: label 'Student No.';
        NamesCaptionLbl: label 'Names';
        Units_Taken_CaptionLbl: label 'Units Taken:';
        Units_Taken_Caption_Control1102756023Lbl: label 'Units Taken:';
        NamesCaption_Control1102756024Lbl: label 'Names';
        Student_No_Caption_Control1102756025Lbl: label 'Student No.';
        Admission_No_Caption_Control1102756026Lbl: label 'Admission No.';
        ProgrammeCaption_Control1102756027Lbl: label 'Programme';
        LevelCaption_Control1102756028Lbl: label 'Level';
        Student_TypeCaption_Control1102756029Lbl: label 'Student Type';
        Exam_PeriodCaption_Control1102756030Lbl: label 'Exam Period';
        SignatureCaptionLbl: label 'Signature';
        SignatureCaption_Control1102756044Lbl: label 'Signature';
        SignatureCaption_Control1102756109Lbl: label 'Signature';
        SignatureCaption_Control1102756111Lbl: label 'Signature';
        Units_Taken_Caption_Control1102756153Lbl: label 'Units Taken:';
        Units_Taken_Caption_Control1102756154Lbl: label 'Units Taken:';
        Exam_PeriodCaption_Control1102756159Lbl: label 'Exam Period';
        Student_TypeCaption_Control1102756165Lbl: label 'Student Type';
        LevelCaption_Control1102756171Lbl: label 'Level';
        ProgrammeCaption_Control1102756180Lbl: label 'Programme';
        Admission_No_Caption_Control1102756183Lbl: label 'Admission No.';
        Student_No_Caption_Control1102756189Lbl: label 'Student No.';
        NamesCaption_Control1102756195Lbl: label 'Names';
        Exam_PeriodCaption_Control1102756199Lbl: label 'Exam Period';
        Student_TypeCaption_Control1102756200Lbl: label 'Student Type';
        LevelCaption_Control1102756201Lbl: label 'Level';
        ProgrammeCaption_Control1102756202Lbl: label 'Programme';
        Admission_No_Caption_Control1102756203Lbl: label 'Admission No.';
        Student_No_Caption_Control1102756204Lbl: label 'Student No.';
        NamesCaption_Control1102756205Lbl: label 'Names';
}

