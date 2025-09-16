#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51779 "Population By Prog. Category"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Population By Prog. Category.rdlc';

    dataset
    {
        dataitem("Dimension Value";"Dimension Value")
        {
            DataItemTableView = where("Dimension Code"=filter('DEPARTMENT'));
            column(ReportForNavId_1; 1)
            {
            }
            column(Title2;'University Population Analysis by Programme Category')
            {
            }
            column(Title1;'STUDENT POPULATION PER CAMPUS & CATEGORY AS AT '+Format(Today,0,4)+ ', '+Semes)
            {
            }
            column(pic;info.Picture)
            {
            }
            column(SchoolName;"Dimension Value".Name)
            {
            }
            dataitem(UnknownTable61511;UnknownTable61511)
            {
                DataItemLink = "Department Code"=field(Code);
                column(ReportForNavId_2; 2)
                {
                }
                column(ProgCode;"ACA-Programme".Code+': '+"ACA-Programme".Description)
                {
                }
                column(Bridging;Bridging1)
                {
                }
                column(Certificate;Certificate1)
                {
                }
                column(Diploma;Diploma1)
                {
                }
                column(Degree;Degree1)
                {
                }
                column(MASTERS;MASTERS1)
                {
                }
                column(CourseTotals;CourseTotals1)
                {
                }

                trigger OnAfterGetRecord()
                begin

                       Clear(Bridging1);
                       Clear(Certificate1);
                       Clear(Diploma1);
                       Clear(Degree1);
                       Clear(MASTERS);
                       Clear(MASTERS1);
                       Clear(CourseTotals1);

                       Clear(Bridging);
                       Clear(Certificate);
                       Clear(Diploma);
                       Clear(Degree);
                       Clear(CourseTotals);



                     student.Reset;
                     //student.SETRANGE(student."Customer Type",student."Customer Type"::Student);
                     student.SetRange(student.Programme,"ACA-Programme".Code);
                     student.SetRange(student.Semester,Format(Semes));
                     //student.SETRANGE(student."Academic Year",FORMAT(acadyear));
                     if "Student Category"="student category"::Continuing then
                     student.SetFilter(student.Stage,'<>%1','Y1S1');
                     if "Student Category"="student category"::New then
                      student.SetFilter(student.Stage,'=%1','Y1S1');

                     if student.Find('-') then begin
                     repeat
                      begin
                         if "ACA-Programme"."Exam Category"='PROFFESSIONAL' then begin
                             Bridging1:=Bridging1+1;
                             schBridgTotal1:=schBridgTotal1+1;
                             BridgGrandTotal1:=BridgGrandTotal1+1;
                              GrandTotals1:=GrandTotals1+1;
                              schTotals1:=schTotals1+1;
                              CourseTotals1:=CourseTotals1+1;
                         end;
                         if "ACA-Programme"."Exam Category"='CERTIFICATE' then begin
                         Certificate1:=Certificate1+1;
                         schCertTotal1:=schCertTotal1+1;
                         CertGrandTotal1:=CertGrandTotal1+1;
                          GrandTotals1:=GrandTotals1+1;
                          schTotals1:=schTotals1+1;
                          CourseTotals1:=CourseTotals1+1;
                         end;
                         if "ACA-Programme"."Exam Category"='UNDERGRADUATE' then begin
                          Degree1:=Degree1+1;
                          schDegTotal1:=schDegTotal1+1;
                          DegGrandTotal1:=DegGrandTotal1+1;
                           GrandTotals1:=GrandTotals1+1;
                           schTotals1:=schTotals1+1;
                           CourseTotals1:=CourseTotals1+1;
                         end;
                         if "ACA-Programme"."Exam Category"='DIPLOMA' then begin
                          Diploma1:=Diploma1+1;
                          schDipTotal1:=schDipTotal1+1;
                          DipGrandTotal1:=DipGrandTotal1+1;
                           GrandTotals1:=GrandTotals1+1;
                           schTotals1:=schTotals1+1;
                           CourseTotals1:=CourseTotals1+1;
                         end;
                         if "ACA-Programme"."Exam Category"='MASTERS' then begin
                             MASTERS1:=MASTERS1+1;
                             schMASTERSTotal1:=schMASTERSTotal1+1;
                             MASTERSGrandTotal1:=MASTERSGrandTotal1+1;
                              GrandTotals1:=GrandTotals1+1;
                              schTotals1:=schTotals1+1;
                              CourseTotals1:=CourseTotals1+1;
                         end;

                      end;
                     until student.Next=0;
                     end;

                    if schBridgTotal1<>0 then schBridgTotal:=Format(schBridgTotal1);
                    if schCertTotal1<>0 then schCertTotal:=Format(schCertTotal1);
                    if schDegTotal1<>0 then schDegTotal:=Format(schDegTotal1);
                    if schDipTotal1<>0 then schDipTotal:=Format(schDipTotal1);
                    if schMASTERSTotal1<>0 then schMASTERSTotal:=Format(schMASTERSTotal1);

                    if BridgGrandTotal1<>0 then BridgGrandTotal:=Format(BridgGrandTotal1);
                    if CertGrandTotal1<>0 then CertGrandTotal:=Format(CertGrandTotal1);
                    if DipGrandTotal1<>0 then DipGrandTotal:=Format(DipGrandTotal1);
                    if DegGrandTotal1<>0 then DegGrandTotal:=Format(DegGrandTotal1);
                    if MASTERSGrandTotal1<>0 then MASTERSGrandTotal:=Format(MASTERSGrandTotal1);
                     /////
                    if schTotals1<>0 then schTotals:=Format(schTotals1);
                    if GrandTotals1<>0 then GrandTotals:=Format(GrandTotals1);

                    if Degree1<>0 then Degree:=Format(Degree1);
                    if Diploma1<>0 then Diploma:=Format(Diploma1);
                    if Certificate1<>0 then Certificate:=Format(Certificate1);
                    if Bridging1<>0 then Bridging:=Format(Bridging1);
                    if MASTERS1<>0 then MASTERS:=Format(MASTERS1);

                    if CourseTotals1<>0 then CourseTotals:=Format(CourseTotals1);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                  Clear(schBridgTotal1);
                  Clear(schMASTERSTotal1);
                  Clear(schCertTotal1);
                  Clear(schDipTotal1);
                  Clear(schDegTotal1);
                  Clear(schTotals1);

                  Clear(schBridgTotal);
                  Clear(schMASTERSTotal);
                  Clear(schCertTotal);
                  Clear(schDipTotal);
                  Clear(schDegTotal);
                  Clear(schTotals);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Semz;Semes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester:';
                    TableRelation = "ACA-Semesters".Code;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
          if info.Get() then Semes :=info."Last Semester Filter";
    end;

    trigger OnPreReport()
    begin

         //IF acadyear = '' THEN ERROR('Specify the Academic year..');
         if Semes = '' then Error('Specify the semester..');

          Clear(BridgGrandTotal1);
          Clear(MASTERSGrandTotal1);
          Clear(CertGrandTotal1);
          Clear(DipGrandTotal1);
          Clear(DegGrandTotal1);
          Clear(GrandTotals1);

          Clear(BridgGrandTotal);
          Clear(CertGrandTotal);
          Clear(MASTERSGrandTotal);
          Clear(DipGrandTotal);
          Clear(DegGrandTotal);
          Clear(GrandTotals);

           info.Reset;
           if info.Find('-') then info.CalcFields(Picture);

        //IF ((acadyear<>'') AND (Semes<>'')) THEN acayrNsem:=', ACA YEAR: '+acadyear+','+Sems
        //ELSE acayrNsem:='';
    end;

    var
        "academic Year": Record UnknownRecord61382;
        campus: Record "Dimension Value";
        info: Record "Company Information";
        student: Record UnknownRecord61532;
        "Student Category": Option Continuing,New,All;
        Bridging1: Integer;
        MASTERS1: Integer;
        Certificate1: Integer;
        Diploma1: Integer;
        Degree1: Integer;
        CourseTotals1: Integer;
        schBridgTotal1: Integer;
        schMASTERSTotal1: Integer;
        schCertTotal1: Integer;
        schDipTotal1: Integer;
        schDegTotal1: Integer;
        schTotals1: Integer;
        BridgGrandTotal1: Integer;
        MASTERSGrandTotal1: Integer;
        CertGrandTotal1: Integer;
        DipGrandTotal1: Integer;
        DegGrandTotal1: Integer;
        Bridging: Code[50];
        MASTERS: Code[50];
        Certificate: Code[50];
        Diploma: Code[50];
        Degree: Code[50];
        CourseTotals: Code[50];
        schBridgTotal: Code[50];
        schMASTERSTotal: Code[50];
        schCertTotal: Code[50];
        schDipTotal: Code[50];
        schDegTotal: Code[50];
        schTotals: Code[50];
        BridgGrandTotal: Code[50];
        MASTERSGrandTotal: Code[50];
        CertGrandTotal: Code[50];
        DipGrandTotal: Code[50];
        DegGrandTotal: Code[50];
        GrandTotals: Code[50];
        GrandTotals1: Integer;
        Semes: Code[50];
        courseRegst: Record UnknownRecord61532;
        stages: Option " ","New Students","Continuing Students","All Stages";
        bal: Decimal;
        stud: Record Customer;
        constLine: Text[250];
        Text000: label 'Period: %1';
        Text001: label 'NORMINAL ROLE';
        Text002: label 'NORMINAL ROLE';
        Text003: label 'POG. CODE';
        Text004: label 'DIPLOMA';
        Text005: label 'Company Name';
        Text006: label 'Report No.';
        Text007: label 'Report Name';
        Text008: label 'User ID';
        Text009: label 'Date';
        Text010: label 'G/L Filter';
        Text011: label 'Period Filter';
        Text012: label 'BRIDGING';
        Text013: label 'CERTIFICATE';
        Text014: label 'Total Amount';
        Text015: label 'PROG. DESCRITION';
        Text016: label 'COURSE TOTALS';
        Text017: label 'DEGREE';
        Text020: label 'ACAD. YEAR';
        Text021: label 'STAGE';
        Text022: label 'STUD. TYPE';
        Text023: label 'SEMESTER';
        Text024: label '--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
}

