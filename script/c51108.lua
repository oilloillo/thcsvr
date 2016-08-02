--摇曳百合✿吉川千夏
function c51108.initial_effect(c)
	--Pendulum
	aux.EnablePendulumAttribute(c)

	--extra summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e4:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e4:SetTarget(c51108.sutg)
	c:RegisterEffect(e4)
	--除外
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(51108,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetTarget(c51108.destg)
	e3:SetCondition(c51108.indcon)
	e3:SetOperation(c51108.desop)
	c:RegisterEffect(e3)
	--检索
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(51108,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c51108.cost)
	e6:SetTarget(c51108.target)
	e6:SetOperation(c51108.operation)
	c:RegisterEffect(e6)

end
function c51108.filter(c)
	return c:IsCode(51107) and c:IsAbleToHand() and c:IsFaceup()
end
function c51108.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c51108.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51108.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c51108.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c51108.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c51108.sutg(e,c)
	return c:IsSetCard(0x511)
end
function c51108.indcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp~=e:GetHandler():GetControler() and (ph==PHASE_BATTLE or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
end
function c51108.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c51108.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT) end
end




