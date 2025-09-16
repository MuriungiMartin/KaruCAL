#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51190 "Hr Training needs report1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hr Training needs report1.rdlc';

    dataset
    {
        dataitem(UnknownTable61238;UnknownTable61238)
        {
            column(ReportForNavId_1102755005; 1102755005)
            {
            }
            column(Code_HRTrainingNeeds;"HRM-Training Courses"."Course Code")
            {
            }
            column(Description_HRTrainingNeeds;"HRM-Training Courses"."Course Tittle")
            {
            }
            column(NeedSource_HRTrainingNeeds;"HRM-Training Courses"."Need Source")
            {
            }
            column(StartDate_HRTrainingNeeds;"HRM-Training Courses"."Start Date")
            {
            }
            column(EndDate_HRTrainingNeeds;"HRM-Training Courses"."End Date")
            {
            }
            column(QuarterOffered_HRTrainingNeeds;"HRM-Training Courses"."Quarter Offered")
            {
            }
            column(CostOfTraining_HRTrainingNeeds;"HRM-Training Courses"."Cost Of Training")
            {
            }
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
}

