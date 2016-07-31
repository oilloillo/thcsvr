 
--秘弹「接下来谁都不剩了喔?」
function c22112.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22112.condition)
	e1:SetCost(c22112.cost)
	e1:SetOperation(c22112.activate)
	c:RegisterEffect(e1)
end
c22112.DescSetName = 0xa3
function c22112.spfilter0(c)
	return c:IsCode(22028)
end
function c22112.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c22112.spfilter0,tp,LOCATION_EXTRA,0,1,nil)-- and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c22112.filter(c)
	return c:IsFaceup() and (c:GetOriginalCode()==(22100) or c:GetOriginalCode()==(22117))
end
function c22112.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22112.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22112.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22112.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--turn count
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetCountLimit(1)
	e0:SetLabel(0)
	e0:SetOperation(c22112.count)
	e0:SetReset(RESET_PHASE+PHASE_END,10)
	Duel.RegisterEffect(e0,tp)
	--can't spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e0)
	e1:SetCondition(c22112.con)
	e1:SetValue(c22112.rdval)
	Duel.RegisterEffect(e1,tp)
	--discard
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e0)
	e2:SetCondition(c22112.con1)
	e2:SetTarget(c22112.distg)
	e2:SetOperation(c22112.disop)
	Duel.RegisterEffect(e2,tp)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetLabelObject(e0)
	e3:SetCondition(c22112.con2)
	e3:SetTarget(c22112.tg2)
	e3:SetOperation(c22112.op2)
	Duel.RegisterEffect(e3,tp)
end
function c22112.count(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if(ct<10) then
		ct=ct+1
		e:SetLabel(ct)
		e:GetHandler():SetTurnCounter(ct)
	end
end
function c22112.con(e,tp,eg,ep,ev,re,r,rp)
	local e0=e:GetLabelObject()
	return e0 and e0:GetHandler():GetTurnCounter() < 10
end
function c22112.rdval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return val/2
	else
		return val
	end
end
function c22112.con1(e,tp,eg,ep,ev,re,r,rp)
	local e0=e:GetLabelObject()
	return e0 and e0:GetHandler():GetTurnCounter() < 9
end
function c22112.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c22112.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
end
function c22112.con2(e,tp,eg,ep,ev,re,r,rp)
	local e0=e:GetLabelObject()
	return e0 and e0:GetHandler():GetTurnCounter() == 10
end
function c22112.spfilter(c,e,tp)
	return c:IsCode(22028) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c22112.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22112.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22112.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22112.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
