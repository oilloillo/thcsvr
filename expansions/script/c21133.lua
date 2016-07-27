--天蛾的蛊道 米斯蒂娅✿萝蕾拉
function c21133.initial_effect(c)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21133,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21133)
	e2:SetCost(c21133.cost)
	e2:SetTarget(c21133.settg)
	e2:SetOperation(c21133.setop)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21133,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c21133.rmtg)
	e3:SetOperation(c21133.rmop)
	c:RegisterEffect(e3)
end
function c21133.rfilter(c)
	return c:IsSetCard(0x208)
end
function c21133.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c21133.rfilter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c21133.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c21133.filter(c)
	return c:IsSetCard(0x522a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function c21133.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c21133.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c21133.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c21133.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c21133.rmfilter(c,sp)
	return c:GetSummonPlayer()==sp and c:IsAbleToRemove() and not c:IsPreviousLocation(LOCATION_HAND) and c:IsLocation(LOCATION_MZONE)
end
function c21133.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c21133.rmfilter,1,nil,1-tp) end
	local g=eg:Filter(c21133.rmfilter,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c21133.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetRange(LOCATION_REMOVED)
			e1:SetCountLimit(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+EVENT_PHASE+PHASE_END)
			e1:SetOperation(c21133.retop)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
function c21133.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetHandler())
	e:Reset()
end
