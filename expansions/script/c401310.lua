--深海栖舰-港湾栖姬
function c401310.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(401310,0))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_RETURN_TO_GRAVE)
	e1:SetCountLimit(1,40131001)
	e1:SetCondition(c401310.spcondtion)
	e1:SetTarget(c401310.sptarget)
	e1:SetOperation(c401310.spoperation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(401310,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_REPEAT)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c401310.con2)
	e2:SetCountLimit(1,40131002,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c401310.target)
	e2:SetOperation(c401310.activate)
	c:RegisterEffect(e2)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(401310,2))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetProperty(EFFECT_FLAG_REPEAT)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(c401310.con2)
	e6:SetCountLimit(1,40131002,EFFECT_COUNT_CODE_SINGLE)
	e6:SetTarget(c401310.target2)
	e6:SetOperation(c401310.activate2)
	c:RegisterEffect(e6)
	
end
function c401310.spcondtion(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_REMOVED
	and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c401310.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c401310.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,1,tp,tp,true,true,POS_FACEUP)>0 
	then
		c:CompleteProcedure()
	end
end
function c401310.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1 or e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c401310.filter(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function c401310.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c401310.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c401310.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(401310,2))
	local g=Duel.SelectTarget(tp,c401310.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c401310.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end
function c401310.filter2(c)
	return c:IsAbleToRemove() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c401310.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c401310.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c401310.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(401310,2))
	local g=Duel.SelectTarget(tp,c401310.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c401310.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.Remove(sg,POS_FACEDOWN,REASON_COST)
	end
end
