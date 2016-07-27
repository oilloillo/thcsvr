--毒✿梅蒂欣·梅兰可莉
function c25044.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25044,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,25043)
	e1:SetCost(c25044.spcost)
	e1:SetTarget(c25044.sptg)
	e1:SetOperation(c25044.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25044,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c25044.thcon)
	e2:SetTarget(c25044.thtg)
	e2:SetOperation(c25044.thop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--poison
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25044,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCountLimit(1,25043)
	e3:SetTarget(c25044.destg)
	e3:SetOperation(c25044.desop)
	c:RegisterEffect(e3)
	--Attribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_ADD_ATTRIBUTE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e4)
end
function c25044.cfilter(c)
	return c:IsSetCard(0x208) and c:IsReleasable()
end
function c25044.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		or Duel.IsExistingMatchingCard(c25044.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()))
		and Duel.CheckReleaseGroupEx(tp,c25044.cfilter,1,e:GetHandler()) end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.SelectReleaseGroupEx(tp,c25044.cfilter,1,2,e:GetHandler())
		e:SetLabel(g:GetCount())
		Duel.Release(g,REASON_COST)
	else
		local g=Duel.SelectReleaseGroupEx(tp,c25044.cfilter,1,1,e:GetHandler())
		if g:GetFirst():GetLocation()==LOCATION_HAND then
			local g1=Duel.SelectReleaseGroup(tp,c25044.cfilter,1,1,e:GetHandler())
			g:Merge(g1)
		elseif Duel.SelectYesNo(tp,aux.Stringid(25044,3)) then
			local g1=Duel.SelectReleaseGroupEx(tp,c25044.cfilter,1,1,e:GetHandler())
			g:Merge(g1)
		end
		e:SetLabel(g:GetCount())
		Duel.Release(g,REASON_COST)
	end
end
function c25044.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c25044.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
function c25044.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c25044.thfilter(c)
	return c:IsSetCard(0x164) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c25044.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c25044.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c25044.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c25044.thfilter,tp,LOCATION_DECK,0,ct,ct,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c25044.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c25044.desop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetLabel(0)
	e2:SetCondition(c25044.damcon)
	e2:SetOperation(c25044.damop)
	e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,3)
	Duel.RegisterEffect(e2,tp)
end
function c25044.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c25044.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if(ct<3) then
		ct=ct+1
		e:SetLabel(ct)
		c:SetTurnCounter(ct)
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
