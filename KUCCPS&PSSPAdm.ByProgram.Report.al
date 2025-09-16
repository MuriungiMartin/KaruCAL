#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 69286 "KUCCPS & PSSP Adm. By Program"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KUCCPS & PSSP Adm. By Program.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000019; 1000000019)
            {
            }
            column(ProgCode;"ACA-Programme".Code)
            {
            }
            column(ProgDesc;"ACA-Programme".Description)
            {
            }
            column(AdminJAB;"ACA-Programme"."Admissions JAB")
            {
            }
            column(AdminSSP;"ACA-Programme"."Admissions SSP")
            {
            }
            column(AdmisJabFem;"ACA-Programme"."Admissions JAB Female")
            {
            }
            column(AdmisJabMal;"ACA-Programme"."Admissions JAB Male")
            {
            }
            column(AdmisSSPFem;"ACA-Programme"."Admissions SSP Female")
            {
            }
            column(AdmisSSPMal;"ACA-Programme"."Admissions SSP Male")
            {
            }
            column(TotFemale;"ACA-Programme"."Admissions JAB Female"+"ACA-Programme"."Admissions SSP Female")
            {
            }
            column(TotMale;"ACA-Programme"."Admissions JAB Male"+"ACA-Programme"."Admissions SSP Male")
            {
            }
            column(TotStudents;"ACA-Programme"."Admissions JAB"+"ACA-Programme"."Admissions SSP")
            {
            }
            dataitem(UnknownTable61358;UnknownTable61358)
            {
                DataItemLink = "Admitted Degree"=field(Code);
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(CompName;info.Name)
                {
                }
                column(Address1;info.Address)
                {
                }
                column(Address2;info."Address 2")
                {
                }
                column(City;info.City)
                {
                }
                column(Phone1;info."Phone No.")
                {
                }
                column(Phone2;info."Phone No. 2")
                {
                }
                column(Fax;info."Fax No.")
                {
                }
                column(Pic;info.Picture)
                {
                }
                column(postCode;info."Post Code")
                {
                }
                column(CompEmail;info."E-Mail")
                {
                }
                column(HomePage;info."Home Page")
                {
                }
                column(seq;seq)
                {
                }
                column(AppLicNo;"ACA-Applic. Form Header"."Application No.")
                {
                }
                column(AdmisnNo;"ACA-Applic. Form Header"."Admission No")
                {
                }
                column(AdmittedDegree;"ACA-Applic. Form Header"."Admitted Degree")
                {
                }
                column(AdmittedStage;"ACA-Applic. Form Header"."Admitted To Stage")
                {
                }
                column(AdmittedSem;"ACA-Applic. Form Header"."Admitted Semester")
                {
                }
                column(SurName;"ACA-Applic. Form Header".Surname)
                {
                }
                column(OtherNames;"ACA-Applic. Form Header"."Other Names")
                {
                }
                column(Gender;"ACA-Applic. Form Header".Gender)
                {
                }
                column(IndexNo;"ACA-Applic. Form Header"."Index Number")
                {
                }
                column(sems;Sems)
                {
                }
                column(IntakeCode;"ACA-Applic. Form Header"."Intake Code")
                {
                }
                column(ModeOfStudy;"ACA-Applic. Form Header"."Mode of Study")
                {
                }
                column(FirstChoiceCat;"ACA-Applic. Form Header"."First Choice Category")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "ACA-Applic. Form Header"."First Choice Semester"<>Sems then CurrReport.Skip else begin
                      if NewProg then seq:=0;
                      NewProg:=false;
                    seq:=seq+1;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                NewProg:=true;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(FiltApplic)
                {
                    Caption = 'Apply FIlters Here';
                    field(Semes;Sems)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Semester';
                        TableRelation = "ACA-Semesters".Code;
                    }
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

    trigger OnPreReport()
    begin
        if info.Get() then begin
            info.CalcFields(Picture);
          end;
          Clear(seq);
        if Sems='' then Error('Specify the Semester');
    end;

    var
        info: Record "Company Information";
        userSetup: Record "User Setup";
        userSetup1: Record "User Setup";
        userSetup2: Record "User Setup";
        userSetup3: Record "User Setup";
        userSetup4: Record "User Setup";
        userSetup5: Record "User Setup";
        userSetup6: Record "User Setup";
        Sems: Code[20];
        seq: Integer;
        NewProg: Boolean;
}

