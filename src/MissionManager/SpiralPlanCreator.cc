/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "SpiralPlanCreator.h"
#include "PlanMasterController.h"
#include "SpiralComplexItem.h"

SpiralPlanCreator::SpiralPlanCreator(PlanMasterController* planMasterController, QObject* parent)
    : PlanCreator(planMasterController, SpiralComplexItem::name, QStringLiteral("/qmlimages/PlanCreator/SpiralPlanCreator.png"), parent)
{

}

void SpiralPlanCreator::createPlan(const QGeoCoordinate& mapCenterCoord)
{
    _planMasterController->removeAll();
    VisualMissionItem* takeoffItem = _missionController->insertTakeoffItem(mapCenterCoord, -1);
    _missionController->insertComplexMissionItem(SpiralComplexItem::name, mapCenterCoord, -1);
    _missionController->insertLandItem(mapCenterCoord, -1);
    _missionController->setCurrentPlanViewSeqNum(takeoffItem->sequenceNumber(), true);
}
