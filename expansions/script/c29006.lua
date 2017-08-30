 
--辘轳首的怪奇✿赤蛮奇
function c29006.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29006,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c29006.cost)
	e1:SetTarget(c29006.target)
	e1:SetOperation(c29006.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29006,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c29006.spcon)
	e2:SetTarget(c29006.sptg)
	e2:SetOperation(c29006.spop)
	c:RegisterEffect(e2)
end

c29006.DescSetName=0x826

function c29006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,29006)==0 and e:GetHandler():GetAttack()>=800 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(-800)
	e:GetHandler():RegisterEffect(e1)
	Duel.RegisterFlagEffect(tp,29006,RESET_PHASE+PHASE_END,0,1)
end
function c29006.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c29006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c29006.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29006.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c29006.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c29006.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c29006.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c29006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c29006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(0)
		--c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x47e0000)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2,true)
	end
end
