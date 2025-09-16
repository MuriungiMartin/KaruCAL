#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 66676 "Aca-Summ.Classification List 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Aca-Summ.Classification List 2.rdlc';

    dataset
    {
        dataitem(CoRegcs;UnknownTable66631)
        {
            CalcFields = "Prog. Name";
            RequestFilterFields = Programme,"Graduation Academic Year";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Picsz;CompanyInformation.Picture)
            {
            }
            column(CompNames;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address+' '+CompanyInformation."Address 2"+' '+CompanyInformation.City)
            {
            }
            column(CompPhones;CompanyInformation."Phone No."+' '+CompanyInformation."Phone No. 2")
            {
            }
            column(Mailsz;CompanyInformation."E-Mail"+' '+CompanyInformation."Home Page")
            {
            }
            column(StudNumber;CoRegcs."Student Number")
            {
            }
            column(StudName;CoRegcs."Student Name")
            {
            }
            column(Progs;CoRegcs.Programme)
            {
            }
            column(YoS;CoRegcs."Year of Study")
            {
            }
            column(GradAcadYear;CoRegcs."Graduation Academic Year")
            {
            }
            column(SchCode;CoRegcs."School Code")
            {
            }
            column(SchName;CoRegcs."School Name")
            {
            }
            column(Classification;CoRegcs.Classification)
            {
            }
            column(WAverage;CoRegcs."Weighted Average")
            {
            }
            column(ClassAverage;CoRegcs."Classified W. Average")
            {
            }
            column(ClassPass;CoRegcs."Final Classification Pass")
            {
            }
            column(ClassOrder;CoRegcs."Final Classification Order")
            {
            }
            column(ReqStageUnits;ACADefinedUnitsperYoS."Number of Units")
            {
            }
            column(TotalUnits;CoRegcs."Total Units")
            {
            }
            column(TotWeightedMarks;CoRegcs."Total Weighted Marks")
            {
            }
            column(AttainedStageUnits;CoRegcs."Attained Stage Units")
            {
            }
            column(ProgOption;CoRegcs."Programme Option")
            {
            }
            column(GradGroup;CoRegcs."Graduation group")
            {
            }
            column(ProgName;CoRegcs."Prog. Name")
            {
            }
            column(ser;AcaFinalConsMksCount.Serial)
            {
            }
            dataitem(NotGradReason;UnknownTable66633)
            {
                DataItemLink = "Student No."=field("Student Number"),"Graduation Academic Year"=field("Graduation Academic Year");
                column(ReportForNavId_28; 28)
                {
                }
                column(ResonCode;NotGradReason."Reason Code")
                {
                }
                column(ReasonDetails;NotGradReason."Reason Details")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ReqUnits);
                ACADefinedUnitsperYoS.Reset;
                ACADefinedUnitsperYoS.SetRange(Programme,CoRegcs.Programme);
                ACADefinedUnitsperYoS.SetRange("Year of Study",CoRegcs."Year of Study");
                if ACADefinedUnitsperYoS.Find('-') then begin
                  end;


                AcaFinalConsMksCount.Reset;
                AcaFinalConsMksCount.SetRange("Student No.",CoRegcs."Student Number");
                AcaFinalConsMksCount.SetRange("User Names",UserId);
                AcaFinalConsMksCount.SetRange("Graduation Academic Year",CoRegcs."Graduation Academic Year");
                AcaFinalConsMksCount.SetRange(Programme,CoRegcs.Programme);
                if AcaFinalConsMksCount.Find('-') then;
            end;

            trigger OnPreDataItem()
            begin
                ExamCoregForNumber.CopyFilters(CoRegcs);
                ExamCoregForNumber.SetCurrentkey(Programme,"Student Number");
                if ExamCoregForNumber.Find('-') then begin
                    repeat
                      begin
                      //
                      AcaFinalConsMksCount.Init;
                      AcaFinalConsMksCount."User Names":=UserId;
                      AcaFinalConsMksCount.Programme:=ExamCoregForNumber.Programme;
                      AcaFinalConsMksCount."Graduation Academic Year":=ExamCoregForNumber."Graduation Academic Year";
                      AcaFinalConsMksCount."Student No.":=ExamCoregForNumber."Student Number";
                      if  AcaFinalConsMksCount.Insert then;
                      end;
                      until ExamCoregForNumber.Next=0;
                  end;
                  AcaFinalConsMksCount.Reset;
                  AcaFinalConsMksCount.SetCurrentkey("Student No.");
                  if AcaFinalConsMksCount.Find('-') then begin
                    Clear(seqs);
                    repeat
                      begin
                        seqs:=seqs+1;
                        AcaFinalConsMksCount.Serial:=seqs;
                        AcaFinalConsMksCount.Modify;
                      end;
                        until AcaFinalConsMksCount.Next=0;
                    end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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

    trigger OnInitReport()
    begin
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then;
        CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        ReqUnits: Integer;
        ACADefinedUnitsperYoS: Record UnknownRecord78017;
        ExamCoregForNumber: Record UnknownRecord66631;
        AcaFinalConsMksCount: Record UnknownRecord77746 temporary;
        seqs: Integer;
        ACASuppExamCoReg: Record UnknownRecord66642;
}

