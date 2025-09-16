#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77365 "Admission Approvals Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Admission Approvals Summary.rdlc';

    dataset
    {
        dataitem(KuccpsImports;UnknownTable70082)
        {
            RequestFilterFields = Index,Admin,Prog;
            column(ReportForNavId_1000000010; 1000000010)
            {
            }
            column(AdmissionNumber;KuccpsImports.Admin)
            {
            }
            column(ProgCode;KuccpsImports.Prog)
            {
            }
            column(StudNames;KuccpsImports.Names)
            {
            }
            column(StudGender;KuccpsImports.Gender)
            {
            }
            column(Phone;KuccpsImports.Phone+'   '+KuccpsImports."Alt. Phone")
            {
            }
            column(Box;KuccpsImports.Box)
            {
            }
            column(PostalCode;KuccpsImports.Codes)
            {
            }
            column(Town;KuccpsImports.Town)
            {
            }
            column(Email;KuccpsImports.Email)
            {
            }
            column(AssRoom;KuccpsImports."Assigned Room")
            {
            }
            column(AssSpace;KuccpsImports."Assigned Space")
            {
            }
            column(AssBlock;KuccpsImports."Assigned Block")
            {
            }
            column(NonResOwner;KuccpsImports."Non-Resident Owner")
            {
            }
            column(NonResidentAddress;KuccpsImports."Non-Resident Address")
            {
            }
            column(NonResidentPhone;KuccpsImports."Residential Owner Phone")
            {
            }
            column(FundingCategory;KuccpsImports."Funding Category")
            {
            }
            column(Confirmed;KuccpsImports.Confirmed)
            {
            }
            column(Accomodation;KuccpsImports.Accomodation)
            {
            }
            column(ResidentOwner;KuccpsImports."Non-Resident Owner")
            {
            }
            column(ResidentAddress;KuccpsImports."Non-Resident Address")
            {
            }
            column(ResidentOwnerNumber;KuccpsImports."Residential Owner Phone")
            {
            }
            column(Processed;KuccpsImports.Processed)
            {
            }
            column(IDBirthCer;KuccpsImports."ID Number/BirthCert")
            {
            }
            column(IntakeCode;KuccpsImports."Intake Code")
            {
            }
            column(Updated;KuccpsImports.Updated)
            {
            }
            column(NIIMSNo;KuccpsImports."NIIMS No")
            {
            }
            column(NHIFNumber;KuccpsImports."NHIF No")
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(Logo;CompanyInformation.Picture)
            {
            }
            column(Department;DepartmentName)
            {
            }
            column(School;SchoolName)
            {
            }
            column(ProgName;ACAProgramme.Description)
            {
            }
            column(Semester;Sems.Code)
            {
            }
            column(Country;KuccpsImports.County)
            {
            }
            dataitem(NewStudCharges;UnknownTable77360)
            {
                DataItemLink = "Academic Year"=field("Academic Year"),"Index Number"=field(Index);
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(AcadYear;NewStudCharges."Academic Year")
                {
                }
                column(Index;NewStudCharges."Index Number")
                {
                }
                column(ApproveeID;NewStudCharges.Approver_Id)
                {
                }
                column(Pic;NewStudCharges.Document_Image)
                {
                }
                column(ApprovalDateTime;NewStudCharges."Approved Date/Time")
                {
                }
                column(Status;NewStudCharges."Approval Status")
                {
                }
                column(ApprovComments;NewStudCharges."Approval Comments")
                {
                }
                column(ApprovalSequence;NewStudCharges."Approval Sequence")
                {
                }
                column(DocCode;NewStudCharges."Document Code")
                {
                }
                column(SignOffCaption;ACANewStudDocSetup."Signoff Caption")
                {
                }
                column(ReportCaption;ACANewStudDocSetup."Report Caption")
                {
                }
                column(Seq;ACANewStudDocSetup.Sequence)
                {
                }
                column(IsHostel;ACANewStudDocSetup."Is Hostel")
                {
                }
                column(ShowInReport;ACANewStudDocSetup."Hide in Report")
                {
                }
                column(ShowImageSapec;ShowImageSapec)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(ACANewStudDocSetup);
                    ACANewStudDocSetup.Reset;
                    ACANewStudDocSetup.SetRange("Academic Year",NewStudCharges."Academic Year");
                    ACANewStudDocSetup.SetRange("Document Code",NewStudCharges."Document Code");
                    if ACANewStudDocSetup.Find('-') then;
                    NewStudCharges.CalcFields(Document_Image);
                    Clear(ShowImageSapec);
                    if NewStudCharges.Document_Image.Hasvalue then ShowImageSapec := true;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ACAProgramme);
                Clear(DimensionValue);
                Clear(SchoolName);
                Clear(DepartmentName);
                ACAProgramme.Reset;
                ACAProgramme.SetRange(Code,KuccpsImports.Prog);
                if ACAProgramme.Find('-') then begin
                  DimensionValue.Reset;
                  DimensionValue.SetRange(Code,ACAProgramme."School Code");
                  if DimensionValue.Find('-') then SchoolName := DimensionValue.Name;
                    Clear(DimensionValue);
                  DimensionValue.Reset;
                  DimensionValue.SetRange(Code,ACAProgramme."Department Code");
                  if DimensionValue.Find('-') then DepartmentName := DimensionValue.Name;
                  end;
                  Clear(Sems);
                  Sems.Reset;
                  if KuccpsImports."Academic Year" <> '' then
                  Sems.SetRange("Academic Year",KuccpsImports."Academic Year");
                  Sems.SetRange("Current Semester",true);
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

    trigger OnInitReport()
    begin
        Clear(CompanyInformation);
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then  CompanyInformation.TestField(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        ACANewStudDocSetup: Record UnknownRecord77361;
        ACAProgramme: Record UnknownRecord61511;
        DimensionValue: Record "Dimension Value";
        SchoolName: Text[150];
        DepartmentName: Text[150];
        Sems: Record UnknownRecord61518;
        ShowImageSapec: Boolean;
}

