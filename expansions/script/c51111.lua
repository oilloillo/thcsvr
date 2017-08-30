--摇曳百合✿大室樱子
function c51111.initial_effect(c)
   	--Pendulum
	aux.EnablePendulumAttribute(c)
	--splimit
	--local e8=Effect.CreateEffect(c)
	--e8:SetType(EFFECT_TYPE_FIELD)
	--e8:SetRange(LOCATION_PZONE)
	--e8:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	--e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	--e8:SetTargetRange(1,0)
	--e8:SetTarget(c51111.splimit)
	--c:RegisterEffect(e8)
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51111,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c51111.cost)
	e2:SetCountLimit(1)
	e2:SetTarget(c51111.target)
	e2:SetCondition(c51111.condition)
    e2:SetOperation(c51111.operation)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(51111,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,51111)
	e3:SetTarget(c51111.sptg)
	e3:SetOperation(c51111.spop)
	c:RegisterEffect(e3)
		--scale
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c51111.sccon)
	e4:SetValue(2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e5)
end
function c51111.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x511) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c51111.condition(e)
	return e:GetHandler():GetFlagEffect(51112)>0
end
function c51111.costfilter(c)
	return c:IsCode(51107) and c:IsAbleToRemoveAsCost()
end
function c51111.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51111.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c51111.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c51111.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c51111.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
	end
end

function c51111.spfilter(c,e,tp)
	return c:IsCode(51112) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c51111.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsReleasable()
		and Duel.IsExistingMatchingCard(c51111.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)


end
function c51111.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.Release(c,nil,2,REASON_EFFECT)~=0 then
		local tc=Duel.GetFirstMatchingCard(c51111.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
 
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
		tc:RegisterFlagEffect(51111,RESET_EVENT+0x1fe0000,0,0)
		Duel.SpecialSummonComplete()
	end
  end
end
function c51111.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return tc and tc:IsCode(51112)
end
